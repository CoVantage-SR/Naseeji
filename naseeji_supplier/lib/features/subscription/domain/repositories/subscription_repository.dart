import '../entities/subscription_models.dart';

abstract class SubscriptionRepository {
  Future<SupplierSubscription> getSubscription();
  Future<List<SubscriptionPlan>> getPlans();
  Future<SubscriptionUsage> getUsage();
  Future<BillingData> getBillingData();
  Future<List<PaymentMethodItem>> getPaymentMethods();
  Future<void> addPaymentMethod(PaymentMethodItem method);
  Future<void> deletePaymentMethod(String id);
  Future<void> setDefaultPaymentMethod(String id);
  Future<List<SubscriptionHistoryItem>> getSubscriptionHistory();
  Future<List<SubscriptionInvoice>> getInvoices();
  Future<List<AddonItem>> getAddons();
  Future<void> purchaseAddon(String addonId);
  Future<void> purchasePayAsYouGo(String serviceName, double cost);
  Future<void> upgradePlan(String planId, BillingCycle cycle);
  Future<void> downgradePlan(String planId, BillingCycle cycle);
  Future<void> renewSubscription();
  Future<void> toggleAutoRenew(bool autoRenew);
  Future<void> applyCoupon(String couponCode);
  Future<List<SubscriptionNotification>> getNotifications();
  Future<SubscriptionAnalyticsData> getAnalytics();
}
