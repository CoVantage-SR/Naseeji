enum DealStatus {
  negotiating, // قيد التفاوض
  awaitingResponse, // بانتظار رد المصنع
  agreed, // تم الاتفاق
  inProduction, // قيد الإنتاج
  readyForShipment, // جاهز للشحن
}

extension DealStatusExtension on DealStatus {
  String get arabicLabel {
    switch (this) {
      case DealStatus.negotiating:
        return 'قيد التفاوض';
      case DealStatus.awaitingResponse:
        return 'بانتظار رد المصنع';
      case DealStatus.agreed:
        return 'تم الاتفاق';
      case DealStatus.inProduction:
        return 'قيد الإنتاج';
      case DealStatus.readyForShipment:
        return 'جاهز للشحن';
    }
  }
}
