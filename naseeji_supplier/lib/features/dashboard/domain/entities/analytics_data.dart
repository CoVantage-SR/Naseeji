class AnalyticsData {
  final double totalSales;
  final String salesTrend;
  final bool isSalesTrendPositive;
  
  final double netProfits;
  final String profitsTrend;
  final bool isProfitsTrendPositive;
  
  final int totalCustomers;
  final String customersTrend;
  final bool isCustomersTrendPositive;
  
  final int completedOrders;
  final String ordersTrend;
  final bool isOrdersTrendPositive;
  
  final List<Map<String, dynamic>> barData;
  final double readyForShippingPercentage;
  
  final int cottonOrders;
  final int silkOrders;
  final int syntheticOrders;

  const AnalyticsData({
    required this.totalSales,
    required this.salesTrend,
    required this.isSalesTrendPositive,
    required this.netProfits,
    required this.profitsTrend,
    required this.isProfitsTrendPositive,
    required this.totalCustomers,
    required this.customersTrend,
    required this.isCustomersTrendPositive,
    required this.completedOrders,
    required this.ordersTrend,
    required this.isOrdersTrendPositive,
    required this.barData,
    required this.readyForShippingPercentage,
    required this.cottonOrders,
    required this.silkOrders,
    required this.syntheticOrders,
  });
}
