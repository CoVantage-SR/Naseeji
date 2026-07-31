class DealAgreementModel {
  final String agreementId;
  final double finalTotalPrice;
  final String currency;
  final int finalQuantity;
  final String deliveryDate; // موعد التسليم
  final String pickupLocation; // مكان الاستلام
  final String paymentMethod; // طريقة الدفع الضامن Escrow
  final String status; // حالة الاتفاق (e.g. تم الاعتماد من الطرفين 🟢)
  final bool isApprovedBySupplier;
  final bool isApprovedByFactory;
  final DateTime approvedAt;

  const DealAgreementModel({
    required this.agreementId,
    required this.finalTotalPrice,
    this.currency = 'ج.م',
    required this.finalQuantity,
    required this.deliveryDate,
    required this.pickupLocation,
    required this.paymentMethod,
    required this.status,
    required this.isApprovedBySupplier,
    required this.isApprovedByFactory,
    required this.approvedAt,
  });
}
