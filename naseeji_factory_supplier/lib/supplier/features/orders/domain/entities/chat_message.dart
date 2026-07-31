class ChatMessage {
  final String senderName;
  final String senderAvatar;
  final String content;
  final String time;
  final bool isOutgoing;
  final List<String>? imageAttachments;
  final String? pdfName;
  final String? pdfSize;
  final double? priceUpdateOld;
  final double? priceUpdateNew;
  final String? priceUpdateDesc;
  final bool isTypingIndicator;

  const ChatMessage({
    required this.senderName,
    required this.senderAvatar,
    required this.content,
    required this.time,
    required this.isOutgoing,
    this.imageAttachments,
    this.pdfName,
    this.pdfSize,
    this.priceUpdateOld,
    this.priceUpdateNew,
    this.priceUpdateDesc,
    this.isTypingIndicator = false,
  });
}



