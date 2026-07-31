import 'package:naseeji_factory/supplier/core/mock/subscription_mock.dart';
import '../../domain/entities/subscription_models.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../datasources/subscription_remote_datasource.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDatasource datasource;

  SubscriptionRepositoryImpl({required this.datasource});

  @override
  Future<SubscriptionModel> getSubscription() => datasource.fetchSubscription();

  @override
  Future<List<SubscriptionPlanMock>> getPlans() => datasource.fetchPlans();

  @override
  Future<List<SubscriptionInvoiceMock>> getInvoices() => datasource.fetchInvoices();

  @override
  Future<List<SubscriptionHistoryMock>> getHistory() => datasource.fetchHistory();

  @override
  Future<bool> upgradePlan(SubscriptionPlanMock plan) => datasource.upgradePlan(plan);

  @override
  Future<bool> renewSubscription() => datasource.renewSubscription();

  @override
  Future<String?> validateAddProduct() => datasource.validateAddProduct();

  @override
  Future<String?> validateMediaUpload({required String type, required int currentCount}) =>
      datasource.validateMediaUpload(type: type, currentCount: currentCount);

  // Extended Domain Methods
  @override
  Future<SupplierSubscription> getSupplierSubscription() => datasource.fetchSupplierSubscription();

  @override
  Future<List<SubscriptionPlan>> getSupplierPlans() => datasource.fetchSupplierPlans();

  @override
  Future<SubscriptionUsage> getUsage() => datasource.fetchUsage();

  @override
  Future<BillingData> getBillingData() => datasource.fetchBillingData();

  @override
  Future<List<PaymentMethodItem>> getPaymentMethods() => datasource.fetchPaymentMethods();

  @override
  Future<List<AddonItem>> getAddons() => datasource.fetchAddons();

  @override
  Future<List<SubscriptionHistoryItem>> getSubscriptionHistory() => datasource.fetchSubscriptionHistory();

  @override
  Future<List<SubscriptionInvoice>> getSubscriptionInvoices() => datasource.fetchSubscriptionInvoices();

  @override
  Future<List<SubscriptionNotification>> getNotifications() => datasource.fetchNotifications();

  @override
  Future<SubscriptionAnalyticsData> getAnalytics() => datasource.fetchAnalytics();

  @override
  Future<void> toggleAutoRenew(bool val) => datasource.toggleAutoRenew(val);

  @override
  Future<void> upgradePlanById(String planId, BillingCycle cycle) => datasource.upgradePlanById(planId, cycle);

  @override
  Future<void> downgradePlan(String planId, BillingCycle cycle) => datasource.downgradePlan(planId, cycle);

  @override
  Future<void> applyCoupon(String code) => datasource.applyCoupon(code);

  @override
  Future<void> addPaymentMethod(PaymentMethodItem method) => datasource.addPaymentMethod(method);

  @override
  Future<void> deletePaymentMethod(String id) => datasource.deletePaymentMethod(id);

  @override
  Future<void> setDefaultPaymentMethod(String id) => datasource.setDefaultPaymentMethod(id);

  @override
  Future<void> purchaseAddon(String addonId) => datasource.purchaseAddon(addonId);

  @override
  Future<void> purchasePayAsYouGo(String serviceName, double cost) => datasource.purchasePayAsYouGo(serviceName, cost);

  @override
  void incrementProductsUsed() => datasource.incrementProductsUsed();

  @override
  void incrementAdsUsed() => datasource.incrementAdsUsed();

  @override
  void incrementFeaturedProductsUsed() => datasource.incrementFeaturedProductsUsed();

  @override
  void incrementRfqsUsed() => datasource.incrementRfqsUsed();

  @override
  void setUsage({
    int? products,
    int? ads,
    int? videos,
    int? pdfs,
    int? rfqs,
    int? featured,
  }) =>
      datasource.setUsage(
        products: products,
        ads: ads,
        videos: videos,
        pdfs: pdfs,
        rfqs: rfqs,
        featured: featured,
      );
}

