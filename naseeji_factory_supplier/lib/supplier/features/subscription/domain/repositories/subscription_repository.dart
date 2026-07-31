import 'package:naseeji_factory/core/mock/subscription_mock.dart';
import '../entities/subscription_models.dart';

abstract class SubscriptionRepository {
  // Primary Clean Architecture Methods
  Future<SubscriptionModel> getSubscription();
  Future<List<SubscriptionPlanMock>> getPlans();
  Future<List<SubscriptionInvoiceMock>> getInvoices();
  Future<List<SubscriptionHistoryMock>> getHistory();
  Future<bool> upgradePlan(SubscriptionPlanMock plan);
  Future<bool> renewSubscription();
  Future<String?> validateAddProduct();
  Future<String?> validateMediaUpload({required String type, required int currentCount});

  // Extended Domain Methods for Feature Completeness
  Future<SupplierSubscription> getSupplierSubscription();
  Future<List<SubscriptionPlan>> getSupplierPlans();
  Future<SubscriptionUsage> getUsage();
  Future<BillingData> getBillingData();
  Future<List<PaymentMethodItem>> getPaymentMethods();
  Future<List<AddonItem>> getAddons();
  Future<List<SubscriptionHistoryItem>> getSubscriptionHistory();
  Future<List<SubscriptionInvoice>> getSubscriptionInvoices();
  Future<List<SubscriptionNotification>> getNotifications();
  Future<SubscriptionAnalyticsData> getAnalytics();

  // Mutation Operations
  Future<void> toggleAutoRenew(bool val);
  Future<void> upgradePlanById(String planId, BillingCycle cycle);
  Future<void> downgradePlan(String planId, BillingCycle cycle);
  Future<void> applyCoupon(String code);
  Future<void> addPaymentMethod(PaymentMethodItem method);
  Future<void> deletePaymentMethod(String id);
  Future<void> setDefaultPaymentMethod(String id);
  Future<void> purchaseAddon(String addonId);
  Future<void> purchasePayAsYouGo(String serviceName, double cost);

  // Usage Helpers
  void incrementProductsUsed();
  void incrementAdsUsed();
  void incrementFeaturedProductsUsed();
  void incrementRfqsUsed();
  void setUsage({
    int? products,
    int? ads,
    int? videos,
    int? pdfs,
    int? rfqs,
    int? featured,
  });
}


