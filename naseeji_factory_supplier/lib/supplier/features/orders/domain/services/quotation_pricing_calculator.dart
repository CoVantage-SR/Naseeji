class QuotationPricingCalculator {
  static double calculateSubtotal(double unitPrice, double quantity) {
    return unitPrice * quantity;
  }

  static double calculateTaxAmount({
    required double subtotal,
    required double discount,
    required double taxRatePercent,
  }) {
    final taxable = subtotal - discount;
    if (taxable <= 0) return 0.0;
    return taxable * (taxRatePercent / 100);
  }

  static double calculateGrandTotal({
    required double subtotal,
    required double discount,
    required double taxAmount,
    required double shippingCost,
    required double additionalCharges,
  }) {
    final val = subtotal - discount + taxAmount + shippingCost + additionalCharges;
    return val < 0 ? 0.0 : val;
  }
}

