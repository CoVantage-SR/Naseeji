class ProductTierPrice {
  final int minQuantity;
  final double pricePerUnit;
  final String formattedLabel; // e.g. "100 قطعة = 50 جنيه"

  const ProductTierPrice({
    required this.minQuantity,
    required this.pricePerUnit,
    required this.formattedLabel,
  });
}
