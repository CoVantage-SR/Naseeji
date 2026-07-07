import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/business_message.dart';
import '../../domain/entities/support_ticket.dart';
import '../../domain/entities/message_attachment.dart';
import '../../domain/entities/timeline_stage.dart';
import '../../domain/repositories/messages_repository.dart';

part 'messages_repository_impl.g.dart';

@riverpod
MessagesRepository messagesRepository(MessagesRepositoryRef ref) {
  return MessagesRepositoryImpl();
}

class MessagesRepositoryImpl implements MessagesRepository {
  // In-memory mutable state
  final List<Conversation> _conversations = _buildConversations();
  final Map<String, List<BusinessMessage>> _messages = _buildMessages();
  final Map<String, SupportTicket> _tickets = _buildTickets();
  final Map<String, List<TimelineStage>> _timelines = {};

  @override
  Future<List<Conversation>> getConversations() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_conversations);
  }

  @override
  Future<List<BusinessMessage>> getMessages(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_messages[conversationId] ?? []);
  }

  @override
  Future<void> sendMessage(String conversationId, BusinessMessage message) async {
    _messages[conversationId] = [...(_messages[conversationId] ?? []), message];
    final idx = _conversations.indexWhere((c) => c.id == conversationId);
    if (idx != -1) {
      _conversations[idx] = _conversations[idx].copyWith(
        lastMessage: message.content,
        lastTime: 'الآن',
      );
    }
  }

  @override
  Future<void> markAsRead(String conversationId) async {
    final idx = _conversations.indexWhere((c) => c.id == conversationId);
    if (idx != -1) {
      _conversations[idx] = _conversations[idx].copyWith(unreadCount: 0);
    }
  }

  @override
  Future<void> pinConversation(String conversationId, bool pinned) async {
    final idx = _conversations.indexWhere((c) => c.id == conversationId);
    if (idx != -1) {
      _conversations[idx] = _conversations[idx].copyWith(isPinned: pinned);
    }
  }

  @override
  Future<void> muteConversation(String conversationId, bool muted) async {
    final idx = _conversations.indexWhere((c) => c.id == conversationId);
    if (idx != -1) {
      _conversations[idx] = _conversations[idx].copyWith(isMuted: muted);
    }
  }

  @override
  Future<void> archiveConversation(String conversationId) async {
    final idx = _conversations.indexWhere((c) => c.id == conversationId);
    if (idx != -1) {
      _conversations[idx] = _conversations[idx].copyWith(status: ConversationStatus.archived);
    }
  }

  @override
  Future<void> restoreConversation(String conversationId) async {
    final idx = _conversations.indexWhere((c) => c.id == conversationId);
    if (idx != -1) {
      _conversations[idx] = _conversations[idx].copyWith(status: ConversationStatus.active);
    }
  }

  @override
  Future<void> deleteConversation(String conversationId) async {
    _conversations.removeWhere((c) => c.id == conversationId);
  }

  @override
  Future<SupportTicket?> getSupportTicket(String ticketId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _tickets[ticketId];
  }

  @override
  Future<void> closeTicket(String ticketId) async {
    if (_tickets.containsKey(ticketId)) {
      _tickets[ticketId] = _tickets[ticketId]!.copyWith(status: TicketStatus.closed);
    }
  }

  @override
  Future<void> rateTicket(String ticketId, int rating) async {
    if (_tickets.containsKey(ticketId)) {
      _tickets[ticketId] = _tickets[ticketId]!.copyWith(ratingGiven: rating);
    }
  }

  @override
  Future<List<MessageAttachment>> getAttachments(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _buildAttachments(conversationId);
  }

  @override
  Future<List<BusinessMessage>> searchMessages(String conversationId, String query) async {
    final msgs = _messages[conversationId] ?? [];
    final q = query.toLowerCase();
    return msgs.where((m) => m.content.toLowerCase().contains(q)).toList();
  }

  @override
  Future<List<BusinessMessage>> getAllQuotationCards(String conversationId) async {
    final msgs = _messages[conversationId] ?? [];
    return msgs.where((m) =>
      m.type == MessageType.quotationCard ||
      m.type == MessageType.counterOfferCard
    ).toList();
  }

  @override
  Future<void> blockUser(String conversationId, bool blocked) async {
    final idx = _conversations.indexWhere((c) => c.id == conversationId);
    if (idx != -1) {
      _conversations[idx] = _conversations[idx].copyWith(isBlocked: blocked);
    }
  }

  @override
  Future<void> muteConversationForDuration(String conversationId, Duration? duration) async {
    final idx = _conversations.indexWhere((c) => c.id == conversationId);
    if (idx != -1) {
      if (duration == null) {
        _conversations[idx] = _conversations[idx].copyWith(isMuted: false, muteUntil: null);
      } else {
        _conversations[idx] = _conversations[idx].copyWith(
          isMuted: true,
          muteUntil: DateTime.now().add(duration),
        );
      }
    }
  }

  @override
  Future<List<TimelineStage>> getTimelineStages(String conversationId) async {
    return _defaultTimeline(conversationId);
  }

  @override
  Future<void> updateTimelineStage(
    String conversationId,
    String stageLabel, {
    required String timestamp,
    required String user,
    String? notes,
    bool? isActive,
    bool? isCompleted,
  }) async {
    final list = _defaultTimeline(conversationId);
    final idx = list.indexWhere((s) => s.label == stageLabel);
    if (idx != -1) {
      list[idx] = list[idx].copyWith(
        timestamp: timestamp,
        user: user,
        notes: notes,
        isActive: isActive,
        isCompleted: isCompleted,
      );
    }
  }

  List<TimelineStage> _defaultTimeline(String convId) {
    return _timelines.putIfAbsent(convId, () => [
      const TimelineStage(
        label: 'طلب عرض (RFQ)',
        icon: Icons.request_quote_outlined,
        timestamp: '2026-07-01 09:00',
        user: 'مصنع الرياض للملابس',
        notes: 'طلب 5,000 متر قطن 100% — RFQ-8820',
        isCompleted: true,
      ),
      const TimelineStage(
        label: 'تقديم عرض أسعار',
        icon: Icons.price_check_outlined,
        timestamp: '2026-07-01 09:30',
        user: 'مورد نسيجي',
        notes: 'تقديم العرض الأول بسعر 12.50 ر.س/م',
        isCompleted: true,
      ),
      const TimelineStage(
        label: 'عرض مضاد',
        icon: Icons.swap_horiz,
        timestamp: '2026-07-01 10:00',
        user: 'مصنع الرياض للملابس',
        notes: 'طلب تخفيض إلى 11.80 ر.س/م',
        isCompleted: true,
      ),
      const TimelineStage(
        label: 'تعديل العرض',
        icon: Icons.edit_outlined,
        timestamp: '2026-07-01 11:00',
        user: 'مورد نسيجي',
        notes: 'تعديل العرض إلى 12.00 ر.س/م — مقبول',
        isCompleted: true,
      ),
      const TimelineStage(
        label: 'الاتفاق النهائي',
        icon: Icons.handshake_outlined,
        timestamp: '2026-07-01 11:30',
        user: 'كلا الطرفين',
        notes: 'توقيع الاتفاقية — ORD-2241 تم إنشاؤه',
        isCompleted: true,
      ),
      const TimelineStage(
        label: 'التصنيع',
        icon: Icons.factory_outlined,
        timestamp: '2026-07-03 08:00',
        user: 'مورد نسيجي',
        notes: 'بدء الإنتاج — 65% مكتمل',
        isActive: true,
      ),
      const TimelineStage(
        label: 'الشحن',
        icon: Icons.local_shipping_outlined,
        timestamp: '--',
        user: '--',
      ),
      const TimelineStage(
        label: 'الاستلام',
        icon: Icons.inventory_2_outlined,
        timestamp: '--',
        user: '--',
      ),
      const TimelineStage(
        label: 'الدفع',
        icon: Icons.payments_outlined,
        timestamp: '--',
        user: '--',
      ),
      const TimelineStage(
        label: 'مكتمل',
        icon: Icons.check_circle_outline,
        timestamp: '--',
        user: '--',
      ),
    ]);
  }
}

// ─── Seed Data Builders ─────────────────────────────────────────────────────

List<Conversation> _buildConversations() => [
  const Conversation(
    id: 'conv_001',
    companyName: 'مصنع الرياض للملابس',
    companyLogoText: 'RC',
    companyLogoBgColorValue: 0xFF0040E0,
    lastMessage: 'تم قبول العرض، يرجى التحضير للإنتاج',
    lastTime: 'منذ 5 دقائق',
    unreadCount: 3,
    isPinned: true,
    isMuted: false,
    isOnline: true,
    isVerified: true,
    type: ConversationType.business,
    priority: MessagePriority.high,
    status: ConversationStatus.active,
    rfqNumber: 'RFQ-8820',
    orderNumber: 'ORD-2241',
    currentStatus: 'الاتفاق النهائي',
    hasAttachment: true,
  ),
  const Conversation(
    id: 'conv_002',
    companyName: 'حلول جدة للنسيج',
    companyLogoText: 'JT',
    companyLogoBgColorValue: 0xFF006B5F,
    lastMessage: 'نطلب مراجعة بنود التسليم مجدداً',
    lastTime: 'منذ 2 ساعة',
    unreadCount: 1,
    isPinned: true,
    isMuted: false,
    isOnline: false,
    isVerified: true,
    type: ConversationType.business,
    priority: MessagePriority.urgent,
    status: ConversationStatus.active,
    rfqNumber: 'RFQ-8794',
    orderNumber: 'ORD-2218',
    currentStatus: 'تفاوض',
  ),
  const Conversation(
    id: 'conv_003',
    companyName: 'مصنع الدمام للملابس',
    companyLogoText: 'DC',
    companyLogoBgColorValue: 0xFF993100,
    lastMessage: 'شكراً على الشحنة، الجودة ممتازة',
    lastTime: 'أمس',
    unreadCount: 0,
    isPinned: false,
    isMuted: false,
    isOnline: true,
    isVerified: false,
    type: ConversationType.business,
    priority: MessagePriority.normal,
    status: ConversationStatus.active,
    rfqNumber: 'RFQ-8710',
    orderNumber: 'ORD-2190',
    currentStatus: 'مكتمل',
  ),
  const Conversation(
    id: 'conv_004',
    companyName: 'مجموعة أبوظبي للتوريد',
    companyLogoText: 'AS',
    companyLogoBgColorValue: 0xFF8B5CF6,
    lastMessage: 'هل يمكن تعديل الكمية إلى 8,000 متر؟',
    lastTime: 'منذ 3 أيام',
    unreadCount: 0,
    isPinned: false,
    isMuted: true,
    isOnline: false,
    isVerified: true,
    type: ConversationType.business,
    priority: MessagePriority.normal,
    status: ConversationStatus.active,
    rfqNumber: 'RFQ-8688',
    currentStatus: 'طلب عرض',
  ),
  const Conversation(
    id: 'sup_001',
    companyName: 'فريق دعم نسيجي',
    companyLogoText: 'NS',
    companyLogoBgColorValue: 0xFF0040E0,
    lastMessage: 'تم استلام مشكلتك وسيتم المعالجة خلال 24 ساعة',
    lastTime: 'منذ ساعة',
    unreadCount: 2,
    isPinned: false,
    isMuted: false,
    isOnline: true,
    isVerified: true,
    type: ConversationType.support,
    priority: MessagePriority.high,
    status: ConversationStatus.active,
    currentStatus: 'جاري المعالجة',
  ),
  const Conversation(
    id: 'sup_002',
    companyName: 'فريق دعم نسيجي',
    companyLogoText: 'NS',
    companyLogoBgColorValue: 0xFF0040E0,
    lastMessage: 'تم حل مشكلة الفاتورة بنجاح',
    lastTime: 'منذ أسبوع',
    unreadCount: 0,
    isPinned: false,
    isMuted: false,
    isOnline: false,
    isVerified: true,
    type: ConversationType.support,
    priority: MessagePriority.normal,
    status: ConversationStatus.active,
    currentStatus: 'مغلق',
  ),
];

Map<String, List<BusinessMessage>> _buildMessages() => {
  'conv_001': [
    const BusinessMessage(
      id: 'm001',
      senderId: 'factory_001',
      senderName: 'مصنع الرياض للملابس',
      senderAvatar: '',
      content: 'مرحباً، أرسلنا طلب عرض أسعار جديد لـ 5,000 متر قطن 100%',
      time: '09:00',
      isOutgoing: false,
      type: MessageType.text,
      readStatus: ReadStatus.read,
    ),
    BusinessMessage(
      id: 'm002',
      senderId: 'supplier',
      senderName: 'مورد نسيجي',
      senderAvatar: '',
      content: 'تم استلام الطلب، جاري مراجعة التفاصيل',
      time: '09:15',
      isOutgoing: true,
      type: MessageType.text,
      readStatus: ReadStatus.read,
    ),
    BusinessMessage(
      id: 'm003',
      senderId: 'supplier',
      senderName: 'مورد نسيجي',
      senderAvatar: '',
      content: 'عرض أسعار رقم Q-2024-001',
      time: '09:30',
      isOutgoing: true,
      type: MessageType.quotationCard,
      readStatus: ReadStatus.read,
      cardData: {
        'version': 'V1',
        'unitPrice': '12.50',
        'quantity': '5,000 م',
        'deliveryDays': '21 يوم',
        'paymentTerms': '30% مقدم، 70% عند الشحن',
        'validUntil': '2024-08-15',
        'status': 'pending',
      },
    ),
    const BusinessMessage(
      id: 'm004',
      senderId: 'factory_001',
      senderName: 'مصنع الرياض للملابس',
      senderAvatar: '',
      content: 'عرض مضاد',
      time: '10:00',
      isOutgoing: false,
      type: MessageType.counterOfferCard,
      readStatus: ReadStatus.read,
      cardData: {
        'currentPrice': '12.50',
        'counterPrice': '11.80',
        'reason': 'نطلب تعديل السعر بناءً على الكميات الكبيرة المتوقعة',
        'status': 'pending',
      },
    ),
    BusinessMessage(
      id: 'm005',
      senderId: 'supplier',
      senderName: 'مورد نسيجي',
      senderAvatar: '',
      content: 'عرض أسعار معدّل Q-2024-001 V2',
      time: '11:00',
      isOutgoing: true,
      type: MessageType.quotationCard,
      readStatus: ReadStatus.read,
      cardData: {
        'version': 'V2',
        'unitPrice': '12.00',
        'quantity': '5,000 م',
        'deliveryDays': '18 يوم',
        'paymentTerms': '30% مقدم، 70% عند الشحن',
        'validUntil': '2024-08-20',
        'status': 'accepted',
      },
    ),
    const BusinessMessage(
      id: 'm006',
      senderId: 'factory_001',
      senderName: 'مصنع الرياض للملابس',
      senderAvatar: '',
      content: 'الاتفاق النهائي - ORD-2241',
      time: '11:30',
      isOutgoing: false,
      type: MessageType.agreementCard,
      readStatus: ReadStatus.read,
      cardData: {
        'finalPrice': '12.00',
        'quantity': '5,000 م',
        'deliveryDate': '2024-09-05',
        'paymentMethod': 'تحويل بنكي',
        'status': 'confirmed',
        'orderNumber': 'ORD-2241',
      },
    ),
    const BusinessMessage(
      id: 'm007',
      senderId: 'factory_001',
      senderName: 'مصنع الرياض للملابس',
      senderAvatar: '',
      content: 'تم قبول العرض، يرجى التحضير للإنتاج',
      time: '11:35',
      isOutgoing: false,
      type: MessageType.text,
      readStatus: ReadStatus.delivered,
    ),
  ],
  'conv_002': [
    const BusinessMessage(
      id: 'n001',
      senderId: 'factory_002',
      senderName: 'حلول جدة للنسيج',
      senderAvatar: '',
      content: 'نحتاج 12,500 متر بوليستر حريري متدرج',
      time: 'أمس 14:00',
      isOutgoing: false,
      type: MessageType.text,
      readStatus: ReadStatus.read,
    ),
    BusinessMessage(
      id: 'n002',
      senderId: 'supplier',
      senderName: 'مورد نسيجي',
      senderAvatar: '',
      content: 'عرض أسعار أولي Q-2024-002',
      time: 'أمس 15:00',
      isOutgoing: true,
      type: MessageType.quotationCard,
      readStatus: ReadStatus.read,
      cardData: {
        'version': 'V1',
        'unitPrice': '18.75',
        'quantity': '12,500 م',
        'deliveryDays': '35 يوم',
        'paymentTerms': '40% مقدم، 60% قبل الشحن',
        'validUntil': '2024-08-10',
        'status': 'pending',
      },
    ),
    const BusinessMessage(
      id: 'n003',
      senderId: 'factory_002',
      senderName: 'حلول جدة للنسيج',
      senderAvatar: '',
      content: 'نطلب مراجعة بنود التسليم مجدداً',
      time: 'منذ 2 ساعة',
      isOutgoing: false,
      type: MessageType.text,
      readStatus: ReadStatus.delivered,
    ),
  ],
  'sup_001': [
    const BusinessMessage(
      id: 's001',
      senderId: 'supplier',
      senderName: 'مورد نسيجي',
      senderAvatar: '',
      content: 'لديّ مشكلة في تحميل مستندات الشحن للطلب ORD-2190',
      time: 'منذ ساعتين',
      isOutgoing: true,
      type: MessageType.text,
      readStatus: ReadStatus.read,
    ),
    const BusinessMessage(
      id: 's002',
      senderId: 'agent_001',
      senderName: 'أحمد - الدعم الفني',
      senderAvatar: '',
      content: 'مرحباً! تم استلام مشكلتك وسيتم المعالجة خلال 24 ساعة. رقم التذكرة: TKT-5521',
      time: 'منذ ساعة',
      isOutgoing: false,
      type: MessageType.text,
      readStatus: ReadStatus.delivered,
    ),
  ],
};

Map<String, SupportTicket> _buildTickets() => {
  'sup_001': SupportTicket(
    ticketId: 'TKT-5521',
    subject: 'مشكلة في تحميل مستندات الشحن',
    category: TicketCategory.shipping,
    priority: TicketPriority.high,
    status: TicketStatus.inProgress,
    agentName: 'أحمد - الدعم الفني',
    agentAvatar: '',
    createdAt: 'منذ ساعتين',
    lastUpdated: 'منذ ساعة',
    messages: _buildMessages()['sup_001'] ?? [],
  ),
  'sup_002': SupportTicket(
    ticketId: 'TKT-5498',
    subject: 'استفسار عن فاتورة الطلب ORD-2150',
    category: TicketCategory.payments,
    priority: TicketPriority.medium,
    status: TicketStatus.closed,
    agentName: 'سارة - الدعم المالي',
    agentAvatar: '',
    createdAt: 'منذ أسبوع',
    lastUpdated: 'منذ 5 أيام',
    messages: [],
    ratingGiven: 5,
  ),
};

List<MessageAttachment> _buildAttachments(String conversationId) => [
  MessageAttachment(
    id: 'att_001',
    conversationId: conversationId,
    filename: 'fabric_sample_cotton.jpg',
    fileSize: '2.4 MB',
    type: AttachmentType.image,
    url: '',
    uploadedAt: 'منذ يومين',
    uploadedBy: 'مصنع الرياض',
    thumbnailUrl: '',
  ),
  MessageAttachment(
    id: 'att_002',
    conversationId: conversationId,
    filename: 'quality_report_Q2024.pdf',
    fileSize: '1.1 MB',
    type: AttachmentType.qualityReport,
    url: '',
    uploadedAt: 'منذ 3 أيام',
    uploadedBy: 'مورد نسيجي',
  ),
  MessageAttachment(
    id: 'att_003',
    conversationId: conversationId,
    filename: 'invoice_ORD2241.pdf',
    fileSize: '0.8 MB',
    type: AttachmentType.invoice,
    url: '',
    uploadedAt: 'أمس',
    uploadedBy: 'مورد نسيجي',
  ),
  MessageAttachment(
    id: 'att_004',
    conversationId: conversationId,
    filename: 'ISO_9001_certificate.pdf',
    fileSize: '0.5 MB',
    type: AttachmentType.certificate,
    url: '',
    uploadedAt: 'منذ أسبوع',
    uploadedBy: 'مورد نسيجي',
  ),
  MessageAttachment(
    id: 'att_005',
    conversationId: conversationId,
    filename: 'shipping_manifest_ORD2241.pdf',
    fileSize: '1.3 MB',
    type: AttachmentType.shippingDoc,
    url: '',
    uploadedAt: 'منذ 4 أيام',
    uploadedBy: 'شركة الشحن',
  ),
  MessageAttachment(
    id: 'att_006',
    conversationId: conversationId,
    filename: 'production_video_batch1.mp4',
    fileSize: '45.2 MB',
    type: AttachmentType.video,
    url: '',
    uploadedAt: 'منذ 5 أيام',
    uploadedBy: 'مورد نسيجي',
    thumbnailUrl: '',
  ),
];
