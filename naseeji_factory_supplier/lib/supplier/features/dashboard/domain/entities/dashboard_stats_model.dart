class DashboardStatsModel {
  final int newRfqs;
  final int waitingQuotations;
  final int ordersUnderNegotiation;
  final int ordersInProduction;
  final int readyForShipment;
  final int delayedOrders;
  final int completedOrders;
  final double monthlyRevenue;

  const DashboardStatsModel({
    required this.newRfqs,
    required this.waitingQuotations,
    required this.ordersUnderNegotiation,
    required this.ordersInProduction,
    required this.readyForShipment,
    required this.delayedOrders,
    required this.completedOrders,
    required this.monthlyRevenue,
  });
}
