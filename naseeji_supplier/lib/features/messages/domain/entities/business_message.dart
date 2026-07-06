enum MessageType {
  text,
  image,
  video,
  voice,
  pdf,
  document,
  location,
  contact,
  quotationCard,
  counterOfferCard,
  agreementCard,
  productionCard,
  shipmentCard,
  deliveryCard,
  paymentCard,
  timelineEvent,
}

enum ReadStatus { sent, delivered, read }

class BusinessMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final String content;
  final String time;
  final bool isOutgoing;
  final MessageType type;
  final ReadStatus readStatus;
  final List<String>? attachmentUrls;
  final String? replyToId;
  final String? replyToContent;
  final Map<String, dynamic>? cardData;
  final String? reaction;
  final bool isDeleted;
  final bool isEdited;

  const BusinessMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.content,
    required this.time,
    required this.isOutgoing,
    required this.type,
    this.readStatus = ReadStatus.sent,
    this.attachmentUrls,
    this.replyToId,
    this.replyToContent,
    this.cardData,
    this.reaction,
    this.isDeleted = false,
    this.isEdited = false,
  });

  BusinessMessage copyWith({
    ReadStatus? readStatus,
    String? reaction,
    bool? isDeleted,
    bool? isEdited,
    String? content,
  }) {
    return BusinessMessage(
      id: id,
      senderId: senderId,
      senderName: senderName,
      senderAvatar: senderAvatar,
      content: content ?? this.content,
      time: time,
      isOutgoing: isOutgoing,
      type: type,
      readStatus: readStatus ?? this.readStatus,
      attachmentUrls: attachmentUrls,
      replyToId: replyToId,
      replyToContent: replyToContent,
      cardData: cardData,
      reaction: reaction ?? this.reaction,
      isDeleted: isDeleted ?? this.isDeleted,
      isEdited: isEdited ?? this.isEdited,
    );
  }
}
