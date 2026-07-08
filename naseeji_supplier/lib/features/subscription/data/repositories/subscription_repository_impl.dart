import '../../domain/entities/subscription_models.dart';
import '../../domain/repositories/subscription_repository.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  // --- Simulated State ---
  SupplierSubscription _subscription = SupplierSubscription(
    planId: 'starter',
    planName: 'المبتدئ (Starter)',
    status: SubscriptionStatus.active,
    billingCycle: BillingCycle.monthly,
    startDate: DateTime.now().subtract(const Duration(days: 12)),
    expiryDate: DateTime.now().add(const Duration(days: 18)),
    nextRenewal: DateTime.now().add(const Duration(days: 18)),
    remainingDays: 18,
    autoRenew: true,
    price: 199.0,
    paymentMethod: 'مدى بطاقة **** 4820',
  );

  final SubscriptionUsage _usage = const SubscriptionUsage(
    productsUsed: 18,
    advertisementsUsed: 2,
    featuredProductsUsed: 1,
    storageUsedGb: 1.8,
    employeesUsed: 3,
    branchesUsed: 1,
    campaignsUsed: 2,
    couponsUsed: 5,
    notificationsUsed: 250,
    aiReportsUsed: 4,
  );

  // Dynamic limits starts with Starter defaults (which will be modified by upgrades or add-ons)
  ResourceLimits _customLimits = const ResourceLimits(
    maxProducts: 50,
    maxAdvertisements: 5,
    maxFeaturedProducts: 3,
    maxStorageGb: 5.0,
    maxEmployees: 5,
    maxBranches: 2,
    maxCampaigns: 10,
    maxCoupons: 20,
    maxNotifications: 1000,
    maxAiReports: 20,
    hasAiInsights: false,
    hasPrioritySupport: false,
    hasApiAccess: false,
    hasBulkUpload: false,
  );

  BillingData _billing = BillingData(
    currentBill: 199.0,
    nextInvoiceDate: DateTime.now().add(const Duration(days: 18)),
    outstandingBalance: 0.0,
    paidAmount: 199.0,
    tax: 29.85, // 15% VAT
    discount: 0.0,
  );

  final List<PaymentMethodItem> _paymentMethods = [
    const PaymentMethodItem(
      id: 'PM-1',
      type: PaymentMethodType.creditCard,
      name: 'بطاقة مدى بنك الراجحي',
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
    const PaymentMethodItem(
      id: 'PM-3',
      type: PaymentMethodType.bankTransfer,
      name: 'الحساب الجاري لبنك الأهلي SNB',
      details: 'SA84 3000 0000 1092 8493 0294',
      isDefault: false,
      isVerified: false,
    ),
  ];

  final List<SubscriptionHistoryItem> _history = [
    SubscriptionHistoryItem(
      id: 'HST-1',
      planName: 'المبتدئ (Starter)',
      price: 199.0,
      billingCycle: 'شهري',
      startDate: DateTime.now().subtract(const Duration(days: 12)),
      endDate: DateTime.now().add(const Duration(days: 18)),
      status: 'نشط',
      paymentStatus: 'مدفوع',
      invoiceNumber: 'INV-2026-089',
    ),
    SubscriptionHistoryItem(
      id: 'HST-2',
      planName: 'المجاني (Free)',
      price: 0.0,
      billingCycle: 'شهري',
      startDate: DateTime.now().subtract(const Duration(days: 42)),
      endDate: DateTime.now().subtract(const Duration(days: 12)),
      status: 'منتهي',
      paymentStatus: 'مجاني',
      invoiceNumber: 'INV-2026-041',
    ),
  ];

  final List<SubscriptionInvoice> _invoices = [
    SubscriptionInvoice(
      invoiceNumber: 'INV-2026-089',
      planName: 'باقة المبتدئ (Starter) - شهري',
      amount: 199.0,
      vat: 29.85,
      discount: 0.0,
      status: 'مدفوعة',
      createdDate: DateTime.now().subtract(const Duration(days: 12)),
      paidDate: DateTime.now().subtract(const Duration(days: 12)),
    ),
  ];

  final List<SubscriptionNotification> _notifications = [
    SubscriptionNotification(
      id: 'NOT-1',
      title: 'تفعيل باقة المبتدئ',
      body: 'تم تفعيل باقة المبتدئ (Starter) بنجاح للمؤسسة، تسري حتى تاريخ التجديد القادم.',
      timestamp: DateTime.now().subtract(const Duration(days: 12)),
      type: 'success',
    ),
    SubscriptionNotification(
      id: 'NOT-2',
      title: 'اقتراب نفاذ سعة المنتجات (80%)',
      body: 'لقد استهلكت 18 من أصل 50 منتجاً متاحاً في الباقة الحالية (Starter).',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      type: 'warning',
    ),
  ];

  // Static Plans List
  final List<SubscriptionPlan> _plans = const [
    SubscriptionPlan(
      id: 'free',
      name: 'الباقة المجانية (Free)',
      price: 0.0,
      billingCycle: BillingCycle.monthly,
      isRecommended: false,
      features: [
        'إضافة حتى 10 منتجات',
        'ظهور إعلاني عادي',
        'مساحة تخزين 1 جيجابايت',
        'مستخدم واحد (المالك)',
        '1 فرع فقط',
        '1 حملة تسويقية شهرياً',
        'دعم فني عادي عبر التذاكر',
      ],
      limits: ResourceLimits(
        maxProducts: 10,
        maxAdvertisements: 1,
        maxFeaturedProducts: 0,
        maxStorageGb: 1.0,
        maxEmployees: 1,
        maxBranches: 1,
        maxCampaigns: 1,
        maxCoupons: 2,
        maxNotifications: 50,
        maxAiReports: 0,
        hasAiInsights: false,
        hasPrioritySupport: false,
        hasApiAccess: false,
        hasBulkUpload: false,
      ),
    ),
    SubscriptionPlan(
      id: 'starter',
      name: 'باقة المبتدئ (Starter)',
      price: 199.0,
      billingCycle: BillingCycle.monthly,
      isRecommended: false,
      features: [
        'إضافة حتى 50 منتجاً',
        '5 إعلانات ممولة جارية',
        '3 منتجات مميزة بالرعاية',
        'مساحة تخزين 5 جيجابايت',
        'حتى 5 موظفين إضافيين',
        'فرعين للمؤسسة',
        '10 حملات تسويقية شهرياً',
        '20 كوبون خصم نشط',
        '1,000 إشعار للمصانع',
        '20 تقرير تحليل أداء شهري',
        'دعم فني سريع',
      ],
      limits: ResourceLimits(
        maxProducts: 50,
        maxAdvertisements: 5,
        maxFeaturedProducts: 3,
        maxStorageGb: 5.0,
        maxEmployees: 5,
        maxBranches: 2,
        maxCampaigns: 10,
        maxCoupons: 20,
        maxNotifications: 1000,
        maxAiReports: 20,
        hasAiInsights: false,
        hasPrioritySupport: false,
        hasApiAccess: false,
        hasBulkUpload: false,
      ),
    ),
    SubscriptionPlan(
      id: 'professional',
      name: 'الباقة الاحترافية (Professional)',
      price: 499.0,
      billingCycle: BillingCycle.monthly,
      isRecommended: true,
      features: [
        'إضافة حتى 200 منتج',
        '20 إعلان ممول جاري',
        '10 منتجات مميزة بالرعاية',
        'مساحة تخزين 20 جيجابايت',
        'حتى 20 موظفاً وصلاحيات كاملة',
        '5 فروع للمؤسسة',
        '30 حملة تسويقية نشطة',
        '50 كوبون خصم نشط',
        '5,000 إشعار بث للمصانع',
        'تقارير ذكاء اصطناعي وتحليل متقدم',
        'توصيات استهداف المصانع الذكية',
        'دعم فني ذو أولوية 24/7',
        'استيراد المنتجات بالجملة (Bulk)',
      ],
      limits: ResourceLimits(
        maxProducts: 200,
        maxAdvertisements: 20,
        maxFeaturedProducts: 10,
        maxStorageGb: 20.0,
        maxEmployees: 20,
        maxBranches: 5,
        maxCampaigns: 30,
        maxCoupons: 50,
        maxNotifications: 5000,
        maxAiReports: 50,
        hasAiInsights: true,
        hasPrioritySupport: true,
        hasApiAccess: false,
        hasBulkUpload: true,
      ),
    ),
    SubscriptionPlan(
      id: 'business',
      name: 'باقة الأعمال (Business)',
      price: 999.0,
      billingCycle: BillingCycle.monthly,
      isRecommended: false,
      features: [
        'إضافة حتى 1000 منتج خامات',
        '100 إعلان ممول نشط جاري',
        '50 منتج مميز بالمنصة',
        'مساحة تخزين 100 جيجابايت',
        'موظفين غير محدودين',
        '15 فرع للمؤسسة والمخازن',
        'حملات تسويقية غير محدودة',
        'كوبونات خصم غير محدودة',
        '20,000 إشعار بث للمصانع شهرياً',
        'تحليلات الذكاء والنمو متكاملة',
        'دعم فني مخصص (مدير حساب)',
        'استيراد بالجملة وربط الـ API للمصانع',
        'علامة تجارية مخصصة',
      ],
      limits: ResourceLimits(
        maxProducts: 1000,
        maxAdvertisements: 100,
        maxFeaturedProducts: 50,
        maxStorageGb: 100.0,
        maxEmployees: 100, // Large cap
        maxBranches: 15,
        maxCampaigns: 100,
        maxCoupons: 100,
        maxNotifications: 20000,
        maxAiReports: 200,
        hasAiInsights: true,
        hasPrioritySupport: true,
        hasApiAccess: true,
        hasBulkUpload: true,
      ),
    ),
  ];

  final List<AddonItem> _addons = const [
    AddonItem(
      id: 'ADD-PROD-50',
      name: 'باقة زيادة المنتجات (+50)',
      price: 49.0,
      description: 'أضف 50 منتجاً إضافياً لكتالوج الخامات والمواد الخاص بك دون ترقية خطتك الأساسية.',
      validity: 'ساري طوال فترة الاشتراك الحالي',
      usage: '+50 منتج',
      type: AddonType.products,
      quantity: 50,
    ),
    AddonItem(
      id: 'ADD-STOR-5G',
      name: 'باقة زيادة التخزين (+5 جيجابايت)',
      price: 29.0,
      description: 'ارفع مساحة الملفات والتصاميم وصور المنتجات لكتالوج التوريد بـ 5 جيجابايت إضافية.',
      validity: 'ساري طوال فترة الاشتراك الحالي',
      usage: '+5 جيجابايت مساحة',
      type: AddonType.storage,
      quantity: 5,
    ),
    AddonItem(
      id: 'ADD-ADS-5',
      name: 'باقة زيادة الإعلانات الممولة (+5)',
      price: 99.0,
      description: 'تسمح بإنشاء 5 إعلانات ممولة جارية إضافية لضمان تفاعل المصانع مع عروضك.',
      validity: '30 يوماً من تاريخ التفعيل',
      usage: '+5 إعلانات جارية',
      type: AddonType.ads,
      quantity: 5,
    ),
    AddonItem(
      id: 'ADD-AI-PACK',
      name: 'حزمة تقارير الذكاء الاصطناعي الذكي',
      price: 149.0,
      description: 'تفعيل كامل للتوصيات التلقائية وعينات تحليل سلوك مصانع المنسوجات والأزياء.',
      validity: '30 يوماً من تاريخ التفعيل',
      usage: 'تفعيل لوحة التوصيات الذكية',
      type: AddonType.aiAnalytics,
      quantity: 1,
    ),
  ];

  // --- Methods Implementation ---

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
  Future<void> addPaymentMethod(PaymentMethodItem method) async {
    _paymentMethods.add(method);
  }

  @override
  Future<void> deletePaymentMethod(String id) async {
    _paymentMethods.removeWhere((item) => item.id == id);
  }

  @override
  Future<void> setDefaultPaymentMethod(String id) async {
    for (int i = 0; i < _paymentMethods.length; i++) {
      final item = _paymentMethods[i];
      _paymentMethods[i] = item.copyWith(isDefault: item.id == id);
    }
  }

  @override
  Future<List<SubscriptionHistoryItem>> getSubscriptionHistory() async {
    return _history;
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
  Future<void> purchaseAddon(String addonId) async {
    final addon = _addons.firstWhere((item) => item.id == addonId);
    
    // Add to usage bounds
    if (addon.type == AddonType.products) {
      _customLimits = _customLimits.copyWith(maxProducts: _customLimits.maxProducts + addon.quantity);
    } else if (addon.type == AddonType.storage) {
      _customLimits = _customLimits.copyWith(maxStorageGb: _customLimits.maxStorageGb + addon.quantity);
    } else if (addon.type == AddonType.ads) {
      _customLimits = _customLimits.copyWith(maxAdvertisements: _customLimits.maxAdvertisements + addon.quantity);
    } else if (addon.type == AddonType.aiAnalytics) {
      _customLimits = _customLimits.copyWith(hasAiInsights: true);
    }

    // Add invoice
    final invNum = 'INV-ADD-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    _invoices.insert(
      0,
      SubscriptionInvoice(
        invoiceNumber: invNum,
        planName: '${addon.name} (إضافة)',
        amount: addon.price,
        vat: addon.price * 0.15,
        discount: 0.0,
        status: 'مدفوعة',
        createdDate: DateTime.now(),
        paidDate: DateTime.now(),
      ),
    );

    // Add History
    _history.insert(
      0,
      SubscriptionHistoryItem(
        id: 'HST-${DateTime.now().millisecondsSinceEpoch}',
        planName: addon.name,
        price: addon.price,
        billingCycle: 'مرة واحدة',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 30)),
        status: 'نشط',
        paymentStatus: 'مدفوع',
        invoiceNumber: invNum,
      ),
    );

    // Send Alert Notification
    _notifications.insert(
      0,
      SubscriptionNotification(
        id: 'NOT-${DateTime.now().millisecondsSinceEpoch}',
        title: 'تفعيل الميزة الإضافية',
        body: 'تم شراء وتفعيل ${addon.name} بنجاح وإضافة المزايا لحسابك.',
        timestamp: DateTime.now(),
        type: 'success',
      ),
    );
  }

  @override
  Future<void> purchasePayAsYouGo(String serviceName, double cost) async {
    final invNum = 'INV-PAYG-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    
    // Add invoice
    _invoices.insert(
      0,
      SubscriptionInvoice(
        invoiceNumber: invNum,
        planName: '$serviceName (دفع حسب الاستخدام)',
        amount: cost,
        vat: cost * 0.15,
        discount: 0.0,
        status: 'مدفوعة',
        createdDate: DateTime.now(),
        paidDate: DateTime.now(),
      ),
    );

    // Add Notification
    _notifications.insert(
      0,
      SubscriptionNotification(
        id: 'NOT-${DateTime.now().millisecondsSinceEpoch}',
        title: 'تفعيل خدمة فردية',
        body: 'تم شراء وتفعيل خدمة $serviceName بنجاح بمبلغ $cost ر.س.',
        timestamp: DateTime.now(),
        type: 'success',
      ),
    );
  }

  @override
  Future<void> upgradePlan(String planId, BillingCycle cycle) async {
    final targetPlan = _plans.firstWhere((p) => p.id == planId);

    _subscription = SupplierSubscription(
      planId: targetPlan.id,
      planName: targetPlan.name,
      status: SubscriptionStatus.active,
      billingCycle: cycle,
      startDate: DateTime.now(),
      expiryDate: DateTime.now().add(cycle == BillingCycle.yearly ? const Duration(days: 365) : const Duration(days: 30)),
      nextRenewal: DateTime.now().add(cycle == BillingCycle.yearly ? const Duration(days: 365) : const Duration(days: 30)),
      remainingDays: cycle == BillingCycle.yearly ? 365 : 30,
      autoRenew: true,
      price: targetPlan.price,
      paymentMethod: 'مدى بطاقة **** 4820',
    );

    _customLimits = targetPlan.limits;

    // Reset billing details
    _billing = BillingData(
      currentBill: targetPlan.price,
      nextInvoiceDate: _subscription.nextRenewal,
      outstandingBalance: 0.0,
      paidAmount: targetPlan.price,
      tax: targetPlan.price * 0.15,
      discount: 0.0,
    );

    // Add invoice
    final invNum = 'INV-UPG-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    _invoices.insert(
      0,
      SubscriptionInvoice(
        invoiceNumber: invNum,
        planName: 'ترقية إلى ${targetPlan.name}',
        amount: targetPlan.price,
        vat: targetPlan.price * 0.15,
        discount: 0.0,
        status: 'مدفوعة',
        createdDate: DateTime.now(),
        paidDate: DateTime.now(),
      ),
    );

    // Add History
    _history.insert(
      0,
      SubscriptionHistoryItem(
        id: 'HST-${DateTime.now().millisecondsSinceEpoch}',
        planName: targetPlan.name,
        price: targetPlan.price,
        billingCycle: cycle == BillingCycle.yearly ? 'سنوي' : 'شهري',
        startDate: DateTime.now(),
        endDate: _subscription.expiryDate,
        status: 'نشط',
        paymentStatus: 'مدفوع',
        invoiceNumber: invNum,
      ),
    );

    // Add Notification
    _notifications.insert(
      0,
      SubscriptionNotification(
        id: 'NOT-${DateTime.now().millisecondsSinceEpoch}',
        title: 'ترقية الاشتراك بنجاح',
        body: 'تمت ترقية باقة حسابك إلى ${targetPlan.name} بنجاح.',
        timestamp: DateTime.now(),
        type: 'success',
      ),
    );
  }

  @override
  Future<void> downgradePlan(String planId, BillingCycle cycle) async {
    final targetPlan = _plans.firstWhere((p) => p.id == planId);

    _subscription = _subscription.copyWith(
      planId: targetPlan.id,
      planName: targetPlan.name,
      price: targetPlan.price,
    );

    _customLimits = targetPlan.limits;

    // Add Notification
    _notifications.insert(
      0,
      SubscriptionNotification(
        id: 'NOT-${DateTime.now().millisecondsSinceEpoch}',
        title: 'تنزيل الاشتراك',
        body: 'تم جدولة تخفيض الباقة لتبدأ من الدورة القادمة لحسابك.',
        timestamp: DateTime.now(),
        type: 'info',
      ),
    );
  }

  @override
  Future<void> renewSubscription() async {
    _subscription = _subscription.copyWith(
      startDate: DateTime.now(),
      expiryDate: DateTime.now().add(const Duration(days: 30)),
      nextRenewal: DateTime.now().add(const Duration(days: 30)),
      remainingDays: 30,
    );

    // Add invoice
    final invNum = 'INV-RNW-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    _invoices.insert(
      0,
      SubscriptionInvoice(
        invoiceNumber: invNum,
        planName: 'تجديد ${_subscription.planName}',
        amount: _subscription.price,
        vat: _subscription.price * 0.15,
        discount: 0.0,
        status: 'مدفوعة',
        createdDate: DateTime.now(),
        paidDate: DateTime.now(),
      ),
    );

    // Add Notification
    _notifications.insert(
      0,
      SubscriptionNotification(
        id: 'NOT-${DateTime.now().millisecondsSinceEpoch}',
        title: 'تجديد الاشتراك تلقائياً',
        body: 'تم سداد رسوم اشتراك باقة ${_subscription.planName} بنجاح.',
        timestamp: DateTime.now(),
        type: 'success',
      ),
    );
  }

  @override
  Future<void> toggleAutoRenew(bool autoRenew) async {
    _subscription = _subscription.copyWith(autoRenew: autoRenew);
  }

  @override
  Future<void> applyCoupon(String couponCode) async {
    if (couponCode.toUpperCase() == 'NASEEJI20') {
      _billing = _billing.copyWith(
        discount: _billing.currentBill * 0.20, // 20% discount
        couponCode: couponCode,
      );
    }
  }

  @override
  Future<List<SubscriptionNotification>> getNotifications() async {
    return _notifications;
  }

  @override
  Future<SubscriptionAnalyticsData> getAnalytics() async {
    return const SubscriptionAnalyticsData(
      monthlySpending: [199.0, 199.0, 199.0, 199.0, 199.0],
      subscriptionCost: 199.0,
      addonSpending: 49.0,
      featureUsagePercent: {
        'المنتجات': 0.36,
        'الإعلانات': 0.40,
        'الزيارات': 0.85,
        'المساحة': 0.36,
        'الموظفين': 0.60,
      },
      storageGrowthGb: [1.0, 1.2, 1.5, 1.7, 1.8],
      adUsageGrowth: [1, 1, 2, 2, 2],
      productGrowth: [10, 12, 15, 17, 18],
      roi: 3.5,
      subscriptionSavings: 420.0,
      recommendedPlanId: 'professional',
    );
  }
}
