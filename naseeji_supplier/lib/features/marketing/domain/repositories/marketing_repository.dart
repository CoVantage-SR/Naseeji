import '../entities/marketing_models.dart';

abstract class MarketingRepository {
  Future<MarketingDashboardData> getDashboardData();
  Future<List<B2BAdvertisement>> getAdvertisements();
  Future<B2BAdvertisement> createAdvertisement(B2BAdvertisement ad);
  Future<void> updateAdvertisementStatus(String id, AdStatus status);
  Future<void> deleteAdvertisement(String id);
  Future<List<MarketingCampaign>> getCampaigns();
  Future<MarketingCampaign> createCampaign(MarketingCampaign campaign);
  Future<void> updateCampaignStatus(String id, CampaignStatus status);
  Future<List<FeaturedProductPromotion>> getFeaturedProducts();
  Future<void> promoteProduct(FeaturedProductPromotion promotion);
  Future<List<PromotionalOffer>> getPromotionalOffers();
  Future<void> createOffer(PromotionalOffer offer);
  Future<List<B2BDiscountCoupon>> getCoupons();
  Future<B2BDiscountCoupon> createCoupon(B2BDiscountCoupon coupon);
  Future<void> updateCouponStatus(String id, bool active);
  Future<List<SponsoredProduct>> getSponsoredProducts();
  Future<SponsoredProduct> createSponsoredProduct(SponsoredProduct product);
  Future<void> updateSponsoredProductStatus(String id, bool active);
  Future<BudgetManagementData> getBudgetInfo();
  Future<void> updateBudget(double daily, double monthly);
  Future<MarketingAnalyticsData> getAnalytics();
  Future<List<MarketingNotification>> getSentNotifications();
  Future<MarketingNotification> sendNotification(MarketingNotification notification);
  Future<List<MarketingInsight>> getInsights();
  Future<SmartB2BRecommendation> getRecommendations();
}
