enum AttachmentType { image, video, document, pdf, invoice, certificate, qualityReport, shippingDoc }

class MessageAttachment {
  final String id;
  final String conversationId;
  final String filename;
  final String fileSize;
  final AttachmentType type;
  final String url;
  final String uploadedAt;
  final String uploadedBy;
  final String? thumbnailUrl;

  const MessageAttachment({
    required this.id,
    required this.conversationId,
    required this.filename,
    required this.fileSize,
    required this.type,
    required this.url,
    required this.uploadedAt,
    required this.uploadedBy,
    this.thumbnailUrl,
  });

  String get typeLabel {
    switch (type) {
      case AttachmentType.image:         return 'صورة';
      case AttachmentType.video:         return 'فيديو';
      case AttachmentType.document:      return 'مستند';
      case AttachmentType.pdf:           return 'PDF';
      case AttachmentType.invoice:       return 'فاتورة';
      case AttachmentType.certificate:   return 'شهادة';
      case AttachmentType.qualityReport: return 'تقرير جودة';
      case AttachmentType.shippingDoc:   return 'مستند شحن';
    }
  }
}
