class PerformanceOverviewModel {
  final double supplierRating;
  final double responseRate;
  final double onTimeDeliveryRate;
  final int acceptedQuotations;
  final int rejectedQuotations;
  final int completedOrders;
  final double customerSatisfaction;

  const PerformanceOverviewModel({
    required this.supplierRating,
    required this.responseRate,
    required this.onTimeDeliveryRate,
    required this.acceptedQuotations,
    required this.rejectedQuotations,
    required this.completedOrders,
    required this.customerSatisfaction,
  });
}
