class DeliveryConfirmation {
  final String rfqId;
  final String receivedDate;
  final String shipmentCondition;
  final String deliveredQuantity;
  final bool qualityMatch;
  final String comments;
  final List<String> deliveryImages;

  const DeliveryConfirmation({
    required this.rfqId,
    required this.receivedDate,
    required this.shipmentCondition,
    required this.deliveredQuantity,
    required this.qualityMatch,
    required this.comments,
    required this.deliveryImages,
  });
}

