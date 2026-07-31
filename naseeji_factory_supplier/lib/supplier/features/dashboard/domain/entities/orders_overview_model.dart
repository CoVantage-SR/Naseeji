class OrdersOverviewModel {
  final int preparing;
  final int readyForPickup;
  final int waitingLogistics;
  final int shipping;
  final int delivered;
  final int completed;
  final int delayed;

  const OrdersOverviewModel({
    required this.preparing,
    required this.readyForPickup,
    required this.waitingLogistics,
    required this.shipping,
    required this.delivered,
    required this.completed,
    required this.delayed,
  });

  int get totalActiveOrders => preparing + readyForPickup + waitingLogistics + shipping;
}

