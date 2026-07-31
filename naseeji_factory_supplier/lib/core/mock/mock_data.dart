import 'subscription_mock.dart';
import 'supplier_mock.dart';
import 'product_mock.dart';
import 'deal_mock.dart';
import 'quotation_mock.dart';
import 'chat_mock.dart';
import 'message_mock.dart';
import 'agreement_mock.dart';
import 'timeline_mock.dart';
import 'notification_mock.dart';
import 'package:naseeji_factory/supplier/features/messages/domain/entities/deal_workspace_model.dart';
import 'package:naseeji_factory/supplier/features/messages/domain/entities/deal_quotation_model.dart';
import 'package:naseeji_factory/supplier/features/messages/domain/entities/deal_status_enum.dart';
import 'package:naseeji_factory/supplier/features/messages/domain/entities/conversation.dart';
import 'package:naseeji_factory/supplier/features/messages/domain/entities/deal_timeline_model.dart';
import 'package:naseeji_factory/supplier/features/notifications/domain/entities/notification_settings_model.dart';
import 'package:naseeji_factory/supplier/features/profile/domain/entities/security_models.dart';

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
  static NotificationSettingsModel notificationSettings = NotificationSettingsModel.defaultSettings;

  static NotificationSettingsModel getNotificationSettings() {
    return notificationSettings;
  }

  static void updateNotificationSettings(NotificationSettingsModel newSettings) {
    notificationSettings = newSettings;
  }

  // 11. Security Data
  static SecuritySettingsModel securitySettings = SecuritySettingsModel.defaultSettings;
  static List<DeviceSessionModel> deviceSessions = List.from(DeviceSessionModel.sampleSessions);
  static List<SecurityActivityModel> securityActivities = List.from(SecurityActivityModel.sampleActivities);

  // 10. Subscription Data
  static SubscriptionModel currentSubscription = SubscriptionModel.defaultSubscription;
  static List<SubscriptionModel> get subscriptions => [currentSubscription];
  static List<SubscriptionPlanMock> subscriptionPlans = List.from(SubscriptionPlanMock.samplePlans);
  static List<SubscriptionInvoiceMock> subscriptionInvoices = List.from(SubscriptionInvoiceMock.sampleInvoices);
  static List<SubscriptionHistoryMock> subscriptionHistory = List.from(SubscriptionHistoryMock.sampleHistory);
  static List<Map<String, dynamic>> operationsLog = [];

  // ─── Subscription Helpers ──────────────────────────────────────────

  static SubscriptionModel getCurrentSubscription() {
    return currentSubscription.copyWith(productsUsed: products.length);
  }

  static void addOperationLog(String action, String details) {
    operationsLog.add({
      'id': 'OP-${DateTime.now().millisecondsSinceEpoch}',
      'action': action,
      'details': details,
      'timestamp': DateTime.now(),
    });
  }

  static String? validateAddProductLimits() {
    final sub = getCurrentSubscription();
    if (sub.isExpired || sub.status == SubscriptionStatus.suspended) {
      return 'الاشتراك الحالي منتهي أو معلق. يرجى تجديد الاشتراك لإضافة منتجات جديدة.';
    }
    if (sub.productsUsed >= sub.productsLimit) {
      return 'لقد وصلت للحد الأقصى للمنتجات المتاحة في باقتك الحالية (${sub.productsLimit} منتج). يرجى الترقية لإضافة المزيد.';
    }
    return null;
  }

  static String? validateMediaLimits({required String type, required int currentCount}) {
    final sub = getCurrentSubscription();
    if (sub.isExpired) {
      return 'الاشتراك منتهي. لا يمكن رفع وسائط جديدة.';
    }
    if (type == 'image' && currentCount >= sub.imagesPerProduct) {
      return 'تجاوزت حد الصور المسموح به للمنتج الواحد (${sub.imagesPerProduct} صور).';
    }
    if (type == 'video' && currentCount >= sub.videosPerProduct) {
      return 'تجاوزت حد الفيديوهات المسموح به للمنتج الواحد (${sub.videosPerProduct} فيديو).';
    }
    if (type == 'pdf' && currentCount >= sub.pdfPerProduct) {
      return 'تجاوزت حد ملفات PDF المسموح بها للمنتج الواحد (${sub.pdfPerProduct} ملفات).';
    }
    return null;
  }

  static void upgradeSubscriptionPlan(SubscriptionPlanMock newPlan) {
    final oldName = currentSubscription.planName;
    currentSubscription = currentSubscription.copyWith(
      planName: newPlan.name,
      planType: newPlan.type,
      status: SubscriptionStatus.active,
      productsLimit: newPlan.productsLimit,
      imagesPerProduct: newPlan.imagesPerProduct,
      videosPerProduct: newPlan.videosPerProduct,
      pdfPerProduct: newPlan.pdfPerProduct,
      analyticsEnabled: newPlan.analyticsEnabled,
      prioritySupport: newPlan.prioritySupport,
      employeeLimit: newPlan.employeeLimit,
      canPublishProducts: true,
      canEditProducts: true,
      canRepublishProducts: true,
      endDate: DateTime.now().add(const Duration(days: 30)),
      renewalDate: DateTime.now().add(const Duration(days: 30)),
      updatedAt: DateTime.now(),
    );

    subscriptionInvoices.add(
      SubscriptionInvoiceMock(
        invoiceId: 'INV-SUB-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        subscriptionId: currentSubscription.subscriptionId,
        planName: newPlan.name,
        amount: newPlan.pricePerMonth,
        invoiceDate: DateTime.now(),
        paymentMethod: 'بطاقة ائتمانية (فوري / ميزة)',
        status: 'مدفوع 🟢',
      ),
    );

    subscriptionHistory.add(
      SubscriptionHistoryMock(
        historyId: 'HIST-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        action: 'ترقية الباقة',
        oldPlanName: oldName,
        newPlanName: newPlan.name,
        timestamp: DateTime.now(),
        notes: 'تمت ترقية الاشتراك إلى ${newPlan.name} بنجاح.',
      ),
    );

    notifications.add(
      NotificationMock(
        id: 'NOTIF-SUB-${DateTime.now().millisecondsSinceEpoch}',
        dealId: 'SUB-101',
        title: 'تمت ترقية الباقة بنجاح 🚀',
        body: 'تمت الترقية إلى ${newPlan.name} والحد الجديد للمنتجات هو ${newPlan.productsLimit} منتج.',
        timestamp: DateTime.now(),
      ),
    );

    addOperationLog('Upgrade Subscription', 'تمت الترقية إلى ${newPlan.name}');
  }

  static void renewSubscription() {
    currentSubscription = currentSubscription.copyWith(
      status: SubscriptionStatus.active,
      endDate: DateTime.now().add(const Duration(days: 30)),
      renewalDate: DateTime.now().add(const Duration(days: 30)),
      updatedAt: DateTime.now(),
    );

    subscriptionInvoices.add(
      SubscriptionInvoiceMock(
        invoiceId: 'INV-SUB-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        subscriptionId: currentSubscription.subscriptionId,
        planName: currentSubscription.planName,
        amount: 1299.0,
        invoiceDate: DateTime.now(),
        paymentMethod: 'بطاقة ائتمانية (فوري / ميزة)',
        status: 'تجديد مدفوع 🟢',
      ),
    );

    subscriptionHistory.add(
      SubscriptionHistoryMock(
        historyId: 'HIST-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        action: 'تجديد الاشتراك',
        oldPlanName: currentSubscription.planName,
        newPlanName: currentSubscription.planName,
        timestamp: DateTime.now(),
        notes: 'تم تجديد الاشتراك لمدة 30 يوماً إضافية.',
      ),
    );

    notifications.add(
      NotificationMock(
        id: 'NOTIF-SUB-${DateTime.now().millisecondsSinceEpoch}',
        dealId: 'SUB-101',
        title: 'تم تجديد الاشتراك 🔄',
        body: 'تم تجديد باقتك ${currentSubscription.planName} بنجاح لمدة شهر قادم.',
        timestamp: DateTime.now(),
      ),
    );

    addOperationLog('Renew Subscription', 'تم تجديد اشتراك ${currentSubscription.planName}');
  }

  // ─── Query Helper Methods ──────────────────────────────────────────────

  static ProductMock? getProductById(String productId) {
    try {
      return products.firstWhere((p) => p.id == productId);
    } catch (_) {
      return products.first;
    }
  }

  /// Add new product to supplier inventory
  static ProductMock addNewProduct({
    required String title,
    required String category,
    required double unitPrice,
    required int minOrderQuantity,
    required int availableStock,
    required String description,
    String? imageUrl,
  }) {
    final newId = 'P00${products.length + 1}';
    final p = ProductMock(
      id: newId,
      supplierId: supplier.id,
      title: title,
      category: category,
      unitPrice: unitPrice,
      minOrderQuantity: minOrderQuantity,
      availableStock: availableStock,
      imageUrl: imageUrl ?? 'https://images.unsplash.com/photo-1604754742629-3e5728249d81?auto=format&fit=crop&w=400&q=80',
      description: description,
    );
    products.add(p);
    return p;
  }

  /// Update available stock for a product
  static void updateProductStock(String productId, int newStock) {
    final idx = products.indexWhere((p) => p.id == productId);
    if (idx != -1) {
      final old = products[idx];
      products[idx] = ProductMock(
        id: old.id,
        supplierId: old.supplierId,
        title: old.title,
        category: old.category,
        unitPrice: old.unitPrice,
        currency: old.currency,
        minOrderQuantity: old.minOrderQuantity,
        availableStock: newStock,
        imageUrl: old.imageUrl,
        description: old.description,
        isAvailable: newStock > 0,
      );
    }
  }

  /// Deduct stock upon successful deal delivery
  static void deductStockOnDelivery(String productId, int quantityDeducted) {
    final prod = getProductById(productId);
    if (prod != null) {
      final updated = (prod.availableStock - quantityDeducted).clamp(0, 999999);
      updateProductStock(productId, updated);
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
      text: 'قام المورد بإرسال عرض سعر جديد (V$nextVersion) بقيمة ${(unitPrice * quantity).toStringAsFixed(0)} ج.م',
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

    // Add Timeline Event
    final timeline = timelines[dealId];
    if (timeline != null) {
      final steps = List<DealTimelineStep>.from(timeline.steps);
      steps.add(
        DealTimelineStep(
          stepIndex: steps.length,
          title: 'قام المورد بإرسال عرض سعر جديد (V$nextVersion)',
          subtitle: 'عرض سعر بـ ${(unitPrice * quantity).toStringAsFixed(0)} ج.م في انتظار المصنع',
          isCompleted: true,
          isCurrent: true,
        ),
      );
      timelines[dealId] = TimelineMock(
        dealId: dealId,
        currentStepIndex: steps.length - 1,
        steps: steps,
      );
    }
  }

  /// 3b. Factory Counter Offer Trigger (Factory Initiated Negotiation)
  static void submitFactoryCounterOffer({
    required String dealId,
    required double unitPrice,
    required int quantity,
    required String productionLeadTime,
    required String paymentTerms,
    required String deliveryTerms,
    String? notes,
  }) {
    final existingQuos = quotations.where((q) => q.dealId == dealId).toList();
    final nextVersion = existingQuos.length + 1;

    final counterQuo = QuotationMock(
      quotationId: 'QUO-8840-V$nextVersion',
      dealId: dealId,
      versionNumber: nextVersion,
      unitPrice: unitPrice,
      totalPrice: unitPrice * quantity,
      quantity: quantity,
      moq: 500,
      productionLeadTime: productionLeadTime,
      validityPeriod: '١٠ أيام من طلب التعديل',
      paymentTerms: paymentTerms,
      deliveryTerms: deliveryTerms,
      expectedDeliveryDate: DateTime.now().add(const Duration(days: 7)),
      notes: notes ?? 'قام المصنع بطلب تعديل العرض على السعر والكمية والشروط.',
      offerStatus: OfferStatus.counterOffer,
      createdAt: DateTime.now(),
      createdByRole: 'المصنع',
    );

    quotations.add(counterQuo);

    // Update Deal Status to negotiating
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
        currentStatus: DealStatus.negotiating,
        lastUpdated: DateTime.now(),
      );
    }

    addMessage(
      dealId: dealId,
      text: 'قام المصنع بطلب تعديل العرض.',
      senderId: 'system',
      senderName: 'النظام',
      isMe: false,
      isSystemNotification: true,
    );

    notifications.add(
      NotificationMock(
        id: 'NOTIF-${notifications.length + 1}',
        dealId: dealId,
        title: 'طلب تعديل جديد من المصنع 💬',
        body: 'قام المصنع بطلب تعديل العرض للصفقة $dealId.',
        timestamp: DateTime.now(),
      ),
    );

    final timeline = timelines[dealId];
    if (timeline != null) {
      final steps = List<DealTimelineStep>.from(timeline.steps);
      steps.add(
        const DealTimelineStep(
          stepIndex: 3,
          title: 'قام المصنع بطلب تعديل العرض',
          subtitle: 'طلب المصنع تعديل السعر والكمية وتفاصيل الشروط',
          isCompleted: true,
          isCurrent: true,
        ),
      );
      timelines[dealId] = TimelineMock(
        dealId: dealId,
        currentStepIndex: steps.length - 1,
        steps: steps,
      );
    }
  }

  /// 3c. Supplier Accepts Counter Offer
  static void supplierAcceptCounterOffer(String dealId) {
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
      text: 'وافق المورد على عرض التعديل المقدم من المصنع وتم اعتماد الاتفاق 🟢',
      senderId: 'system',
      senderName: 'النظام',
      isMe: false,
      isSystemNotification: true,
    );

    notifications.add(
      NotificationMock(
        id: 'NOTIF-${notifications.length + 1}',
        dealId: dealId,
        title: 'تم قبول عرض التعديل وسريان الاتفاق!',
        body: 'وافق المورد على عرض التعديل المقدم من المصنع وتم إنشاء العقد الإلكتروني.',
        timestamp: DateTime.now(),
      ),
    );

    final timeline = timelines[dealId];
    if (timeline != null) {
      final steps = List<DealTimelineStep>.from(timeline.steps);
      steps.add(
        const DealTimelineStep(
          stepIndex: 4,
          title: 'وافق المورد على عرض التعديل المقدم من المصنع',
          subtitle: 'تم اعتماد العقد الإلكتروني والانتقال للإنتاج',
          isCompleted: true,
          isCurrent: true,
        ),
      );
      timelines[dealId] = TimelineMock(
        dealId: dealId,
        currentStepIndex: steps.length - 1,
        steps: steps,
      );
    }
  }

  /// 3d. Supplier Rejects Counter Offer
  static void supplierRejectCounterOffer(String dealId) {
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
        currentStatus: DealStatus.cancelled,
        lastUpdated: DateTime.now(),
      );
    }

    addMessage(
      dealId: dealId,
      text: 'رفض المورد طلب التعديل المقدم من المصنع 🔴',
      senderId: 'system',
      senderName: 'النظام',
      isMe: false,
      isSystemNotification: true,
    );

    notifications.add(
      NotificationMock(
        id: 'NOTIF-${notifications.length + 1}',
        dealId: dealId,
        title: 'تم رفض طلب التعديل وإغلاق المفاوضات',
        body: 'رفض المورد طلب التعديل المقدم من المصنع للصفقة $dealId.',
        timestamp: DateTime.now(),
      ),
    );

    final timeline = timelines[dealId];
    if (timeline != null) {
      final steps = List<DealTimelineStep>.from(timeline.steps);
      steps.add(
        const DealTimelineStep(
          stepIndex: 4,
          title: 'رفض المورد طلب التعديل المقدم من المصنع',
          subtitle: 'تم إغلاق المفاوضات على هذه الصفقة',
          isCompleted: true,
          isCurrent: true,
        ),
      );
      timelines[dealId] = TimelineMock(
        dealId: dealId,
        currentStepIndex: steps.length - 1,
        steps: steps,
      );
    }
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



