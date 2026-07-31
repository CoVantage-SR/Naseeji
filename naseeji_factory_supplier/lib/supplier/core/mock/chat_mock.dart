import 'package:naseeji_supplier/features/messages/domain/entities/conversation.dart';

class ChatMock {
  final String id;
  final String dealId;
  final String rfqId;
  final String companyName;
  final String companyLogoText;
  final int companyLogoBgColorValue;
  final String lastMessage;
  final String lastTime;
  final int unreadCount;
  final bool isPinned;
  final bool isMuted;
  final bool isOnline;
  final bool isVerified;
  final ConversationType type;
  final MessagePriority priority;
  final ConversationStatus status;
  final String currentStatus;

  const ChatMock({
    required this.id,
    required this.dealId,
    required this.rfqId,
    required this.companyName,
    required this.companyLogoText,
    required this.companyLogoBgColorValue,
    required this.lastMessage,
    required this.lastTime,
    required this.unreadCount,
    this.isPinned = false,
    this.isMuted = false,
    this.isOnline = true,
    this.isVerified = true,
    this.type = ConversationType.business,
    this.priority = MessagePriority.normal,
    this.status = ConversationStatus.active,
    required this.currentStatus,
  });

  Conversation toDomain() {
    return Conversation(
      id: id,
      companyName: companyName,
      companyLogoText: companyLogoText,
      companyLogoBgColorValue: companyLogoBgColorValue,
      lastMessage: lastMessage,
      lastTime: lastTime,
      unreadCount: unreadCount,
      isPinned: isPinned,
      isMuted: isMuted,
      isOnline: isOnline,
      isVerified: isVerified,
      type: type,
      priority: priority,
      status: status,
      rfqNumber: rfqId,
      orderNumber: dealId,
      currentStatus: currentStatus,
    );
  }

  static final sampleChats = [
    ChatMock(
      id: 'CHAT-101',
      dealId: 'DEAL-101',
      rfqId: 'RFQ-1025',
      companyName: 'شركة النسيج الحديثة للملابس',
      companyLogoText: 'ن',
      companyLogoBgColorValue: 0xFF006B5F,
      lastMessage: 'العرض الجديد مناسب جداً، جاري اعتماده والموافقة للبدء في إجراءات العقد 🟢',
      lastTime: 'منذ ٢٥ دقيقة',
      unreadCount: 2,
      currentStatus: 'قيد التفاوض',
    ),
    ChatMock(
      id: 'CHAT-102',
      dealId: 'DEAL-102',
      rfqId: 'RFQ-1026',
      companyName: 'مصانع غزل الشرق للتجهيزات',
      companyLogoText: 'ش',
      companyLogoBgColorValue: 0xFF2B5C8F,
      lastMessage: 'تم إرسال العقد والموافقة النهائية من المصنع 📄',
      lastTime: 'منذ ساعتين',
      unreadCount: 0,
      currentStatus: 'تم الاتفاق',
    ),
  ];
}
