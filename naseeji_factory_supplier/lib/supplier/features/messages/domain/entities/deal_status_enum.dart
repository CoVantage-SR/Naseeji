enum DealStatus {
  newRfq, // طلبات جديدة
  awaitingResponse, // بانتظار رد المصنع
  negotiating, // قيد التفاوض
  agreed, // تم الاتفاق (Agreement Signed)
  inProduction, // قيد الإنتاج
  readyForShipment, // جاهز للتسليم
  delivering, // بانتظار تأكيد الاستلام
  qualityInspection, // فحص الجودة
  paymentPending, // بانتظار الدفع
  completed, // مكتملة
  cancelled, // ملغاة
  expired, // منتهية الصلاحية
  rejected; // مرفوضة

  String get titleAr => arabicLabel;

  String get arabicLabel {
    switch (this) {
      case DealStatus.newRfq:
        return 'طلب جديد (RFQ)';
      case DealStatus.awaitingResponse:
        return 'بانتظار رد المصنع';
      case DealStatus.negotiating:
        return 'قيد التفاوض';
      case DealStatus.agreed:
        return 'تم الاتفاق والعقد 🟢';
      case DealStatus.inProduction:
        return 'قيد الإنتاج والتصنيع 🏭';
      case DealStatus.readyForShipment:
        return 'جاهز للتسليم 🚛';
      case DealStatus.delivering:
        return 'بانتظار تأكيد الاستلام';
      case DealStatus.qualityInspection:
        return 'فحص الجودة المعملية 🔬';
      case DealStatus.paymentPending:
        return 'بانتظار تحويل الدفعة 💰';
      case DealStatus.completed:
        return 'صفقة مكتملة 🎉';
      case DealStatus.cancelled:
        return 'صفقة ملغاة 🔴';
      case DealStatus.expired:
        return 'عرض منتهي الصلاحية';
      case DealStatus.rejected:
        return 'عرض مرفوض';
    }
  }
}



