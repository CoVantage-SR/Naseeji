class ProductPerformanceModel {
  final int views;
  final int saves;
  final int catalogDownloads;
  final int videoViews;
  final int rfqRequests;
  final int completedOrders;
  final double totalRevenue;

  const ProductPerformanceModel({
    required this.views,
    required this.saves,
    required this.catalogDownloads,
    required this.videoViews,
    required this.rfqRequests,
    required this.completedOrders,
    required this.totalRevenue,
  });
}
