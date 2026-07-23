import 'supplier_mock.dart';
import 'product_mock.dart';
import 'deal_mock.dart';
import 'quotation_mock.dart';
import 'chat_mock.dart';
import 'message_mock.dart';
import 'agreement_mock.dart';
import 'timeline_mock.dart';
import 'notification_mock.dart';
import 'package:naseeji_supplier/features/messages/domain/entities/deal_workspace_model.dart';
import 'package:naseeji_supplier/features/messages/domain/entities/deal_quotation_model.dart';
import 'package:naseeji_supplier/features/messages/domain/entities/deal_status_enum.dart';
import 'package:naseeji_supplier/features/messages/domain/entities/conversation.dart';
import 'package:naseeji_supplier/features/messages/domain/entities/deal_timeline_model.dart';

class MockDatabase {
  MockDatabase._();

  // 1. Supplier
  static SupplierMock supplier = SupplierMock.defaultSupplier;

  // 2. Products
  static List<ProductMock> products = List.from(ProductMock.sampleProducts);

  // 3. Deals
  static List<DealMock> deals = List.from(DealMock.sampleDeals);

  // 4. Quotations / Offer Versions
  static List<QuotationMock> quotations = List.from(QuotationMock.sampleQuotations);

  // 5. Chats
  static List<ChatMock> chats = List.from(ChatMock.sampleChats);

  // 6. Messages
  static List<MessageMock> messages = List.from(MessageMock.sampleMessages);

  // 7. Agreements
  static List<AgreementMock> agreements = List.from(AgreementMock.sampleAgreements);

  // 8. Timelines
  static Map<String, TimelineMock> timelines = {
    'DEAL-101': TimelineMock.sampleTimeline,
  };

  // 9. Notifications
  static List<NotificationMock> notifications = List.from(NotificationMock.sampleNotifications);

  // ─── Query Helper Methods ──────────────────────────────────────────────

  static ProductMock? getProductById(String productId) {
    try {
      return products.firstWhere((p) => p.id == productId);
    } catch (_) {
      return products.first;
    }
  }

  static DealMock? getDealById(String dealId) {
    try {
      return deals.firstWhere((d) => d.dealId == dealId || d.rfqId == dealId || d.orderId == dealId);
    } catch (_) {
      return deals.first;
    }
  }

  static List<Conversation> getConversationsDomain() {
    return chats.map((c) => c.toDomain()).toList();
  }

  static DealWorkspaceModel getDealWorkspace(String dealId) {
    final deal = getDealById(dealId) ?? deals.first;
    final dealIdTarget = deal.dealId;

    final dealMsgs = messages.where((m) => m.dealId == dealIdTarget).toList();
    final dealQuos = quotations.where((q) => q.dealId == dealIdTarget).toList();
    final dealAgr = agreements.where((a) => a.dealId == dealIdTarget).firstOrNull;
    final dealTimeline = timelines[dealIdTarget] ?? TimelineMock.sampleTimeline;

    return deal.toWorkspaceDomain(
      messages: dealMsgs,
      quotations: dealQuos.isEmpty ? QuotationMock.sampleQuotations : dealQuos,
      agreement: dealAgr,
      timeline: dealTimeline,
    );
  }

  // ─── Interactive Workflow Action Triggers ─────────────────────────────

  /// 1. Create a new Deal from RFQ or Product
  static String createNewDealFromProduct({required String productId, required String factoryName}) {
    final newDealId = 'DEAL-${deals.length + 101}';
    final newRfqId = 'RFQ-${deals.length + 1025}';
    final newOrderId = 'ORD-${deals.length + 2304}';
    final prod = getProductById(productId) ?? products.first;

    final newDeal = DealMock(
      dealId: newDealId,
      orderId: newOrderId,
      rfqId: newRfqId,
      productId: prod.id,
      supplierId: supplier.id,
      productName: prod.title,
      dealValue: prod.unitPrice * prod.minOrderQuantity,
      totalQuantity: prod.minOrderQuantity,
      factoryName: factoryName,
      factoryAvatarUrl: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?auto=format&fit=crop&w=200&q=80',
      isFactoryOnline: true,
      isFactoryVerified: true,
      currentStatus: DealStatus.negotiating,
      lastUpdated: DateTime.now(),
    );

    deals.add(newDeal);

    // Create Chat automatically
    chats.add(
      ChatMock(
        id: 'CHAT-${chats.length + 101}',
        dealId: newDealId,
        rfqId: newRfqId,
        companyName: factoryName,
        companyLogoText: factoryName.isNotEmpty ? factoryName[0] : 'ن',
        companyLogoBgColorValue: 0xFF006B5F,
        lastMessage: 'تم إنشاء الصفقة تلقائياً بناءً على طلب عرض السعر $newRfqId',
        lastTime: 'الآن',
        unreadCount: 1,
        currentStatus: 'قيد التفاوض',
      ),
    );

    // Initial System Message
    addMessage(
      dealId: newDealId,
      text: 'تم إنشاء الصفقة تلقائياً بناءً على طلب عرض السعر $newRfqId',
      senderId: 'system',
      senderName: 'النظام',
      isMe: false,
      isSystemNotification: true,
    );

    // Initial Timeline
    timelines[newDealId] = TimelineMock(
      dealId: newDealId,
      currentStepIndex: 0,
      steps: [
        DealTimelineStep(stepIndex: 0, title: 'تم إنشاء الصفقة', subtitle: 'استلام $newRfqId من المصنع', isCompleted: true, isCurrent: true),
        const DealTimelineStep(stepIndex: 1, title: 'تقديم عرض السعر V1', isCompleted: false, isCurrent: false),
        const DealTimelineStep(stepIndex: 2, title: 'اعتماد الاتفاق والعقد', isCompleted: false, isCurrent: false),
      ],
    );

    // Notification
    notifications.add(
      NotificationMock(
        id: 'NOTIF-${notifications.length + 1}',
        dealId: newDealId,
        title: 'صفقة جديدة: $newDealId',
        body: 'استلمت طلب عرض سعر جديد من $factoryName لمنتج ${prod.title}',
        timestamp: DateTime.now(),
      ),
    );

    return newDealId;
  }

  /// 2. Add Message
  static void addMessage({
    required String dealId,
    required String text,
    required String senderId,
    required String senderName,
    required bool isMe,
    bool isSystemNotification = false,
  }) {
    final newMsg = MessageMock(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      dealId: dealId,
      senderId: senderId,
      senderName: senderName,
      text: text,
      timestamp: DateTime.now(),
      isMe: isMe,
      isSystemNotification: isSystemNotification,
    );
    messages.add(newMsg);

    // Update Chat last message
    final chatIdx = chats.indexWhere((c) => c.dealId == dealId);
    if (chatIdx != -1) {
      final oldChat = chats[chatIdx];
      chats[chatIdx] = ChatMock(
        id: oldChat.id,
        dealId: oldChat.dealId,
        rfqId: oldChat.rfqId,
        companyName: oldChat.companyName,
        companyLogoText: oldChat.companyLogoText,
        companyLogoBgColorValue: oldChat.companyLogoBgColorValue,
        lastMessage: text,
        lastTime: 'الآن',
        unreadCount: isMe ? oldChat.unreadCount : oldChat.unreadCount + 1,
        currentStatus: oldChat.currentStatus,
      );
    }
  }

  /// 3. Submit New Versioned Offer
  static void submitNewOfferVersion({
    required String dealId,
    required double unitPrice,
    required int quantity,
    required String productionLeadTime,
    required String validityPeriod,
    required String paymentTerms,
    required String deliveryTerms,
    DateTime? expectedDeliveryDate,
    String? notes,
  }) {
    final existingQuos = quotations.where((q) => q.dealId == dealId).toList();
    final nextVersion = existingQuos.length + 1;

    final newQuo = QuotationMock(
      quotationId: 'QUO-8840-V$nextVersion',
      dealId: dealId,
      versionNumber: nextVersion,
      unitPrice: unitPrice,
      totalPrice: unitPrice * quantity,
      quantity: quantity,
      moq: 500,
      productionLeadTime: productionLeadTime,
      validityPeriod: validityPeriod,
      paymentTerms: paymentTerms,
      deliveryTerms: deliveryTerms,
      expectedDeliveryDate: expectedDeliveryDate,
      notes: notes ?? '',
      offerStatus: OfferStatus.sent,
      createdAt: DateTime.now(),
      createdByRole: 'المورد',
    );

    quotations.add(newQuo);

    // Update Deal central summary
    final dealIndex = deals.indexWhere((d) => d.dealId == dealId);
    if (dealIndex != -1) {
      final oldDeal = deals[dealIndex];
      deals[dealIndex] = DealMock(
        dealId: oldDeal.dealId,
        orderId: oldDeal.orderId,
        rfqId: oldDeal.rfqId,
        productId: oldDeal.productId,
        supplierId: oldDeal.supplierId,
        productName: oldDeal.productName,
        dealValue: unitPrice * quantity,
        totalQuantity: quantity,
        factoryName: oldDeal.factoryName,
        factoryAvatarUrl: oldDeal.factoryAvatarUrl,
        isFactoryOnline: oldDeal.isFactoryOnline,
        isFactoryVerified: oldDeal.isFactoryVerified,
        currentStatus: DealStatus.awaitingResponse,
        lastUpdated: DateTime.now(),
      );
    }

    addMessage(
      dealId: dealId,
      text: 'تم إرسال عرض سعر جديد (الإصدار رقم $nextVersion - Version $nextVersion) بقيمة ${(unitPrice * quantity).toStringAsFixed(0)} ج.م',
      senderId: 'system',
      senderName: 'النظام',
      isMe: false,
      isSystemNotification: true,
    );

    notifications.add(
      NotificationMock(
        id: 'NOTIF-${notifications.length + 1}',
        dealId: dealId,
        title: 'تم إرسال عرض V$nextVersion للصفقة $dealId',
        body: 'تم إرسال عرض سعر جديد بقيمة ${(unitPrice * quantity).toStringAsFixed(0)} ج.م وفي انتظار رد المصنع.',
        timestamp: DateTime.now(),
      ),
    );
  }

  /// 4. Accept Quotation
  static void acceptQuotation(String dealId) {
    final dealIndex = deals.indexWhere((d) => d.dealId == dealId);
    if (dealIndex != -1) {
      final oldDeal = deals[dealIndex];
      deals[dealIndex] = DealMock(
        dealId: oldDeal.dealId,
        orderId: oldDeal.orderId,
        rfqId: oldDeal.rfqId,
        productId: oldDeal.productId,
        supplierId: oldDeal.supplierId,
        productName: oldDeal.productName,
        dealValue: oldDeal.dealValue,
        totalQuantity: oldDeal.totalQuantity,
        factoryName: oldDeal.factoryName,
        factoryAvatarUrl: oldDeal.factoryAvatarUrl,
        isFactoryOnline: oldDeal.isFactoryOnline,
        isFactoryVerified: oldDeal.isFactoryVerified,
        currentStatus: DealStatus.agreed,
        lastUpdated: DateTime.now(),
      );
    }

    // Generate Agreement automatically
    agreements.add(
      AgreementMock(
        agreementId: 'AGR-${agreements.length + 9921}',
        dealId: dealId,
        finalTotalPrice: getDealById(dealId)?.dealValue ?? 430000.0,
        finalQuantity: getDealById(dealId)?.totalQuantity ?? 10000,
        deliveryDate: '٢٨ يوليو ٢٠٢٦',
        pickupLocation: 'مخزن المحلة الكبرى - المنطقة الصناعية الأولى',
        paymentMethod: 'نظام الدفع الضامن المنفذ عبر المنصة (Escrow)',
        status: 'معتمد رسمياً وموقع من الطرفين 🟢',
        isApprovedBySupplier: true,
        isApprovedByFactory: true,
        approvedAt: DateTime.now(),
      ),
    );

    addMessage(
      dealId: dealId,
      text: 'تم قبول عرض السعر رسمياً وإنشاء العقد الإلكتروني الموثق 🟢',
      senderId: 'system',
      senderName: 'النظام',
      isMe: false,
      isSystemNotification: true,
    );

    notifications.add(
      NotificationMock(
        id: 'NOTIF-${notifications.length + 1}',
        dealId: dealId,
        title: 'تم قبول العرض وإنشاء الاتفاق!',
        body: 'تم التوقيع الإلكتروني واعتمدت وثيقة العقد للصفقة $dealId.',
        timestamp: DateTime.now(),
      ),
    );
  }

  /// 5. Start Production
  static void startProduction(String dealId) {
    final dealIndex = deals.indexWhere((d) => d.dealId == dealId);
    if (dealIndex != -1) {
      final old = deals[dealIndex];
      deals[dealIndex] = DealMock(
        dealId: old.dealId,
        orderId: old.orderId,
        rfqId: old.rfqId,
        productId: old.productId,
        supplierId: old.supplierId,
        productName: old.productName,
        dealValue: old.dealValue,
        totalQuantity: old.totalQuantity,
        factoryName: old.factoryName,
        factoryAvatarUrl: old.factoryAvatarUrl,
        currentStatus: DealStatus.inProduction,
        lastUpdated: DateTime.now(),
      );
    }

    addMessage(
      dealId: dealId,
      text: 'بدأ الإنتاج والتصنيع الفعلي في خطوط مصانع المحلة الكبرى 🏭',
      senderId: 'system',
      senderName: 'النظام',
      isMe: false,
      isSystemNotification: true,
    );

    notifications.add(
      NotificationMock(
        id: 'NOTIF-${notifications.length + 1}',
        dealId: dealId,
        title: 'بدأ الإنتاج والتصنيع 🏭',
        body: 'تم تفعيل خطوط الإنتاج للصفقة $dealId وجاري رفع نسب الإنجاز والميديا.',
        timestamp: DateTime.now(),
      ),
    );
  }
}
