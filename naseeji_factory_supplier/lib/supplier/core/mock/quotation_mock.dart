import '../../features/messages/domain/entities/deal_quotation_model.dart';

class QuotationMock {
  final String quotationId;
  final String dealId;
  final int versionNumber;
  final double unitPrice;
  final double totalPrice;
  final String currency;
  final int quantity;
  final int moq;
  final String productionLeadTime;
  final String validityPeriod;
  final String paymentTerms;
  final String deliveryTerms;
  final DateTime? expectedDeliveryDate;
  final String notes;
  final OfferStatus offerStatus;
  final DateTime createdAt;
  final String createdByRole;

  const QuotationMock({
    required this.quotationId,
    required this.dealId,
    this.versionNumber = 1,
    required this.unitPrice,
    required this.totalPrice,
    this.currency = 'ج.م',
    required this.quantity,
    required this.moq,
    required this.productionLeadTime,
    required this.validityPeriod,
    required this.paymentTerms,
    required this.deliveryTerms,
    this.expectedDeliveryDate,
    this.notes = '',
    required this.offerStatus,
    required this.createdAt,
    this.createdByRole = 'المورد',
  });

  DealQuotationModel toDomain() {
    return DealQuotationModel(
      quotationId: quotationId,
      versionNumber: versionNumber,
      unitPrice: unitPrice,
      totalPrice: totalPrice,
      currency: currency,
      quantity: quantity,
      moq: moq,
      productionLeadTime: productionLeadTime,
      validityPeriod: validityPeriod,
      paymentTerms: paymentTerms,
      deliveryTerms: deliveryTerms,
      expectedDeliveryDate: expectedDeliveryDate,
      notes: notes,
      offerStatus: offerStatus,
      createdAt: createdAt,
      createdByRole: createdByRole,
    );
  }

  static final sampleQuotations = [
    QuotationMock(
      quotationId: 'QUO-8840-V1',
      dealId: 'DEAL-101',
      versionNumber: 1,
      unitPrice: 45.0,
      totalPrice: 450000.0,
      quantity: 10000,
      moq: 500,
      productionLeadTime: '٧ أيام عمل',
      validityPeriod: '١٥ يوم من تاريخ العرض',
      paymentTerms: '٥٠٪ دفعة مقدمة حجز + ٥٠٪ عند اعتماد التسليم بالضمين (Escrow)',
      deliveryTerms: 'تسليم بمستودع المصنع مباشرة',
      expectedDeliveryDate: DateTime.now().add(const Duration(days: 10)),
      notes: 'العرض شامل شهادة الاختبارات المعملية واختبارات الجودة ISO.',
      offerStatus: OfferStatus.counterOffer,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      createdByRole: 'المورد',
    ),
    QuotationMock(
      quotationId: 'QUO-8840-V2',
      dealId: 'DEAL-101',
      versionNumber: 2,
      unitPrice: 43.0,
      totalPrice: 430000.0,
      quantity: 10000,
      moq: 500,
      productionLeadTime: '٦ أيام عمل',
      validityPeriod: '١٥ يوم من تاريخ العرض',
      paymentTerms: '٥٠٪ دفعة مقدمة + ٥٠٪ عند الاستلام بالضمين',
      deliveryTerms: 'تسليم بمستودع المصنع مباشرة',
      expectedDeliveryDate: DateTime.now().add(const Duration(days: 8)),
      notes: 'تم تقديم خصم خاص 4% تلبية لطلب تعديل المصنع.',
      offerStatus: OfferStatus.sent,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      createdByRole: 'المورد',
    ),
  ];
}
