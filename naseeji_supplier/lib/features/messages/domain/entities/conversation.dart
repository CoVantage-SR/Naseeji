enum ConversationType { business, support }
enum MessagePriority { normal, high, urgent }
enum ConversationStatus { active, archived, muted }

class Conversation {
  final String id;
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
  final String? rfqNumber;
  final String? orderNumber;
  final String? currentStatus;
  final bool isTyping;
  final bool hasAttachment;

  final bool isBlocked;
  final DateTime? muteUntil;

  const Conversation({
    required this.id,
    required this.companyName,
    required this.companyLogoText,
    required this.companyLogoBgColorValue,
    required this.lastMessage,
    required this.lastTime,
    required this.unreadCount,
    required this.isPinned,
    required this.isMuted,
    required this.isOnline,
    required this.isVerified,
    required this.type,
    required this.priority,
    required this.status,
    this.rfqNumber,
    this.orderNumber,
    this.currentStatus,
    this.isTyping = false,
    this.hasAttachment = false,
    this.isBlocked = false,
    this.muteUntil,
  });

  Conversation copyWith({
    bool? isPinned,
    bool? isMuted,
    int? unreadCount,
    ConversationStatus? status,
    bool? isTyping,
    String? lastMessage,
    String? lastTime,
    bool? isBlocked,
    DateTime? muteUntil,
  }) {
    return Conversation(
      id: id,
      companyName: companyName,
      companyLogoText: companyLogoText,
      companyLogoBgColorValue: companyLogoBgColorValue,
      lastMessage: lastMessage ?? this.lastMessage,
      lastTime: lastTime ?? this.lastTime,
      unreadCount: unreadCount ?? this.unreadCount,
      isPinned: isPinned ?? this.isPinned,
      isMuted: isMuted ?? this.isMuted,
      isOnline: isOnline,
      isVerified: isVerified,
      type: type,
      priority: priority,
      status: status ?? this.status,
      rfqNumber: rfqNumber,
      orderNumber: orderNumber,
      currentStatus: currentStatus,
      isTyping: isTyping ?? this.isTyping,
      hasAttachment: hasAttachment,
      isBlocked: isBlocked ?? this.isBlocked,
      muteUntil: muteUntil ?? this.muteUntil,
    );
  }
}
