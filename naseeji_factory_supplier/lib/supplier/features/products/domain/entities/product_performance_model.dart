class ProductPerformanceModel {
  final int views;
  final int pageVisits;
  final int saves;
  final int catalogDownloads;
  final int videoViews;
  final int rfqRequests;
  final int quotesSubmitted;
  final int agreementsCount;
  final int completedOrders;
  final double conversionRatePercent;
  final List<String> topKeywords;
  final String lastActivityText;
  final double totalRevenue;

  const ProductPerformanceModel({
    required this.views,
    required this.pageVisits,
    required this.saves,
    required this.catalogDownloads,
    required this.videoViews,
    required this.rfqRequests,
    required this.quotesSubmitted,
    this.agreementsCount = 8,
    required this.completedOrders,
    required this.conversionRatePercent,
    required this.topKeywords,
    required this.lastActivityText,
    required this.totalRevenue,
  });
}



