import 'package:flutter/material.dart';

enum OfferStatus {
  draft('مسودة', Colors.grey, Icons.edit_note_rounded),
  sent('تم الإرسال', Colors.blue, Icons.send_rounded),
  waitingFactory('في انتظار المصنع', Colors.orange, Icons.hourglass_empty_rounded),
  counterOffer('عرض مضاد', Colors.purple, Icons.swap_horiz_rounded),
  accepted('مقبول', Colors.green, Icons.check_circle_rounded),
  rejected('مرفوض', Colors.red, Icons.cancel_rounded),
  expired('منتهي الصلاحية', Colors.amber, Icons.timer_off_rounded),
  cancelled('ملغى', Colors.blueGrey, Icons.block_rounded);

  final String label;
  final Color color;
  final IconData icon;

  const OfferStatus(this.label, this.color, this.icon);
}

class DealQuotationModel {
  final String quotationId;
  final int versionNumber;
  final double unitPrice;
  final double totalPrice;
  final String currency;
  final int quantity;
  final int moq;
  final String productionLeadTime; // مدة الإنتاج
  final String validityPeriod; // مدة صلاحية العرض
  final String paymentTerms; // شروط الدفع
  final String deliveryTerms; // طريقة التسليم
  final DateTime? expectedDeliveryDate; // تاريخ التسليم المتوقع
  final String notes; // ملاحظات العرض
  final OfferStatus offerStatus; // حالة العرض
  final DateTime createdAt;
  final String createdByRole; // المورد أو المصنع

  const DealQuotationModel({
    required this.quotationId,
    this.versionNumber = 1,
    required this.unitPrice,
    required this.totalPrice,
    this.currency = 'ج.م',
    required this.quantity,
    required this.moq,
    required this.productionLeadTime,
    required this.validityPeriod,
    required this.paymentTerms,
    this.deliveryTerms = 'توصيل المصنع مباشرة',
    this.expectedDeliveryDate,
    this.notes = '',
    required this.offerStatus,
    required this.createdAt,
    this.createdByRole = 'المورد',
  });

  DealQuotationModel copyWith({
    String? quotationId,
    int? versionNumber,
    double? unitPrice,
    double? totalPrice,
    String? currency,
    int? quantity,
    int? moq,
    String? productionLeadTime,
    String? validityPeriod,
    String? paymentTerms,
    String? deliveryTerms,
    DateTime? expectedDeliveryDate,
    String? notes,
    OfferStatus? offerStatus,
    DateTime? createdAt,
    String? createdByRole,
  }) {
    return DealQuotationModel(
      quotationId: quotationId ?? this.quotationId,
      versionNumber: versionNumber ?? this.versionNumber,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      currency: currency ?? this.currency,
      quantity: quantity ?? this.quantity,
      moq: moq ?? this.moq,
      productionLeadTime: productionLeadTime ?? this.productionLeadTime,
      validityPeriod: validityPeriod ?? this.validityPeriod,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      deliveryTerms: deliveryTerms ?? this.deliveryTerms,
      expectedDeliveryDate: expectedDeliveryDate ?? this.expectedDeliveryDate,
      notes: notes ?? this.notes,
      offerStatus: offerStatus ?? this.offerStatus,
      createdAt: createdAt ?? this.createdAt,
      createdByRole: createdByRole ?? this.createdByRole,
    );
  }
}


