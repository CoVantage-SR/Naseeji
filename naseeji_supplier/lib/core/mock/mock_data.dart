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

  /// Get Product by ID
  static ProductMock? getProductById(String productId) {
    try {
      return products.firstWhere((p) => p.id == productId);
    } catch (_) {
      return null;
    }
  }

  /// Get Deal by ID
  static DealMock? getDealById(String dealId) {
    try {
      return deals.firstWhere((d) => d.dealId == dealId || d.rfqId == dealId || d.orderId == dealId);
    } catch (_) {
      return deals.first;
    }
  }

  /// Get all Conversations / Chats as Domain objects
  static List<Conversation> getConversationsDomain() {
    return chats.map((c) => c.toDomain()).toList();
  }

  /// Get unified DealWorkspaceModel for a deal ID
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

  /// Add a new message
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
  }

  /// Create and submit a new Versioned Offer
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

    // Post automatic System Message
    addMessage(
      dealId: dealId,
      text: 'تم إرسال عرض سعر جديد (الإصدار رقم $nextVersion - Version $nextVersion) بقيمة ${(unitPrice * quantity).toStringAsFixed(0)} ج.م',
      senderId: 'system',
      senderName: 'النظام',
      isMe: false,
      isSystemNotification: true,
    );
  }

  /// Accept latest quotation
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

    addMessage(
      dealId: dealId,
      text: 'تم قبول عرض السعر رسمياً وإنشاء العقد الإلكتروني 🟢',
      senderId: 'system',
      senderName: 'النظام',
      isMe: false,
      isSystemNotification: true,
    );
  }
}
