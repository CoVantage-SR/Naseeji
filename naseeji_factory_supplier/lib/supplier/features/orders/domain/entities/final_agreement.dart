class FinalAgreement {
  final String rfqId;
  final String factoryLabel;
  final String supplierLabel;
  final String productName;
  final String quantity;
  final double originalPrice;
  final double counterPrice;
  final double finalPrice;
  final double shippingCost;
  final double taxes;
  final double totalAmount;
  final String paymentTerms;
  final String deliveryTime;
  final String shippingMethod;
  final String date;
  final String version;

  const FinalAgreement({
    required this.rfqId,
    required this.factoryLabel,
    required this.supplierLabel,
    required this.productName,
    required this.quantity,
    required this.originalPrice,
    required this.counterPrice,
    required this.finalPrice,
    required this.shippingCost,
    required this.taxes,
    required this.totalAmount,
    required this.paymentTerms,
    required this.deliveryTime,
    required this.shippingMethod,
    required this.date,
    required this.version,
  });
}


