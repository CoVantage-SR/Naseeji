import 'package:naseeji_supplier/features/messages/domain/entities/deal_workspace_model.dart';
import 'package:naseeji_supplier/features/messages/domain/entities/deal_status_enum.dart';
import 'package:naseeji_supplier/features/messages/domain/entities/deal_quotation_model.dart';
import 'package:naseeji_supplier/features/messages/domain/entities/deal_agreement_model.dart';
import 'package:naseeji_supplier/features/messages/domain/entities/deal_file_model.dart';
import 'package:naseeji_supplier/features/messages/domain/entities/deal_timeline_model.dart';
import 'package:naseeji_supplier/features/messages/domain/entities/business_message.dart';

abstract class DealWorkspaceRemoteDatasource {
  Future<DealWorkspaceModel> fetchDealWorkspace(String dealId);
  Future<BusinessMessage> sendMessage({required String dealId, required String text, String? attachmentUrl});
  Future<bool> sendNewOfferVersion({
    required String dealId,
    required double unitPrice,
    required int quantity,
    required String productionLeadTime,
    required String validityPeriod,
    required String paymentTerms,
    required String deliveryTerms,
    DateTime? expectedDeliveryDate,
    String? notes,
  });
  Future<bool> updateDealStatus(String dealId, DealStatus newStatus);
  Future<bool> acceptQuotation(String dealId);
  Future<bool> rejectQuotation(String dealId);
}

class DealWorkspaceRemoteDatasourceImpl implements DealWorkspaceRemoteDatasource {
  static final _initialV1 = DealQuotationModel(
    quotationId: 'QUO-8840-V1',
    versionNumber: 1,
    unitPrice: 45.0,
    totalPrice: 450000.0,
    quantity: 10000,
    moq: 500,
    productionLeadTime: '٧ أيام عمل',
    validityPeriod: '١٥ يوم من تاريخ العرض',
    paymentTerms: '٥٠٪ دفعة مقدمة حجز + ٥٠٪ عند اعتماد التسليم بالضمين (Escrow)',
    deliveryTerms: 'تسليم بمستودع المصنع مباشرة',
    expectedDeliveryDate: DateTime.now().add(const Duration(days: 10)),
    notes: 'العرض شامل شهادة الاختبارات المعملية واختبارات الجودة ISO.',
    offerStatus: OfferStatus.counterOffer,
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    createdByRole: 'المورد',
  );

  static final _initialV2 = DealQuotationModel(
    quotationId: 'QUO-8840-V2',
    versionNumber: 2,
    unitPrice: 43.0,
    totalPrice: 430000.0,
    quantity: 10000,
    moq: 500,
    productionLeadTime: '٦ أيام عمل',
    validityPeriod: '١٥ يوم من تاريخ العرض',
    paymentTerms: '٥٠٪ دفعة مقدمة + ٥٠٪ عند الاستلام بالضمين',
    deliveryTerms: 'تسليم بمستودع المصنع مباشرة',
    expectedDeliveryDate: DateTime.now().add(const Duration(days: 8)),
    notes: 'تم تقديم خصم خاص 4% تلبية لطلب تعديل المصنع.',
    offerStatus: OfferStatus.sent,
    createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    createdByRole: 'المورد',
  );

  late DealWorkspaceModel _mockWorkspace;

  DealWorkspaceRemoteDatasourceImpl() {
    _mockWorkspace = DealWorkspaceModel(
      dealId: 'deal-101',
      orderId: 'ORD-2304',
      rfqId: 'RFQ-1025',
      productName: 'غزل قطن 100% ممتاز تمشيط عالي 30/1',
      dealValue: 430000.0,
      totalQuantity: 10000,
      factoryName: 'شركة النسيج الحديثة للملابس',
      factoryAvatarUrl: 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?auto=format&fit=crop&w=200&q=80',
      isFactoryOnline: true,
      isFactoryVerified: true,
      currentStatus: DealStatus.negotiating,
      messages: [
        BusinessMessage.create(
          id: 'msg-sys-0',
          senderId: 'system',
          senderName: 'النظام',
          text: 'تم إنشاء الصفقة تلقائياً بناءً على طلب عرض السعر RFQ-1025',
          timestamp: DateTime.now().subtract(const Duration(hours: 6)),
          isMe: false,
          isSystemNotification: true,
        ),
        BusinessMessage.create(
          id: 'msg-1',
          senderId: 'factory-1',
          senderName: 'شركة النسيج الحديثة',
          text: 'السلام عليكم، استلمنا مواصفات خيوط غزل القطن الممشط ونرغب في طلب 10,000 كجم.',
          timestamp: DateTime.now().subtract(const Duration(hours: 5, minutes: 30)),
          isMe: false,
        ),
        BusinessMessage.create(
          id: 'msg-sys-1',
          senderId: 'system',
          senderName: 'النظام',
          text: 'تم إرسال عرض السعر الإصدار رقم 1 (Version 1) بقيمة 450,000 ج.م',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          isMe: false,
          isSystemNotification: true,
        ),
        BusinessMessage.create(
          id: 'msg-sys-2',
          senderId: 'system',
          senderName: 'النظام',
          text: 'طلب المصنع تعديل العرض (السعر وميعاد التسليم)',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          isMe: false,
          isSystemNotification: true,
        ),
        BusinessMessage.create(
          id: 'msg-sys-3',
          senderId: 'system',
          senderName: 'النظام',
          text: 'تم تعديل العرض وإرسال الإصدار رقم 2 (Version 2) بقيمة 430,000 ج.م',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          isMe: false,
          isSystemNotification: true,
        ),
        BusinessMessage.create(
          id: 'msg-3',
          senderId: 'factory-1',
          senderName: 'شركة النسيج الحديثة',
          text: 'العرض الجديد مناسب جداً، جاري اعتماده والموافقة للبدء في إجراءات العقد 🟢',
          timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
          isMe: false,
        ),
      ],
      latestQuotation: _initialV2,
      quotationHistory: [_initialV1, _initialV2],
      finalAgreement: DealAgreementModel(
        agreementId: 'AGR-9920',
        finalTotalPrice: 430000.0,
        finalQuantity: 10000,
        deliveryDate: '٢٨ يوليو ٢٠٢٦',
        pickupLocation: 'مخزن المحلة الكبرى - المنطقة الصناعية الأولى',
        paymentMethod: 'نظام الدفع الضامن المنفذ عبر المنصة (Escrow)',
        status: 'بانتظار الاعتماد النهائي من المصنع 🟢',
        isApprovedBySupplier: true,
        isApprovedByFactory: false,
        approvedAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      files: [
        DealFileModel(
          fileId: 'f-1',
          fileName: 'كتالوج_خيوط_الغزل_الممشط_2026.pdf',
          fileUrl: 'https://example.com/docs/catalog.pdf',
          fileSize: '4.2 MB',
          fileType: DealFileType.catalog,
          uploadedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        DealFileModel(
          fileId: 'f-2',
          fileName: 'شهادة_الجودة_المصرية_ISO_9001.pdf',
          fileUrl: 'https://example.com/docs/iso_cert.pdf',
          fileSize: '1.8 MB',
          fileType: DealFileType.qualityCert,
          uploadedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
      timeline: const DealTimelineModel(
        currentStepIndex: 2,
        steps: [
          DealTimelineStep(stepIndex: 0, title: 'تم إنشاء الصفقة', subtitle: 'استلام RFQ-1025 من المصنع', isCompleted: true, isCurrent: false),
          DealTimelineStep(stepIndex: 1, title: 'تم إرسال عرض السعر V1', subtitle: 'تقديم عرض سعر 45 جنيه/كجم', isCompleted: true, isCurrent: false),
          DealTimelineStep(stepIndex: 2, title: 'تم تعديل العرض V2', subtitle: 'تقديم عرض جديد 43 جنيه/كجم', isCompleted: true, isCurrent: true),
          DealTimelineStep(stepIndex: 3, title: 'تم قبول العرض', isCompleted: false, isCurrent: false),
          DealTimelineStep(stepIndex: 4, title: 'تم إنشاء الاتفاق والعقد', isCompleted: false, isCurrent: false),
          DealTimelineStep(stepIndex: 5, title: 'بدأ الإنتاج والتصنيع', isCompleted: false, isCurrent: false),
          DealTimelineStep(stepIndex: 6, title: 'تم التسليم للمصنع', isCompleted: false, isCurrent: false),
          DealTimelineStep(stepIndex: 7, title: 'تم قبول الجودة المعملية', isCompleted: false, isCurrent: false),
          DealTimelineStep(stepIndex: 8, title: 'تم تحويل المستحقات (Escrow)', isCompleted: false, isCurrent: false),
        ],
      ),
    );
  }

  @override
  Future<DealWorkspaceModel> fetchDealWorkspace(String dealId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _mockWorkspace;
  }

  @override
  Future<BusinessMessage> sendMessage({
    required String dealId,
    required String text,
    String? attachmentUrl,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final newMsg = BusinessMessage.create(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'supplier-1',
      senderName: 'م/ محمد النسيج',
      text: text,
      timestamp: DateTime.now(),
      isMe: true,
    );

    final updatedMessages = List<BusinessMessage>.from(_mockWorkspace.messages)..add(newMsg);
    _mockWorkspace = _mockWorkspace.copyWith(messages: updatedMessages);
    return newMsg;
  }

  @override
  Future<bool> sendNewOfferVersion({
    required String dealId,
    required double unitPrice,
    required int quantity,
    required String productionLeadTime,
    required String validityPeriod,
    required String paymentTerms,
    required String deliveryTerms,
    DateTime? expectedDeliveryDate,
    String? notes,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final nextVersion = _mockWorkspace.quotationHistory.length + 1;
    final newQuotation = DealQuotationModel(
      quotationId: 'QUO-8840-V$nextVersion',
      versionNumber: nextVersion,
      unitPrice: unitPrice,
      totalPrice: unitPrice * quantity,
      quantity: quantity,
      moq: _mockWorkspace.latestQuotation.moq,
      productionLeadTime: productionLeadTime,
      validityPeriod: validityPeriod,
      paymentTerms: paymentTerms,
      deliveryTerms: deliveryTerms,
      expectedDeliveryDate: expectedDeliveryDate ?? DateTime.now().add(const Duration(days: 7)),
      notes: notes ?? '',
      offerStatus: OfferStatus.sent,
      createdAt: DateTime.now(),
      createdByRole: 'المورد',
    );

    final history = List<DealQuotationModel>.from(_mockWorkspace.quotationHistory)..add(newQuotation);

    final sysMsg = BusinessMessage.create(
      id: 'sys-${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'system',
      senderName: 'النظام',
      text: 'تم إرسال عرض سعر جديد (الإصدار رقم $nextVersion - Version $nextVersion) بقيمة ${(unitPrice * quantity).toStringAsFixed(0)} ج.م',
      timestamp: DateTime.now(),
      isMe: false,
      isSystemNotification: true,
    );

    final updatedMsgs = List<BusinessMessage>.from(_mockWorkspace.messages)..add(sysMsg);

    _mockWorkspace = _mockWorkspace.copyWith(
      latestQuotation: newQuotation,
      quotationHistory: history,
      dealValue: unitPrice * quantity,
      totalQuantity: quantity,
      messages: updatedMsgs,
      currentStatus: DealStatus.awaitingResponse,
      lastUpdated: DateTime.now(),
    );

    return true;
  }

  @override
  Future<bool> acceptQuotation(String dealId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final acceptedQuotation = _mockWorkspace.latestQuotation.copyWith(
      offerStatus: OfferStatus.accepted,
    );

    final history = List<DealQuotationModel>.from(_mockWorkspace.quotationHistory);
    if (history.isNotEmpty) {
      history[history.length - 1] = acceptedQuotation;
    }

    final sysMsg = BusinessMessage.create(
      id: 'sys-${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'system',
      senderName: 'النظام',
      text: 'تم قبول عرض السعر (Version ${acceptedQuotation.versionNumber}) رسميًا وإنشاء الاتفاق والعقد الإلكتروني 🟢',
      timestamp: DateTime.now(),
      isMe: false,
      isSystemNotification: true,
    );

    final updatedMsgs = List<BusinessMessage>.from(_mockWorkspace.messages)..add(sysMsg);

    _mockWorkspace = _mockWorkspace.copyWith(
      latestQuotation: acceptedQuotation,
      quotationHistory: history,
      messages: updatedMsgs,
      currentStatus: DealStatus.agreed,
      lastUpdated: DateTime.now(),
    );

    return true;
  }

  @override
  Future<bool> rejectQuotation(String dealId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final rejectedQuotation = _mockWorkspace.latestQuotation.copyWith(
      offerStatus: OfferStatus.rejected,
    );

    final history = List<DealQuotationModel>.from(_mockWorkspace.quotationHistory);
    if (history.isNotEmpty) {
      history[history.length - 1] = rejectedQuotation;
    }

    final sysMsg = BusinessMessage.create(
      id: 'sys-${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'system',
      senderName: 'النظام',
      text: 'تم رفض عرض السعر الحالي (Version ${rejectedQuotation.versionNumber})',
      timestamp: DateTime.now(),
      isMe: false,
      isSystemNotification: true,
    );

    final updatedMsgs = List<BusinessMessage>.from(_mockWorkspace.messages)..add(sysMsg);

    _mockWorkspace = _mockWorkspace.copyWith(
      latestQuotation: rejectedQuotation,
      quotationHistory: history,
      messages: updatedMsgs,
      lastUpdated: DateTime.now(),
    );

    return true;
  }

  @override
  Future<bool> updateDealStatus(String dealId, DealStatus newStatus) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _mockWorkspace = _mockWorkspace.copyWith(currentStatus: newStatus);
    return true;
  }
}
