import '../../domain/entities/subscription_models.dart';
import '../../domain/repositories/subscription_repository.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  // Static limits for each plan tier
  static const ResourceLimits freeLimits = ResourceLimits(
    maxProducts: 5,
    maxImagesPerProduct: 3,
    maxVideosPerProduct: 0,
    maxPdfsPerProduct: 1,
    maxAdvertisements: 5,
    maxMonthlyRfqs: 10,
    maxFeaturedProducts: 0,
    maxStorageGb: 2.0,
    maxEmployees: 1,
  );

  static const ResourceLimits basicLimits = ResourceLimits(
    maxProducts: 30,
    maxImagesPerProduct: 6,
    maxVideosPerProduct: 1,
    maxPdfsPerProduct: 1,
    maxAdvertisements: 20,
    maxMonthlyRfqs: 50,
    maxFeaturedProducts: 1,
    maxStorageGb: 10.0,
    maxEmployees: 5,
  );

  static const ResourceLimits proLimits = ResourceLimits(
    maxProducts: 100,
    maxImagesPerProduct: 10,
    maxVideosPerProduct: 1,
    maxPdfsPerProduct: 2,
    maxAdvertisements: 100,
    maxMonthlyRfqs: -1, // Unlimited
    maxFeaturedProducts: 5,
    maxStorageGb: 50.0,
    maxEmployees: 25,
    hasAiInsights: true,
    hasPrioritySupport: true,
  );

  static const ResourceLimits enterpriseLimits = ResourceLimits(
    maxProducts: -1, // Unlimited
    maxImagesPerProduct: 20,
    maxVideosPerProduct: -1, // Unlimited
    maxPdfsPerProduct: -1, // Unlimited
    maxAdvertisements: -1, // Unlimited
    maxMonthlyRfqs: -1, // Unlimited
    maxFeaturedProducts: -1, // Unlimited
    maxStorageGb: 500.0,
    maxEmployees: 100,
    hasAiInsights: true,
    hasPrioritySupport: true,
    hasApiAccess: true,
    hasBulkUpload: true,
  );

  // Default active subscription matching user prompt example (Professional)
  SupplierSubscription _subscription = SupplierSubscription(
    planId: 'professional',
    tier: PlanTier.professional,
    planName: 'Professional',
    status: SubscriptionStatus.active,
    billingCycle: BillingCycle.monthly,
    startDate: DateTime(2025, 10, 15),
    expiryDate: DateTime(2026, 10, 15),
    nextRenewal: DateTime(2026, 10, 15),
    remainingDays: 85,
    autoRenew: true,
    price: 699.0,
    paymentMethod: 'بطاقة مدى **** 4820',
    limits: proLimits,
  );

  // Usage stats matching user prompt example
  SubscriptionUsage _usage = const SubscriptionUsage(
    productsUsed: 58,
    advertisementsUsed: 22,
    featuredProductsUsed: 2,
    rfqsUsed: 10,
    videosUsed: 1,
    pdfsUsed: 1,
    storageUsedGb: 14.5,
    employeesUsed: 8,
    branchesUsed: 3,
    campaignsUsed: 5,
    couponsUsed: 12,
    notificationsUsed: 350,
    aiReportsUsed: 15,
  );

  BillingData _billing = BillingData(
    currentBill: 699.0,
    nextInvoiceDate: DateTime(2026, 10, 15),
    outstandingBalance: 0.0,
    paidAmount: 699.0,
    tax: 104.85, // 15% VAT
    discount: 0.0,
  );

  final List<PaymentMethodItem> _paymentMethods = [
    const PaymentMethodItem(
      id: 'PM-1',
      type: PaymentMethodType.creditCard,
      name: 'بطاقة مدى - بنك الراجحي',
      details: '**** **** **** 4820 | 09/28',
      isDefault: true,
      isVerified: true,
    ),
    const PaymentMethodItem(
      id: 'PM-2',
      type: PaymentMethodType.instaPay,
      name: 'حساب InstaPay للشركة',
      details: 'naseeji@instapay',
      isDefault: false,
      isVerified: true,
    ),
  ];

  final List<SubscriptionHistoryItem> _history = [
    SubscriptionHistoryItem(
      id: 'HST-101',
      planName: 'Professional',
      price: 699.0,
      billingCycle: 'شهري',
      startDate: DateTime(2025, 10, 15),
      endDate: DateTime(2026, 10, 15),
      status: 'نشط',
      paymentStatus: 'مدفوع',
      invoiceNumber: 'INV-2025-992',
    ),
    SubscriptionHistoryItem(
      id: 'HST-100',
      planName: 'Basic',
      price: 299.0,
      billingCycle: 'شهري',
      startDate: DateTime(2025, 4, 15),
      endDate: DateTime(2025, 10, 15),
      status: 'مكتمل',
      paymentStatus: 'مدفوع',
      invoiceNumber: 'INV-2025-412',
    ),
    SubscriptionHistoryItem(
      id: 'HST-099',
      planName: 'Free',
      price: 0.0,
      billingCycle: 'شهري',
      startDate: DateTime(2025, 1, 15),
      endDate: DateTime(2025, 4, 15),
      status: 'منتهي',
      paymentStatus: 'مجاني',
      invoiceNumber: 'INV-2025-001',
    ),
  ];

  final List<SubscriptionInvoice> _invoices = [
    SubscriptionInvoice(
      invoiceNumber: 'INV-2025-992',
      planName: 'Professional - شهري',
      amount: 699.0,
      vat: 104.85,
      discount: 0.0,
      status: 'مدفوعة',
      createdDate: DateTime(2025, 10, 15),
      paidDate: DateTime(2025, 10, 15),
    ),
  ];

  final List<SubscriptionNotification> _notifications = [
    SubscriptionNotification(
      id: 'NOT-1',
      title: 'تفعيل باقة Professional',
      body: 'تم تفعيل باقة Professional بنجاح لمؤسستك.',
      timestamp: DateTime(2025, 10, 15),
      type: 'success',
    ),
  ];

  // The 4 mandatory subscription plans
  final List<SubscriptionPlan> _plans = const [
    SubscriptionPlan(
      id: 'free',
      tier: PlanTier.free,
      name: 'Free',
      price: 0.0,
      billingCycle: BillingCycle.monthly,
      isRecommended: false,
      features: [
        '5 منتجات',
        '3 صور لكل منتج',
        'بدون فيديو',
        'PDF واحد لكل منتج',
        '5 إعلانات',
        '10 RFQ شهرياً',
        'بدون منتجات مميزة',
      ],
      limits: freeLimits,
    ),
    SubscriptionPlan(
      id: 'basic',
      tier: PlanTier.basic,
      name: 'Basic',
      price: 299.0,
      billingCycle: BillingCycle.monthly,
      isRecommended: false,
      features: [
        '30 منتج',
        '6 صور لكل منتج',
        'فيديو واحد لكل منتج',
        'PDF واحد لكل منتج',
        '20 إعلان',
        '50 RFQ شهرياً',
        'منتج مميز واحد',
      ],
      limits: basicLimits,
    ),
    SubscriptionPlan(
      id: 'professional',
      tier: PlanTier.professional,
      name: 'Professional',
      price: 699.0,
      billingCycle: BillingCycle.monthly,
      isRecommended: true,
      features: [
        '100 منتج',
        '10 صور لكل منتج',
        'فيديو واحد لكل منتج',
        '2 PDF لكل منتج',
        '100 إعلان',
        'RFQ غير محدود',
        '5 منتجات مميزة',
      ],
      limits: proLimits,
    ),
    SubscriptionPlan(
      id: 'enterprise',
      tier: PlanTier.enterprise,
      name: 'Enterprise',
      price: 1499.0,
      billingCycle: BillingCycle.monthly,
      isRecommended: false,
      features: [
        'منتجات غير محدودة',
        '20 صورة لكل منتج',
        'فيديوهات غير محدودة',
        'ملفات PDF غير محدودة',
        'إعلانات غير محدودة',
        'RFQ غير محدود',
        'منتجات مميزة غير محدودة',
      ],
      limits: enterpriseLimits,
    ),
  ];

  final List<AddonItem> _addons = const [
    AddonItem(
      id: 'ADD-PROD-50',
      name: 'حزمة +50 منتج إضافي',
      price: 99.0,
      description: 'إضافة 50 منتجاً لكتالوج التوريد دون الحاجة لترقية الباقة.',
      validity: 'سارية مع الاشتراك الحالي',
      usage: '+50 منتج',
      type: AddonType.products,
      quantity: 50,
    ),
    AddonItem(
      id: 'ADD-ADS-10',
      name: 'حزمة +10 إعلانات إضافية',
      price: 149.0,
      description: 'نشر 10 إعلانات إضافية لزيادة وصول منتجاتك.',
      validity: '30 يوماً',
      usage: '+10 إعلانات',
      type: AddonType.ads,
      quantity: 10,
    ),
  ];

  @override
  Future<SupplierSubscription> getSubscription() async {
    return _subscription;
  }

  @override
  Future<List<SubscriptionPlan>> getPlans() async {
    return _plans;
  }

  @override
  Future<SubscriptionUsage> getUsage() async {
    return _usage;
  }

  @override
  Future<BillingData> getBillingData() async {
    return _billing;
  }

  @override
  Future<List<PaymentMethodItem>> getPaymentMethods() async {
    return _paymentMethods;
  }

  @override
  Future<List<SubscriptionHistoryItem>> getSubscriptionHistory() async {
    return _history;
  }

  @override
  Future<void> setDefaultPaymentMethod(String id) async {
    for (var i = 0; i < _paymentMethods.length; i++) {
      final item = _paymentMethods[i];
      _paymentMethods[i] = item.copyWith(isDefault: item.id == id);
    }
  }

  @override
  Future<void> purchasePayAsYouGo(String serviceName, double cost) async {
    _invoices.insert(
      0,
      SubscriptionInvoice(
        invoiceNumber: 'INV-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        planName: 'دفع حسب الاستخدام: $serviceName',
        amount: cost,
        vat: cost * 0.15,
        discount: 0.0,
        status: 'مدفوعة',
        createdDate: DateTime.now(),
        paidDate: DateTime.now(),
      ),
    );
  }

  @override
  Future<List<SubscriptionInvoice>> getInvoices() async {
    return _invoices;
  }

  @override
  Future<List<AddonItem>> getAddons() async {
    return _addons;
  }

  @override
  Future<List<SubscriptionNotification>> getNotifications() async {
    return _notifications;
  }

  @override
  Future<SubscriptionAnalyticsData> getAnalytics() async {
    return const SubscriptionAnalyticsData(
      monthlySpending: [0, 299, 299, 699, 699, 699],
      subscriptionCost: 699.0,
      addonSpending: 0.0,
      featureUsagePercent: {
        'المنتجات': 58.0,
        'الإعلانات': 22.0,
        'الفيديو': 100.0,
        'PDF': 50.0,
      },
      storageGrowthGb: [2.0, 5.0, 8.5, 14.5],
      adUsageGrowth: [5, 10, 15, 22],
      productGrowth: [10, 25, 40, 58],
      roi: 340.0,
      subscriptionSavings: 1200.0,
      recommendedPlanId: 'professional',
    );
  }

  @override
  Future<void> toggleAutoRenew(bool autoRenew) async {
    _subscription = _subscription.copyWith(autoRenew: autoRenew);
  }

  @override
  Future<void> renewSubscription() async {
    final nextExp = DateTime.now().add(const Duration(days: 30));
    _subscription = _subscription.copyWith(
      status: SubscriptionStatus.active,
      expiryDate: nextExp,
      nextRenewal: nextExp,
      remainingDays: 30,
    );
  }

  @override
  Future<void> upgradePlan(String planId, BillingCycle cycle) async {
    final targetPlan = _plans.firstWhere((p) => p.id == planId, orElse: () => _plans[2]);
    _subscription = SupplierSubscription(
      planId: targetPlan.id,
      tier: targetPlan.tier,
      planName: targetPlan.name,
      status: SubscriptionStatus.active,
      billingCycle: cycle,
      startDate: DateTime.now(),
      expiryDate: DateTime.now().add(const Duration(days: 30)),
      nextRenewal: DateTime.now().add(const Duration(days: 30)),
      remainingDays: 30,
      autoRenew: true,
      price: targetPlan.price,
      paymentMethod: _subscription.paymentMethod,
      limits: targetPlan.limits,
    );

    _history.insert(
      0,
      SubscriptionHistoryItem(
        id: 'HST-${DateTime.now().millisecondsSinceEpoch}',
        planName: targetPlan.name,
        price: targetPlan.price,
        billingCycle: cycle == BillingCycle.monthly ? 'شهري' : 'سنوي',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 30)),
        status: 'نشط',
        paymentStatus: 'مدفوع',
        invoiceNumber: 'INV-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      ),
    );
  }

  @override
  Future<void> downgradePlan(String planId, BillingCycle cycle) async {
    await upgradePlan(planId, cycle);
  }

  @override
  Future<void> applyCoupon(String code) async {
    if (code.trim().toUpperCase() == 'NASEEJI10') {
      final current = _billing.currentBill;
      _billing = _billing.copyWith(
        discount: current * 0.10,
        couponCode: code,
      );
    }
  }

  @override
  Future<void> addPaymentMethod(PaymentMethodItem method) async {
    _paymentMethods.add(method);
  }

  @override
  Future<void> deletePaymentMethod(String id) async {
    _paymentMethods.removeWhere((m) => m.id == id);
  }

  @override
  Future<void> purchaseAddon(String addonId) async {
    final addon = _addons.firstWhere((a) => a.id == addonId);
    if (addon.type == AddonType.products) {
      // Add extra capacity to current limits
      _subscription = _subscription.copyWith(
        limits: _subscription.limits.copyWith(
          maxProducts: _subscription.limits.maxProducts == -1
              ? -1
              : _subscription.limits.maxProducts + addon.quantity,
        ),
      );
    }
  }

  // --- Utility methods for simulation/testing in controllers ---
  void incrementProductsUsed() {
    _usage = _usage.copyWith(productsUsed: _usage.productsUsed + 1);
  }

  void incrementAdsUsed() {
    _usage = _usage.copyWith(advertisementsUsed: _usage.advertisementsUsed + 1);
  }

  void incrementFeaturedProductsUsed() {
    _usage = _usage.copyWith(featuredProductsUsed: _usage.featuredProductsUsed + 1);
  }

  void incrementRfqsUsed() {
    _usage = _usage.copyWith(rfqsUsed: _usage.rfqsUsed + 1);
  }

  void setUsage({
    int? products,
    int? ads,
    int? videos,
    int? pdfs,
    int? rfqs,
    int? featured,
  }) {
    _usage = _usage.copyWith(
      productsUsed: products ?? _usage.productsUsed,
      advertisementsUsed: ads ?? _usage.advertisementsUsed,
      videosUsed: videos ?? _usage.videosUsed,
      pdfsUsed: pdfs ?? _usage.pdfsUsed,
      rfqsUsed: rfqs ?? _usage.rfqsUsed,
      featuredProductsUsed: featured ?? _usage.featuredProductsUsed,
    );
  }
}
