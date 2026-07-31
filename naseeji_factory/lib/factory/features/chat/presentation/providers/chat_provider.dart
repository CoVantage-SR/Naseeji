import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_provider.g.dart';

class Conversation {
  final String id;
  final String supplierId;
  final String supplierName;
  final String lastMessage;
  final double lastNegotiatedPrice;
  final String negotiationStatus; // open, negotiating, agreed, rejected
  final int unreadCount;
  final String lastMessageTime;
  final bool isPinned;
  final bool isMuted;
  final bool isArchived;
  final bool isBlocked;
  final bool isVerified;
  final String rfqId;
  final String? orderId;

  const Conversation({
    required this.id,
    required this.supplierId,
    required this.supplierName,
    required this.lastMessage,
    required this.lastNegotiatedPrice,
    required this.negotiationStatus,
    required this.unreadCount,
    required this.lastMessageTime,
    required this.isPinned,
    required this.isMuted,
    required this.isArchived,
    required this.isBlocked,
    required this.isVerified,
    required this.rfqId,
    this.orderId,
  });

  Conversation copyWith({
    String? lastMessage,
    double? lastNegotiatedPrice,
    String? negotiationStatus,
    int? unreadCount,
    String? lastMessageTime,
    bool? isPinned,
    bool? isMuted,
    bool? isArchived,
    bool? isBlocked,
    String? orderId,
  }) {
    return Conversation(
      id: id,
      supplierId: supplierId,
      supplierName: supplierName,
      lastMessage: lastMessage ?? this.lastMessage,
      lastNegotiatedPrice: lastNegotiatedPrice ?? this.lastNegotiatedPrice,
      negotiationStatus: negotiationStatus ?? this.negotiationStatus,
      unreadCount: unreadCount ?? this.unreadCount,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      isPinned: isPinned ?? this.isPinned,
      isMuted: isMuted ?? this.isMuted,
      isArchived: isArchived ?? this.isArchived,
      isBlocked: isBlocked ?? this.isBlocked,
      isVerified: isVerified,
      rfqId: rfqId,
      orderId: orderId ?? this.orderId,
    );
  }
}

class Message {
  final String id;
  final String conversationId;
  final String senderType; // factory, supplier, system
  final String type; // text, image, pdf, video, quotation, status_update
  final String content;
  final String time;
  final double? quotationPrice;
  final int? quotationMoq;
  final int? quotationPrepDays;
  final int? quotationShippingDays;
  final String? quotationPayment;
  final String? quotationWarranty;
  final String? quotationExpiry;
  final String? quotationNotes;
  final int? quotationVersion;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderType,
    required this.type,
    required this.content,
    required this.time,
    this.quotationPrice,
    this.quotationMoq,
    this.quotationPrepDays,
    this.quotationShippingDays,
    this.quotationPayment,
    this.quotationWarranty,
    this.quotationExpiry,
    this.quotationNotes,
    this.quotationVersion,
  });
}

@riverpod
class ChatNotifier extends _$ChatNotifier {
  @override
  List<Conversation> build() {
    return _mockConversations;
  }

  void togglePin(String conversationId) {
    state = [
      for (final conv in state)
        if (conv.id == conversationId) conv.copyWith(isPinned: !conv.isPinned) else conv
    ];
  }

  void toggleMute(String conversationId) {
    state = [
      for (final conv in state)
        if (conv.id == conversationId) conv.copyWith(isMuted: !conv.isMuted) else conv
    ];
  }

  void toggleArchive(String conversationId) {
    state = [
      for (final conv in state)
        if (conv.id == conversationId) conv.copyWith(isArchived: !conv.isArchived) else conv
    ];
  }

  void deleteConversation(String conversationId) {
    state = state.where((conv) => conv.id != conversationId).toList();
  }

  void blockSupplier(String conversationId) {
    state = [
      for (final conv in state)
        if (conv.id == conversationId) conv.copyWith(isBlocked: !conv.isBlocked) else conv
    ];
  }

  void updateNegotiationStatus(String conversationId, String status) {
    state = [
      for (final conv in state)
        if (conv.id == conversationId) conv.copyWith(negotiationStatus: status) else conv
    ];
  }

  void updateLastMessage(String conversationId, String lastMsg, double? lastPrice) {
    state = [
      for (final conv in state)
        if (conv.id == conversationId)
          conv.copyWith(
            lastMessage: lastMsg,
            lastMessageTime: '١٠:٣٥ ص',
            lastNegotiatedPrice: lastPrice,
            unreadCount: 0,
          )
        else
          conv
    ];
  }

  Conversation? getConversationById(String id) {
    try {
      return state.firstWhere((conv) => conv.id == id);
    } catch (_) {
      return null;
    }
  }
}

@riverpod
class MessagesNotifier extends _$MessagesNotifier {
  @override
  Map<String, List<Message>> build() {
    return _mockMessages;
  }

  void sendMessage(
    String conversationId,
    String content, {
    String type = 'text',
    double? quotationPrice,
    int? quotationMoq,
    int? quotationPrepDays,
    int? quotationShippingDays,
    String? quotationPayment,
    String? quotationWarranty,
    String? quotationExpiry,
    String? quotationNotes,
    int? quotationVersion,
  }) {
    final list = state[conversationId] ?? [];
    final newMsg = Message(
      id: 'msg_${list.length + 101}',
      conversationId: conversationId,
      senderType: 'factory',
      type: type,
      content: content,
      time: '١٠:٣٥ ص',
      quotationPrice: quotationPrice,
      quotationMoq: quotationMoq,
      quotationPrepDays: quotationPrepDays,
      quotationShippingDays: quotationShippingDays,
      quotationPayment: quotationPayment,
      quotationWarranty: quotationWarranty,
      quotationExpiry: quotationExpiry,
      quotationNotes: quotationNotes,
      quotationVersion: quotationVersion,
    );

    final updatedMap = Map<String, List<Message>>.from(state);
    updatedMap[conversationId] = [...list, newMsg];
    state = updatedMap;

    // Also update the last message in conversation
    ref.read(chatNotifierProvider.notifier).updateLastMessage(
          conversationId,
          type == 'quotation' ? 'تم تقديم عرض سعر جديد بقيمة $quotationPrice ج.م' : content,
          quotationPrice,
        );
  }

  void receiveSupplierQuotation(
    String conversationId, {
    required double price,
    required int moq,
    required int prepDays,
    required int shippingDays,
    required String payment,
    required String warranty,
    required String expiry,
    required String notes,
    required int version,
  }) {
    final list = state[conversationId] ?? [];
    final newMsg = Message(
      id: 'msg_${list.length + 101}',
      conversationId: conversationId,
      senderType: 'supplier',
      type: 'quotation',
      content: 'تم إرسال مراجعة جديدة لعرض السعر رقم #$version بقيمة $price ج.م.',
      time: '١٠:٣٦ ص',
      quotationPrice: price,
      quotationMoq: moq,
      quotationPrepDays: prepDays,
      quotationShippingDays: shippingDays,
      quotationPayment: payment,
      quotationWarranty: warranty,
      quotationExpiry: expiry,
      quotationNotes: notes,
      quotationVersion: version,
    );

    final updatedMap = Map<String, List<Message>>.from(state);
    updatedMap[conversationId] = [...list, newMsg];
    state = updatedMap;

    ref.read(chatNotifierProvider.notifier).updateLastMessage(
          conversationId,
          'تم إرسال مراجعة جديدة لعرض السعر رقم #$version بقيمة $price ج.م.',
          price,
        );
  }

  void acceptQuotation(String conversationId, String quoteVersionText) {
    final list = state[conversationId] ?? [];
    final sysMsg = Message(
      id: 'msg_${list.length + 101}',
      conversationId: conversationId,
      senderType: 'system',
      type: 'status_update',
      content: 'تم قبول عرض السعر بنجاح! وتم تحويل طلب الـ RFQ تلقائياً إلى أمر شراء رسمي.',
      time: '١٠:٤٠ ص',
    );

    final updatedMap = Map<String, List<Message>>.from(state);
    updatedMap[conversationId] = [...list, sysMsg];
    state = updatedMap;

    ref.read(chatNotifierProvider.notifier).updateNegotiationStatus(conversationId, 'agreed');
    ref.read(chatNotifierProvider.notifier).updateLastMessage(
          conversationId,
          'تم قبول واعتماد عرض السعر النهائي.',
          null,
        );
  }

  void rejectQuotation(String conversationId) {
    final list = state[conversationId] ?? [];
    final sysMsg = Message(
      id: 'msg_${list.length + 101}',
      conversationId: conversationId,
      senderType: 'system',
      type: 'status_update',
      content: 'تم رفض عرض السعر الحالي وإغلاق جولة التفاوض.',
      time: '١٠:٤٢ ص',
    );

    final updatedMap = Map<String, List<Message>>.from(state);
    updatedMap[conversationId] = [...list, sysMsg];
    state = updatedMap;

    ref.read(chatNotifierProvider.notifier).updateNegotiationStatus(conversationId, 'rejected');
    ref.read(chatNotifierProvider.notifier).updateLastMessage(
          conversationId,
          'تم رفض عرض السعر الحالي.',
          null,
        );
  }

  List<Message> getMessagesForConversation(String conversationId) {
    return state[conversationId] ?? [];
  }
}

final List<Conversation> _mockConversations = [
  const Conversation(
    id: 'chat_1',
    supplierId: 'sup_1',
    supplierName: 'شركة غزل المحلة الكبرى',
    lastMessage: 'سنقوم بتسليم الشحنة الأولى خلال ٧ أيام من توقيع الاتفاقية.',
    lastNegotiatedPrice: 142.0,
    negotiationStatus: 'negotiating',
    unreadCount: 2,
    lastMessageTime: '١٠:٣٠ ص',
    isPinned: true,
    isMuted: false,
    isArchived: false,
    isBlocked: false,
    isVerified: true,
    rfqId: 'RFQ-2026-001',
  ),
  const Conversation(
    id: 'chat_2',
    supplierId: 'sup_2',
    supplierName: 'مصنع النيل للأقمشة الحديثة',
    lastMessage: 'تم مراجعة شروط السعر لتكون ١٤٨ ج.م للوحدة.',
    lastNegotiatedPrice: 148.0,
    negotiationStatus: 'open',
    unreadCount: 0,
    lastMessageTime: 'أمس',
    isPinned: false,
    isMuted: true,
    isArchived: false,
    isBlocked: false,
    isVerified: false,
    rfqId: 'RFQ-2026-001',
  ),
  const Conversation(
    id: 'chat_3',
    supplierId: 'sup_3',
    supplierName: 'الفتح لخيوط البوليستر ومستلزمات المصانع',
    lastMessage: 'تم تحويل الطلب رقم PO-2026-103 لخط الإنتاج الفعلي.',
    lastNegotiatedPrice: 135.0,
    negotiationStatus: 'agreed',
    unreadCount: 0,
    lastMessageTime: '١٢/٠٧/٢٠٢٦',
    isPinned: false,
    isMuted: false,
    isArchived: false,
    isBlocked: false,
    isVerified: true,
    rfqId: 'RFQ-2026-001',
    orderId: 'PO-2026-103',
  ),
];

final Map<String, List<Message>> _mockMessages = {
  'chat_1': [
    const Message(
      id: 'msg_1',
      conversationId: 'chat_1',
      senderType: 'system',
      type: 'status_update',
      content: 'تم إنشاء طلب عرض السعر RFQ-2026-001 بنجاح ودعوة موردين معتمدين.',
      time: '٠٩:٠٠ ص',
    ),
    const Message(
      id: 'msg_2',
      conversationId: 'chat_1',
      senderType: 'factory',
      type: 'text',
      content: 'مرحباً، نحتاج لتوريد كميات خيوط قطنية مصنعة بأعلى درجات النعومة ومغزولة جيداً للتصدير. هل تلتزمون بالمواعيد المطلوبة؟',
      time: '٠٩:١٥ ص',
    ),
    const Message(
      id: 'msg_3',
      conversationId: 'chat_1',
      senderType: 'supplier',
      type: 'text',
      content: 'أهلاً بكم في مصانع غزل المحلة الكبرى. نعم، نحن نلتزم بجداول التسليم التصديرية ولدينا شهادات جودة نخب أول.',
      time: '٠٩:٢٠ ص',
    ),
    const Message(
      id: 'msg_4',
      conversationId: 'chat_1',
      senderType: 'supplier',
      type: 'quotation',
      content: 'عرض السعر الأولي المقترح من غزل المحلة.',
      time: '٠٩:٢٢ ص',
      quotationPrice: 142.0,
      quotationMoq: 500,
      quotationPrepDays: 7,
      quotationShippingDays: 2,
      quotationPayment: 'مقدم 30% والباقي تسليم بموجب فواتير مقبولة الدفع.',
      quotationWarranty: 'ضمان النعومة لمدة سنة كاملة ضد عيوب التحضير.',
      quotationExpiry: '٢٠٢٦/٠٨/١٥',
      quotationNotes: 'يسعدنا التعامل معكم وتقديم هذا العرض الخاص للموسم الشتوي.',
      quotationVersion: 1,
    ),
    const Message(
      id: 'msg_5',
      conversationId: 'chat_1',
      senderType: 'factory',
      type: 'text',
      content: 'السعر مقبول مبدئياً، ولكن هل من الممكن تقليص زمن التحضير ليكون ٥ أيام فقط بدلاً من ٧ أيام للمستعجل؟',
      time: '١٠:١٥ ص',
    ),
    const Message(
      id: 'msg_6',
      conversationId: 'chat_1',
      senderType: 'supplier',
      type: 'text',
      content: 'سنقوم بتسليم الشحنة الأولى خلال ٧ أيام من توقيع الاتفاقية لتفادي أي ضغوط على خط الصباغة والتجهيز.',
      time: '١٠:٣٠ ص',
    ),
  ],
  'chat_2': [
    const Message(
      id: 'msg_201',
      conversationId: 'chat_2',
      senderType: 'supplier',
      type: 'quotation',
      content: 'عرض السعر المقترح من مصنع النيل.',
      time: 'أمس',
      quotationPrice: 148.0,
      quotationMoq: 200,
      quotationPrepDays: 12,
      quotationShippingDays: 3,
      quotationPayment: 'كاش عند الاستلام أو تحويل بنكي.',
      quotationWarranty: 'ضمان كامل ضد الخدش أو تمزق النسيج.',
      quotationExpiry: '٢٠٢٦/٠٨/١٢',
      quotationNotes: 'نحن ملتزمون بالدقة العالية والجودة ونستعمل أجود أصباغ الأقمشة.',
      quotationVersion: 1,
    ),
  ],
  'chat_3': [
    const Message(
      id: 'msg_301',
      conversationId: 'chat_3',
      senderType: 'supplier',
      type: 'quotation',
      content: 'العرض المقدم من الفتح.',
      time: '١٢/٠٧/٢٠٢٦',
      quotationPrice: 135.0,
      quotationMoq: 1000,
      quotationPrepDays: 5,
      quotationShippingDays: 4,
      quotationPayment: 'دفعات ربع سنوية.',
      quotationWarranty: 'لا يوجد.',
      quotationExpiry: '٢٠٢٦/٠٨/٢٥',
      quotationNotes: 'أفضل سعر خيوط بوليستر مستوردة نخب أول.',
      quotationVersion: 1,
    ),
    const Message(
      id: 'msg_302',
      conversationId: 'chat_3',
      senderType: 'system',
      type: 'status_update',
      content: 'تم اعتماد عرض الفتح وتوقيع العقد المالي.',
      time: '١٢/٠٧/٢٠٢٦',
    ),
    const Message(
      id: 'msg_303',
      conversationId: 'chat_3',
      senderType: 'system',
      type: 'status_update',
      content: 'تم تحويل الطلب رقم PO-2026-103 لخط الإنتاج الفعلي.',
      time: 'أمس',
    ),
  ],
};
