enum ModerationTarget {
  product, // نشر منتج
  productDescription, // وصف المنتج
  technicalSpec, // المواصفات
  comment, // التعليقات
  chatMessage, // المحادثات
  quotation, // عروض الأسعار
  note, // الملاحظات
  fileName, // اسم الملف
  imageName, // أسماء الصور
}

extension ModerationTargetExtension on ModerationTarget {
  String get arabicLabel {
    switch (this) {
      case ModerationTarget.product:
        return 'عنوان المنتج';
      case ModerationTarget.productDescription:
        return 'وصف المنتج';
      case ModerationTarget.technicalSpec:
        return 'المواصفات الفنية';
      case ModerationTarget.comment:
        return 'التعليق';
      case ModerationTarget.chatMessage:
        return 'الرسالة';
      case ModerationTarget.quotation:
        return 'عرض السعر';
      case ModerationTarget.note:
        return 'الملاحظة';
      case ModerationTarget.fileName:
        return 'اسم الملف';
      case ModerationTarget.imageName:
        return 'اسم الصورة';
    }
  }
}

enum ViolationType {
  phone,
  whatsapp,
  email,
  url,
  shortLink,
  socialPlatform,
  qrCode,
  ocrDetectedText,
  profanity,
}

extension ViolationTypeExtension on ViolationType {
  String get arabicLabel {
    switch (this) {
      case ViolationType.phone:
        return 'رقم هاتف';
      case ViolationType.whatsapp:
        return 'رقم أو رابط واتساب';
      case ViolationType.email:
        return 'بريد إلكتروني';
      case ViolationType.url:
        return 'رابط إلكتروني';
      case ViolationType.shortLink:
        return 'رابط مختصر';
      case ViolationType.socialPlatform:
        return 'حساب تواصل اجتماعي';
      case ViolationType.qrCode:
        return 'رمز QR';
      case ViolationType.ocrDetectedText:
        return 'نص محظور في صورة';
      case ViolationType.profanity:
        return 'محتوى غير ملائم';
    }
  }
}

enum ModerationSeverity {
  low, // تنبيه أول
  medium, // تحذير واضح
  high, // تصعيد للمراجعة والدعم
}


