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
  Future<bool> sendCounterOffer({required String dealId, required double newUnitPrice, required int quantity});
  Future<bool> updateDealStatus(String dealId, DealStatus newStatus);
}

class DealWorkspaceRemoteDatasourceImpl implements DealWorkspaceRemoteDatasource {
  DealWorkspaceModel _mockWorkspace = DealWorkspaceModel(
    dealId: 'deal-101',
    orderId: 'ORD-2304',
    rfqId: 'RFQ-1025',
    factoryName: 'شركة النسيج الحديثة للملابس',
    factoryAvatarUrl: 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?auto=format&fit=crop&w=200&q=80',
    isFactoryOnline: true,
    isFactoryVerified: true,
    currentStatus: DealStatus.negotiating,
    messages: [
      BusinessMessage(
        id: 'msg-1',
        senderId: 'factory-1',
        senderName: 'شركة النسيج الحديثة',
        text: 'السلام عليكم، استلمنا مواصفات خيوط غزل القطن الممشط 30/1 ونرغب في طلب 1000 كجم.',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        isMe: false,
      ),
      BusinessMessage(
        id: 'msg-2',
        senderId: 'supplier-1',
        senderName: 'م/ محمد النسيج',
        text: 'وعليكم السلام ورحمة الله. أهلاً بحضرتك. الخامة جاهزة ومفحوصة بالكامل مع شهادة ISO.',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isMe: true,
      ),
      BusinessMessage(
        id: 'msg-sys-1',
        senderId: 'system',
        senderName: 'النظام',
        text: 'تم إرسال عرض سعر جديد بقيمة 45,000 ج.م',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isMe: false,
        isSystemNotification: true,
      ),
      BusinessMessage(
        id: 'msg-3',
        senderId: 'factory-1',
        senderName: 'شركة النسيج الحديثة',
        text: 'هل يمكن تقديم خصم 5% على إجمالي الكمية وتجهيز الشحنة خلال 48 ساعة؟',
        timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        isMe: false,
      ),
    ],
    latestQuotation: DealQuotationModel(
      quotationId: 'QUO-8840',
      unitPrice: 45.0,
      totalPrice: 45000.0,
      quantity: 1000,
      moq: 100,
      productionLeadTime: '٧ أيام عمل',
      validityPeriod: '١٥ يوم من تاريخ العرض',
      paymentTerms: '٥٠٪ دفعة مقدمة حجز + ٥٠٪ عند اعتماد التسليم بالضمين (Escrow)',
      status: 'قيد التفاوض والتشاور',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    finalAgreement: DealAgreementModel(
      agreementId: 'AGR-9920',
      finalTotalPrice: 43500.0,
      finalQuantity: 1000,
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
      DealFileModel(
        fileId: 'f-3',
        fileName: 'صورة_عينة_النسيج_والاختبار.jpg',
        fileUrl: 'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=400&q=80',
        fileSize: '850 KB',
        fileType: DealFileType.image,
        uploadedAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ],
    timeline: const DealTimelineModel(
      currentStepIndex: 2,
      steps: [
        DealTimelineStep(stepIndex: 0, title: 'تم إنشاء RFQ', subtitle: 'استلام طلب السعر من المصنع', isCompleted: true, isCurrent: false),
        DealTimelineStep(stepIndex: 1, title: 'تم إرسال عرض السعر', subtitle: 'تقديم عرض سعر 45 جنيه/كجم', isCompleted: true, isCurrent: false),
        DealTimelineStep(stepIndex: 2, title: 'بدأ التفاوض', subtitle: 'محادثة جارية حول الخصم وميعاد التسليم', isCompleted: true, isCurrent: true),
        DealTimelineStep(stepIndex: 3, title: 'تم إرسال عرض مضاد', isCompleted: false, isCurrent: false),
        DealTimelineStep(stepIndex: 4, title: 'تم قبول العرض', isCompleted: false, isCurrent: false),
        DealTimelineStep(stepIndex: 5, title: 'تم اعتماد الاتفاق', isCompleted: false, isCurrent: false),
        DealTimelineStep(stepIndex: 6, title: 'بدأ الإنتاج', isCompleted: false, isCurrent: false),
        DealTimelineStep(stepIndex: 7, title: 'جاهز للاستلام', isCompleted: false, isCurrent: false),
        DealTimelineStep(stepIndex: 8, title: 'استلمت شركة الشحن الطلب', isCompleted: false, isCurrent: false),
        DealTimelineStep(stepIndex: 9, title: 'تم التسليم', isCompleted: false, isCurrent: false),
        DealTimelineStep(stepIndex: 10, title: 'تم تحويل المستحقات', isCompleted: false, isCurrent: false),
      ],
    ),
  );

  @override
  Future<DealWorkspaceModel> fetchDealWorkspace(String dealId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockWorkspace;
  }

  @override
  Future<BusinessMessage> sendMessage({
    required String dealId,
    required String text,
    String? attachmentUrl,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final newMsg = BusinessMessage(
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
  Future<bool> sendCounterOffer({
    required String dealId,
    required double newUnitPrice,
    required int quantity,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final updatedQuotation = DealQuotationModel(
      quotationId: 'QUO-8841',
      unitPrice: newUnitPrice,
      totalPrice: newUnitPrice * quantity,
      quantity: quantity,
      moq: _mockWorkspace.latestQuotation.moq,
      productionLeadTime: _mockWorkspace.latestQuotation.productionLeadTime,
      validityPeriod: _mockWorkspace.latestQuotation.validityPeriod,
      paymentTerms: _mockWorkspace.latestQuotation.paymentTerms,
      status: 'تم تقديم عرض مضاد من المورد',
      createdAt: DateTime.now(),
    );

    final systemNotif = BusinessMessage(
      id: 'sys-${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'system',
      senderName: 'النظام',
      text: 'قام المورد بإرسال عرض سعر مضاد بقيمة ${(newUnitPrice * quantity).toStringAsFixed(0)} ج.م',
      timestamp: DateTime.now(),
      isMe: false,
      isSystemNotification: true,
    );

    final updatedMsgs = List<BusinessMessage>.from(_mockWorkspace.messages)..add(systemNotif);
    _mockWorkspace = _mockWorkspace.copyWith(
      latestQuotation: updatedQuotation,
      messages: updatedMsgs,
      currentStatus: DealStatus.awaitingResponse,
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
