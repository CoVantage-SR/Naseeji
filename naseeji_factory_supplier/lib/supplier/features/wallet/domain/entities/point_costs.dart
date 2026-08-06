class PointCosts {
  PointCosts._();

  /// Cost to publish a product (non-refundable if deleted)
  static const int uploadProduct = 5;

  /// Cost to boost a product in category listings for 7 days
  static const int boostProduct = 20;

  /// Cost to feature a product on home carousel for 14 days
  static const int featuredProduct = 40;

  /// Cost to sponsor a product at the top of search for 30 days
  static const int sponsoredProduct = 100;

  /// Cost to send promotional offer broadcast to factories
  static const int sendPromotionalOffer = 10;

  /// Cost to publish company banner advertisement for 7 days
  static const int companyAdvertisement = 50;

  /// Cost to increase priority rank in factory RFQ offers matrix
  static const int increaseRfqPriority = 25;

  /// Cost to unlock 90-day premium market analytics
  static const int unlockPremiumAnalytics = 30;

  /// Cost per extra product image beyond initial allowance
  static const int extraProductImage = 2;

  /// Cost per digital PDF catalog document uploaded
  static const int extraCatalogPdf = 5;

  /// Cost per optimized product video upload (<= 15s, <= 10MB)
  static const int extraProductVideo = 10;
}
