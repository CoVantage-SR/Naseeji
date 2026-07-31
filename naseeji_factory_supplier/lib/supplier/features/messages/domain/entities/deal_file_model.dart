enum DealFileType {
  catalog,
  pdf,
  qualityCert,
  image,
  video,
  document,
}

class DealFileModel {
  final String fileId;
  final String fileName;
  final String fileUrl;
  final String fileSize;
  final DealFileType fileType;
  final DateTime uploadedAt;

  const DealFileModel({
    required this.fileId,
    required this.fileName,
    required this.fileUrl,
    required this.fileSize,
    required this.fileType,
    required this.uploadedAt,
  });

  String get typeArabicLabel {
    switch (fileType) {
      case DealFileType.catalog:
        return 'كتالوج';
      case DealFileType.pdf:
        return 'ملف PDF';
      case DealFileType.qualityCert:
        return 'شهادة جودة ISO';
      case DealFileType.image:
        return 'صورة خامة';
      case DealFileType.video:
        return 'فيديو تصنيع';
      case DealFileType.document:
        return 'مستند عقد';
    }
  }
}

