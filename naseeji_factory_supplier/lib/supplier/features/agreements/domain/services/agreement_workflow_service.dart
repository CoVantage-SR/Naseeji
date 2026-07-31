import '../entities/agreement_model.dart';
import 'agreement_validation_service.dart';

class AgreementWorkflowNotification {
  final String title;
  final String message;
  final String recipientRole; // 'supplier', 'factory', 'both'
  final DateTime timestamp;

  AgreementWorkflowNotification({
    required this.title,
    required this.message,
    required this.recipientRole,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class AgreementWorkflowResult {
  final B2BAgreement agreement;
  final List<AgreementWorkflowNotification> notifications;
  final String? productionOrderId;

  const AgreementWorkflowResult({
    required this.agreement,
    required this.notifications,
    this.productionOrderId,
  });
}

class AgreementWorkflowService {
  /// إنشاء اتفاق جديد تلقائياً بعد قبول عرض السعر (بدون إعادة كتابة البيانات)
  static B2BAgreement createAutoAgreement({
    required String rfqNumber,
    required String quotationNumber,
    required String orderNumber,
    required SupplierInfo supplierInfo,
    required FactoryInfo factoryInfo,
    required AgreementProduct product,
    required ProductionInfo production,
    required PaymentInfo payment,
    required DeliveryInfo delivery,
    List<AgreementDocument>? documents,
  }) {
    final DateTime now = DateTime.now();
    final String dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final String timeStr =
        '${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? "م" : "ص"}';
    final String agreementId = 'AGR-2026-${now.millisecondsSinceEpoch.toString().substring(7)}';

    final initialStep = AgreementTimelineStep(
      date: dateStr,
      time: timeStr,
      user: 'نظام نسيجي التلقائي',
      status: 'إنشاء الاتفاقية تلقائياً',
      notes: 'تم قبول عرض السعر رقم ($quotationNumber) وتوليد بنود الاتفاقية بدون إعادة أدخال بيانات.',
      attachments: documents?.map((d) => d.name).toList() ?? [],
    );

    final initialHistory = AgreementHistoryRecord(
      timestamp: '$dateStr $timeStr',
      user: 'النظام الآلي',
      action: 'إنشاء مسودة الاتفاق الموثقة',
      reason: 'قبول عرض السعر $quotationNumber لطلب $rfqNumber',
      versionNumber: '1.0',
    );

    return B2BAgreement(
      id: agreementId,
      rfqNumber: rfqNumber,
      quotationNumber: quotationNumber,
      orderNumber: orderNumber,
      createdDate: dateStr,
      lastUpdated: dateStr,
      version: '1.0',
      status: AgreementStatus.awaitingSupplierSignature,
      supplierInfo: supplierInfo,
      factoryInfo: factoryInfo,
      product: product,
      production: production,
      payment: payment,
      delivery: delivery,
      terms: AgreementTerms.defaultTerms,
      documents: documents ?? [],
      supplierSignature: null,
      factorySignature: null,
      timeline: [initialStep],
      history: [initialHistory],
    );
  }

  /// تنفيذ توقيع المورد
  static AgreementWorkflowResult processSupplierSignature({
    required B2BAgreement agreement,
    required String supplierUserId,
    required String supplierUserName,
  }) {
    final validation = AgreementValidationService.validateSupplierSignature(agreement);
    if (!validation.isValid) {
      throw StateError(validation.errorMessage ?? 'توقيع المورد غير ممكن.');
    }

    final DateTime now = DateTime.now();
    final String dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final String timeStr =
        '${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? "م" : "ص"}';

    final sigInfo = SignatureInfo(
      userName: supplierUserName,
      userId: supplierUserId,
      date: dateStr,
      time: timeStr,
      isSigned: true,
    );

    final timelineStep = AgreementTimelineStep(
      date: dateStr,
      time: timeStr,
      user: 'المورد ($supplierUserName)',
      status: 'توقيع الاتفاقية من المورد',
      notes: 'قام المورد بتوقيع الاتفاقية رسمياً والموافقة على كافة الشروط والبنود (مُعرف: $supplierUserId).',
      attachments: const [],
    );

    final historyRecord = AgreementHistoryRecord(
      timestamp: '$dateStr $timeStr',
      user: supplierUserName,
      action: 'توقيع واعتماد المورد',
      reason: 'تأكيد الالتزام بالإنتاج والتوريد',
      versionNumber: agreement.version,
    );

    final updatedAgreement = agreement.copyWith(
      status: AgreementStatus.awaitingFactorySignature,
      supplierSignature: sigInfo,
      lastUpdated: dateStr,
      timeline: List.from(agreement.timeline)..add(timelineStep),
      history: List.from(agreement.history)..add(historyRecord),
    );

    final notification = AgreementWorkflowNotification(
      title: 'تم توقيع الاتفاقية من المورد ✍️',
      message:
          'قام المورد ${agreement.supplierInfo.companyName} بتوقيع الاتفاق رقم (${agreement.id}). الاتفاق في انتظار توقيعك الآن.',
      recipientRole: 'factory',
    );

    return AgreementWorkflowResult(
      agreement: updatedAgreement,
      notifications: [notification],
    );
  }

  /// تنفيذ توقيع المصنع وتفعيل الاتفاق وأمر الإنتاج
  static AgreementWorkflowResult processFactorySignature({
    required B2BAgreement agreement,
    required String factoryUserId,
    required String factoryUserName,
  }) {
    final validation = AgreementValidationService.validateFactorySignature(agreement);
    if (!validation.isValid) {
      throw StateError(validation.errorMessage ?? 'توقيع المصنع غير ممكن.');
    }

    final DateTime now = DateTime.now();
    final String dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final String timeStr =
        '${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? "م" : "ص"}';
    final String prodOrderId = 'PRD-${now.millisecondsSinceEpoch.toString().substring(7)}';

    final sigInfo = SignatureInfo(
      userName: factoryUserName,
      userId: factoryUserId,
      date: dateStr,
      time: timeStr,
      isSigned: true,
    );

    final timelineStep = AgreementTimelineStep(
      date: dateStr,
      time: timeStr,
      user: 'المصنع ($factoryUserName)',
      status: 'توقيع المصنع وتحول الاتفاق إلى ساري',
      notes: 'تم التوقيع النهائي من المصنع، وتفعيل العقد رسمياً، وإصدار أمر الإنتاج رقم ($prodOrderId).',
      attachments: const [],
    );

    final historyRecord = AgreementHistoryRecord(
      timestamp: '$dateStr $timeStr',
      user: factoryUserName,
      action: 'توقيع المصنع وبدء خطة الإنتاج',
      reason: 'اعتماد العقد النهائي وإصدار أمر الإنتاج $prodOrderId',
      versionNumber: agreement.version,
    );

    final updatedAgreement = agreement.copyWith(
      status: AgreementStatus.active,
      factorySignature: sigInfo,
      productionOrderId: prodOrderId,
      lastUpdated: dateStr,
      timeline: List.from(agreement.timeline)..add(timelineStep),
      history: List.from(agreement.history)..add(historyRecord),
    );

    final factoryNotification = AgreementWorkflowNotification(
      title: 'تم تفعيل الاتفاق بنجاح 🎉',
      message: 'أصبح الاتفاق رقم (${agreement.id}) سارياً رسمياً. تم توليد أمر الإنتاج رقم ($prodOrderId).',
      recipientRole: 'factory',
    );

    final supplierNotification = AgreementWorkflowNotification(
      title: 'المصنع قام بتوقيع الاتفاقية! 🚀',
      message: 'وقع المصنع ${agreement.factoryInfo.factoryName} الاتفاق (${agreement.id}). يمكنك بدء خطة التصنيع الآن.',
      recipientRole: 'supplier',
    );

    return AgreementWorkflowResult(
      agreement: updatedAgreement,
      notifications: [factoryNotification, supplierNotification],
      productionOrderId: prodOrderId,
    );
  }

  /// نقل حالة الطلب إلى مرحلة الإنتاج الفعلي
  static AgreementWorkflowResult moveToProduction(B2BAgreement agreement) {
    final validation = AgreementValidationService.validateProductionStart(agreement);
    if (!validation.isValid) {
      throw StateError(validation.errorMessage ?? 'لا يمكن الانتقال للإنتاج.');
    }

    final DateTime now = DateTime.now();
    final String dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final String timeStr =
        '${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? "م" : "ص"}';

    final timelineStep = AgreementTimelineStep(
      date: dateStr,
      time: timeStr,
      user: 'المورد (${agreement.supplierInfo.supplierName})',
      status: 'بدء الإنتاج الفعلي بالمصنع',
      notes: 'بدأت عملية التصنيع والتجهيز بناءً على الجدول الزمني وأمر الإنتاج رقم (${agreement.productionOrderId}).',
      attachments: const [],
    );

    final updated = agreement.copyWith(
      status: AgreementStatus.inProduction,
      lastUpdated: dateStr,
      timeline: List.from(agreement.timeline)..add(timelineStep),
    );

    return AgreementWorkflowResult(
      agreement: updated,
      notifications: [
        AgreementWorkflowNotification(
          title: 'بدء خط الإنتاج 🏭',
          message: 'بدأ المورد في تصنيع الطلب للاتفاقية رقم (${agreement.id}).',
          recipientRole: 'both',
        ),
      ],
    );
  }
}

