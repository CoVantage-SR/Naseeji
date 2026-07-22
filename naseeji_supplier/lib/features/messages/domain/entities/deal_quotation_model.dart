class DealQuotationModel {
  final String quotationId;
  final double unitPrice;
  final double totalPrice;
  final String currency;
  final int quantity;
  final int moq;
  final String productionLeadTime; // مدة الإنتاج (e.g. 7 أيام عمل)
  final String validityPeriod; // مدة صلاحية العرض (e.g. 15 يوم)
  final String paymentTerms; // شروط الدفع (e.g. 50% دفعة مقدمة + 50% عند الاستلام)
  final String status; // حالة العرض (e.g. قيد الدراسة، مقبول، معدل)
  final DateTime createdAt;

  const DealQuotationModel({
    required this.quotationId,
    required this.unitPrice,
    required this.totalPrice,
    this.currency = 'ج.م',
    required this.quantity,
    required this.moq,
    required this.productionLeadTime,
    required this.validityPeriod,
    required this.paymentTerms,
    required this.status,
    required this.createdAt,
  });
}
