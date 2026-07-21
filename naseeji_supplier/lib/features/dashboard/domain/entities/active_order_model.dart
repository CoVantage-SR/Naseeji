class ActiveOrderModel {
  final String orderId;
  final String buyerName;
  final String currentStage;
  final double progressPercentage; // e.g. 0.60 for 60%
  final String expectedDelivery;
  final String actionLabel;
  final String actionRoute;

  const ActiveOrderModel({
    required this.orderId,
    required this.buyerName,
    required this.currentStage,
    required this.progressPercentage,
    required this.expectedDelivery,
    required this.actionLabel,
    required this.actionRoute,
  });

  int get progressPercentInt => (progressPercentage * 100).round().clamp(0, 100);
}
