import 'package:naseeji_factory/supplier/core/mock/mock_data.dart';
import 'package:naseeji_factory/supplier/core/mock/subscription_mock.dart' hide SubscriptionStatus;
import '../../domain/entities/subscription_models.dart';

abstract class SubscriptionRemoteDatasource {
  Future<SubscriptionModel> fetchSubscription();
  Future<List<SubscriptionPlanMock>> fetchPlans();
  Future<List<SubscriptionInvoiceMock>> fetchInvoices();
  Future<List<SubscriptionHistoryMock>> fetchHistory();
  Future<bool> upgradePlan(SubscriptionPlanMock plan);
  Future<bool> renewSubscription();
  Future<String?> validateAddProduct();
  Future<String?> validateMediaUpload({required String type, required int currentCount});

  // Extended Datasource Methods
  Future<SupplierSubscription> fetchSupplierSubscription();
  Future<List<SubscriptionPlan>> fetchSupplierPlans();
  Future<SubscriptionUsage> fetchUsage();
  Future<BillingData> fetchBillingData();
  Future<List<PaymentMethodItem>> fetchPaymentMethods();
  Future<List<AddonItem>> fetchAddons();
  Future<List<SubscriptionHistoryItem>> fetchSubscriptionHistory();
  Future<List<SubscriptionInvoice>> fetchSubscriptionInvoices();
  Future<List<SubscriptionNotification>> fetchNotifications();
  Future<SubscriptionAnalyticsData> fetchAnalytics();

  Future<void> toggleAutoRenew(bool val);
  Future<void> upgradePlanById(String planId, BillingCycle cycle);
  Future<void> downgradePlan(String planId, BillingCycle cycle);
  Future<void> applyCoupon(String code);
  Future<void> addPaymentMethod(PaymentMethodItem method);
  Future<void> deletePaymentMethod(String id);
  Future<void> setDefaultPaymentMethod(String id);
  Future<void> purchaseAddon(String addonId);
  Future<void> purchasePayAsYouGo(String serviceName, double cost);

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

class SubscriptionRemoteDatasourceImpl implements SubscriptionRemoteDatasource {
  @override
  Future<SubscriptionModel> fetchSubscription() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return MockDatabase.getCurrentSubscription();
  }

  @override
  Future<List<SubscriptionPlanMock>> fetchPlans() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return MockDatabase.subscriptionPlans;
  }

  @override
  Future<List<SubscriptionInvoiceMock>> fetchInvoices() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return MockDatabase.subscriptionInvoices;
  }

  @override
  Future<List<SubscriptionHistoryMock>> fetchHistory() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return MockDatabase.subscriptionHistory;
  }

  @override
  Future<bool> upgradePlan(SubscriptionPlanMock plan) async {
    await Future.delayed(const Duration(milliseconds: 50));
    MockDatabase.upgradeSubscriptionPlan(plan);
    return true;
  }

  @override
  Future<bool> renewSubscription() async {
    await Future.delayed(const Duration(milliseconds: 50));
    MockDatabase.renewSubscription();
    return true;
  }

  @override
  Future<String?> validateAddProduct() async {
    return MockDatabase.validateAddProductLimits();
  }

  @override
  Future<String?> validateMediaUpload({required String type, required int currentCount}) async {
    return MockDatabase.validateMediaLimits(type: type, currentCount: currentCount);
  }

  @override
  Future<SupplierSubscription> fetchSupplierSubscription() async {
    final sub = MockDatabase.getCurrentSubscription();
    return SupplierSubscription(
      planId: sub.planType.name,
      tier: sub.planType == SubscriptionPlanType.enterprise
          ? PlanTier.enterprise
          : (sub.planType == SubscriptionPlanType.professional ? PlanTier.professional : PlanTier.basic),
      planName: sub.planName,
      status: sub.isExpired ? SubscriptionStatus.expired : SubscriptionStatus.active,
      billingCycle: BillingCycle.monthly,
      startDate: sub.startDate,
      expiryDate: sub.endDate,
      nextRenewal: sub.renewalDate,
      remainingDays: sub.remainingDays,
      autoRenew: true,
      price: 1299.0,
      paymentMethod: 'بطاقة ائتمانية (فوري / ميزة)',
      limits: ResourceLimits(
        maxProducts: sub.productsLimit,
        maxImagesPerProduct: sub.imagesPerProduct,
        maxVideosPerProduct: sub.videosPerProduct,
        maxPdfsPerProduct: sub.pdfPerProduct,
        maxAdvertisements: 5,
        maxMonthlyRfqs: 50,
        maxFeaturedProducts: 3,
        maxEmployees: sub.employeeLimit,
        hasAiInsights: sub.analyticsEnabled,
        hasPrioritySupport: sub.prioritySupport,
      ),
    );
  }

  @override
  Future<List<SubscriptionPlan>> fetchSupplierPlans() async {
    return MockDatabase.subscriptionPlans.map((p) {
      return SubscriptionPlan(
        id: p.id,
        tier: p.type == SubscriptionPlanType.enterprise
            ? PlanTier.enterprise
            : (p.type == SubscriptionPlanType.professional ? PlanTier.professional : PlanTier.basic),
        name: p.name,
        price: p.pricePerMonth,
        billingCycle: BillingCycle.monthly,
        features: [
          'حتى ${p.productsLimit} منتج',
          '${p.imagesPerProduct} صور لكل منتج',
          '${p.videosPerProduct} فيديو لكل منتج',
          '${p.pdfPerProduct} ملفات PDF',
          '${p.employeeLimit} موظفين للحساب',
        ],
        limits: ResourceLimits(
          maxProducts: p.productsLimit,
          maxImagesPerProduct: p.imagesPerProduct,
          maxVideosPerProduct: p.videosPerProduct,
          maxPdfsPerProduct: p.pdfPerProduct,
          maxAdvertisements: 5,
          maxMonthlyRfqs: 50,
          maxFeaturedProducts: 3,
          maxEmployees: p.employeeLimit,
          hasAiInsights: p.analyticsEnabled,
          hasPrioritySupport: p.prioritySupport,
        ),
        isRecommended: p.type == SubscriptionPlanType.professional,
      );
    }).toList();
  }

  @override
  Future<SubscriptionUsage> fetchUsage() async {
    final sub = MockDatabase.getCurrentSubscription();
    return SubscriptionUsage(
      productsUsed: sub.productsUsed,
      advertisementsUsed: 2,
      featuredProductsUsed: 1,
      rfqsUsed: 12,
      videosUsed: 3,
      pdfsUsed: 4,
      storageUsedGb: 1.8,
      employeesUsed: 3,
      branchesUsed: 1,
      campaignsUsed: 1,
      couponsUsed: 2,
      notificationsUsed: 25,
      aiReportsUsed: 4,
    );
  }

  @override
  Future<BillingData> fetchBillingData() async {
    return BillingData(
      currentBill: 1299.0,
      nextInvoiceDate: DateTime.now().add(const Duration(days: 7)),
      outstandingBalance: 0.0,
      paidAmount: 1299.0,
      tax: 181.86,
      discount: 0.0,
    );
  }

  @override
  Future<List<PaymentMethodItem>> fetchPaymentMethods() async {
    return const [
      PaymentMethodItem(
        id: 'PM-101',
        type: PaymentMethodType.creditCard,
        name: 'بطاقة ائتمان ميزة / فوري',
        details: '**** **** **** 4242',
        isDefault: true,
        isVerified: true,
      ),
    ];
  }

  @override
  Future<List<AddonItem>> fetchAddons() async {
    return const [
      AddonItem(
        id: 'ADD-01',
        name: 'حزمة 10 منتجات إضافية',
        price: 299.0,
        description: 'إضافة 10 منتجات جديدة إلى كتالوجك الحالي.',
        validity: 'شهر واحد',
        usage: '10 منتجات',
        type: AddonType.products,
        quantity: 10,
      ),
    ];
  }

  @override
  Future<List<SubscriptionHistoryItem>> fetchSubscriptionHistory() async {
    return MockDatabase.subscriptionHistory.map((h) {
      return SubscriptionHistoryItem(
        id: h.historyId,
        planName: h.newPlanName,
        price: 1299.0,
        billingCycle: 'شهري',
        startDate: h.timestamp.subtract(const Duration(days: 30)),
        endDate: h.timestamp,
        status: 'مكتمل',
        paymentStatus: 'مدفوع',
        invoiceNumber: 'INV-${h.historyId}',
      );
    }).toList();
  }

  @override
  Future<List<SubscriptionInvoice>> fetchSubscriptionInvoices() async {
    return MockDatabase.subscriptionInvoices.map((inv) {
      return SubscriptionInvoice(
        invoiceNumber: inv.invoiceId,
        planName: inv.planName,
        amount: inv.amount,
        vat: inv.amount * 0.14,
        discount: 0.0,
        status: 'مدفوع',
        createdDate: inv.invoiceDate,
        paidDate: inv.invoiceDate,
      );
    }).toList();
  }

  @override
  Future<List<SubscriptionNotification>> fetchNotifications() async {
    return MockDatabase.notifications.map((n) {
      return SubscriptionNotification(
        id: n.id,
        title: n.title,
        body: n.body,
        timestamp: n.timestamp,
        type: 'Info',
      );
    }).toList();
  }

  @override
  Future<SubscriptionAnalyticsData> fetchAnalytics() async {
    return const SubscriptionAnalyticsData(
      monthlySpending: [1299, 1299, 1299, 1299],
      subscriptionCost: 1299,
      addonSpending: 299,
      featureUsagePercent: {'products': 80.0, 'images': 40.0, 'videos': 30.0},
      storageGrowthGb: [0.5, 1.0, 1.5, 1.8],
      adUsageGrowth: [1, 2, 2, 3],
      productGrowth: [5, 12, 18, 25],
      roi: 340.0,
      subscriptionSavings: 450.0,
      recommendedPlanId: 'plan_professional',
    );
  }

  @override
  Future<void> toggleAutoRenew(bool val) async {}

  @override
  Future<void> upgradePlanById(String planId, BillingCycle cycle) async {
    final match = MockDatabase.subscriptionPlans.firstWhere(
      (p) => p.id == planId,
      orElse: () => MockDatabase.subscriptionPlans[1],
    );
    MockDatabase.upgradeSubscriptionPlan(match);
  }

  @override
  Future<void> downgradePlan(String planId, BillingCycle cycle) async {}

  @override
  Future<void> applyCoupon(String code) async {}

  @override
  Future<void> addPaymentMethod(PaymentMethodItem method) async {}

  @override
  Future<void> deletePaymentMethod(String id) async {}

  @override
  Future<void> setDefaultPaymentMethod(String id) async {}

  @override
  Future<void> purchaseAddon(String addonId) async {}

  @override
  Future<void> purchasePayAsYouGo(String serviceName, double cost) async {}

  @override
  void incrementProductsUsed() {}

  @override
  void incrementAdsUsed() {}

  @override
  void incrementFeaturedProductsUsed() {}

  @override
  void incrementRfqsUsed() {}

  @override
  void setUsage({int? products, int? ads, int? videos, int? pdfs, int? rfqs, int? featured}) {}
}

