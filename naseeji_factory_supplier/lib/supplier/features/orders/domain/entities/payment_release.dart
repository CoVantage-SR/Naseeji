class PaymentRelease {
  final String rfqId;
  final double orderTotal;
  final double commission;
  final double supplierReceivable;
  final String paymentStatus;
  final String expectedReleaseDate;
  final String transferReference;
  final List<String> releaseTimeline;

  const PaymentRelease({
    required this.rfqId,
    required this.orderTotal,
    required this.commission,
    required this.supplierReceivable,
    required this.paymentStatus,
    required this.expectedReleaseDate,
    required this.transferReference,
    required this.releaseTimeline,
  });
}

