class SubscriptionOverviewModel {
  final String currentPlan;
  final int productsUsed;
  final int productsLimit;
  final int advertisementsUsed;
  final int advertisementsLimit;
  final int featuredProductsUsed;
  final int featuredProductsLimit;
  final int rfqsUsed;
  final int rfqsLimit;
  final DateTime expiryDate;
  final bool isExpiringSoon;

  const SubscriptionOverviewModel({
    required this.currentPlan,
    required this.productsUsed,
    required this.productsLimit,
    required this.advertisementsUsed,
    required this.advertisementsLimit,
    required this.featuredProductsUsed,
    required this.featuredProductsLimit,
    required this.rfqsUsed,
    required this.rfqsLimit,
    required this.expiryDate,
    required this.isExpiringSoon,
  });

  double get productsProgress => productsLimit == 0 ? 0.0 : (productsUsed / productsLimit).clamp(0.0, 1.0);
  double get advertisementsProgress => advertisementsLimit == 0 ? 0.0 : (advertisementsUsed / advertisementsLimit).clamp(0.0, 1.0);
  double get featuredProductsProgress => featuredProductsLimit == 0 ? 0.0 : (featuredProductsUsed / featuredProductsLimit).clamp(0.0, 1.0);
  double get rfqsProgress => rfqsLimit == 0 ? 0.0 : (rfqsUsed / rfqsLimit).clamp(0.0, 1.0);
}
