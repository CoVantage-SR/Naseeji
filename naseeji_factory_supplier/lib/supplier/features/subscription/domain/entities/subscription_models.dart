enum SubscriptionStatus {
  active,
  expiring,
  expired,
  cancelled,
  pending,
}

enum BillingCycle {
  monthly,
  yearly,
}

enum PaymentMethodType {
  creditCard,
  debitCard,
  bankTransfer,
  instaPay,
  digitalWallet,
  companyAccount,
}

enum AddonType {
  products,
  ads,
  featuredProducts,
  storage,
  employees,
  notifications,
  aiAnalytics,
  reports,
  support,
  bulkImport,
}

enum PlanTier {
  free,
  basic,
  professional,
  enterprise,
}

class ResourceLimits {
  final int maxProducts;
  final int maxImagesPerProduct;
  final int maxVideosPerProduct;
  final int maxPdfsPerProduct;
  final int maxAdvertisements;
  final int maxMonthlyRfqs;
  final int maxFeaturedProducts;
  final double maxStorageGb;
  final int maxEmployees;
  final int maxBranches;
  final int maxCampaigns;
  final int maxCoupons;
  final int maxNotifications;
  final int maxAiReports;
  final bool hasAiInsights;
  final bool hasPrioritySupport;
  final bool hasApiAccess;
  final bool hasBulkUpload;

  const ResourceLimits({
    required this.maxProducts,
    required this.maxImagesPerProduct,
    required this.maxVideosPerProduct,
    required this.maxPdfsPerProduct,
    required this.maxAdvertisements,
    required this.maxMonthlyRfqs,
    required this.maxFeaturedProducts,
    this.maxStorageGb = 5.0,
    this.maxEmployees = 2,
    this.maxBranches = 1,
    this.maxCampaigns = 2,
    this.maxCoupons = 5,
    this.maxNotifications = 100,
    this.maxAiReports = 5,
    this.hasAiInsights = false,
    this.hasPrioritySupport = false,
    this.hasApiAccess = false,
    this.hasBulkUpload = false,
  });

  ResourceLimits copyWith({
    int? maxProducts,
    int? maxImagesPerProduct,
    int? maxVideosPerProduct,
    int? maxPdfsPerProduct,
    int? maxAdvertisements,
    int? maxMonthlyRfqs,
    int? maxFeaturedProducts,
    double? maxStorageGb,
    int? maxEmployees,
    int? maxBranches,
    int? maxCampaigns,
    int? maxCoupons,
    int? maxNotifications,
    int? maxAiReports,
    bool? hasAiInsights,
    bool? hasPrioritySupport,
    bool? hasApiAccess,
    bool? hasBulkUpload,
  }) {
    return ResourceLimits(
      maxProducts: maxProducts ?? this.maxProducts,
      maxImagesPerProduct: maxImagesPerProduct ?? this.maxImagesPerProduct,
      maxVideosPerProduct: maxVideosPerProduct ?? this.maxVideosPerProduct,
      maxPdfsPerProduct: maxPdfsPerProduct ?? this.maxPdfsPerProduct,
      maxAdvertisements: maxAdvertisements ?? this.maxAdvertisements,
      maxMonthlyRfqs: maxMonthlyRfqs ?? this.maxMonthlyRfqs,
      maxFeaturedProducts: maxFeaturedProducts ?? this.maxFeaturedProducts,
      maxStorageGb: maxStorageGb ?? this.maxStorageGb,
      maxEmployees: maxEmployees ?? this.maxEmployees,
      maxBranches: maxBranches ?? this.maxBranches,
      maxCampaigns: maxCampaigns ?? this.maxCampaigns,
      maxCoupons: maxCoupons ?? this.maxCoupons,
      maxNotifications: maxNotifications ?? this.maxNotifications,
      maxAiReports: maxAiReports ?? this.maxAiReports,
      hasAiInsights: hasAiInsights ?? this.hasAiInsights,
      hasPrioritySupport: hasPrioritySupport ?? this.hasPrioritySupport,
      hasApiAccess: hasApiAccess ?? this.hasApiAccess,
      hasBulkUpload: hasBulkUpload ?? this.hasBulkUpload,
    );
  }
}

class SubscriptionPlan {
  final String id;
  final PlanTier tier;
  final String name;
  final double price;
  final BillingCycle billingCycle;
  final List<String> features;
  final ResourceLimits limits;
  final bool isRecommended;

  const SubscriptionPlan({
    required this.id,
    required this.tier,
    required this.name,
    required this.price,
    required this.billingCycle,
    required this.features,
    required this.limits,
    required this.isRecommended,
  });
}

class SupplierSubscription {
  final String planId;
  final PlanTier tier;
  final String planName;
  final SubscriptionStatus status;
  final BillingCycle billingCycle;
  final DateTime startDate;
  final DateTime expiryDate;
  final DateTime nextRenewal;
  final int remainingDays;
  final bool autoRenew;
  final double price;
  final String paymentMethod;
  final ResourceLimits limits;

  const SupplierSubscription({
    required this.planId,
    required this.tier,
    required this.planName,
    required this.status,
    required this.billingCycle,
    required this.startDate,
    required this.expiryDate,
    required this.nextRenewal,
    required this.remainingDays,
    required this.autoRenew,
    required this.price,
    required this.paymentMethod,
    required this.limits,
  });

  SupplierSubscription copyWith({
    String? planId,
    PlanTier? tier,
    String? planName,
    SubscriptionStatus? status,
    BillingCycle? billingCycle,
    DateTime? startDate,
    DateTime? expiryDate,
    DateTime? nextRenewal,
    int? remainingDays,
    bool? autoRenew,
    double? price,
    String? paymentMethod,
    ResourceLimits? limits,
  }) {
    return SupplierSubscription(
      planId: planId ?? this.planId,
      tier: tier ?? this.tier,
      planName: planName ?? this.planName,
      status: status ?? this.status,
      billingCycle: billingCycle ?? this.billingCycle,
      startDate: startDate ?? this.startDate,
      expiryDate: expiryDate ?? this.expiryDate,
      nextRenewal: nextRenewal ?? this.nextRenewal,
      remainingDays: remainingDays ?? this.remainingDays,
      autoRenew: autoRenew ?? this.autoRenew,
      price: price ?? this.price,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      limits: limits ?? this.limits,
    );
  }

  bool get isExpiringSoon => remainingDays <= 7;
  int get daysRemaining => remainingDays;
}

class SubscriptionUsage {
  final int productsUsed;
  final int advertisementsUsed;
  final int featuredProductsUsed;
  final int rfqsUsed;
  final int videosUsed;
  final int pdfsUsed;
  final double storageUsedGb;
  final int employeesUsed;
  final int branchesUsed;
  final int campaignsUsed;
  final int couponsUsed;
  final int notificationsUsed;
  final int aiReportsUsed;

  const SubscriptionUsage({
    required this.productsUsed,
    required this.advertisementsUsed,
    required this.featuredProductsUsed,
    required this.rfqsUsed,
    required this.videosUsed,
    required this.pdfsUsed,
    required this.storageUsedGb,
    required this.employeesUsed,
    required this.branchesUsed,
    required this.campaignsUsed,
    required this.couponsUsed,
    required this.notificationsUsed,
    required this.aiReportsUsed,
  });

  SubscriptionUsage copyWith({
    int? productsUsed,
    int? advertisementsUsed,
    int? featuredProductsUsed,
    int? rfqsUsed,
    int? videosUsed,
    int? pdfsUsed,
    double? storageUsedGb,
    int? employeesUsed,
    int? branchesUsed,
    int? campaignsUsed,
    int? couponsUsed,
    int? notificationsUsed,
    int? aiReportsUsed,
  }) {
    return SubscriptionUsage(
      productsUsed: productsUsed ?? this.productsUsed,
      advertisementsUsed: advertisementsUsed ?? this.advertisementsUsed,
      featuredProductsUsed: featuredProductsUsed ?? this.featuredProductsUsed,
      rfqsUsed: rfqsUsed ?? this.rfqsUsed,
      videosUsed: videosUsed ?? this.videosUsed,
      pdfsUsed: pdfsUsed ?? this.pdfsUsed,
      storageUsedGb: storageUsedGb ?? this.storageUsedGb,
      employeesUsed: employeesUsed ?? this.employeesUsed,
      branchesUsed: branchesUsed ?? this.branchesUsed,
      campaignsUsed: campaignsUsed ?? this.campaignsUsed,
      couponsUsed: couponsUsed ?? this.couponsUsed,
      notificationsUsed: notificationsUsed ?? this.notificationsUsed,
      aiReportsUsed: aiReportsUsed ?? this.aiReportsUsed,
    );
  }
}

class ValidationResult {
  final bool isAllowed;
  final String? title;
  final String? errorMessage;
  final bool requiresUpgrade;

  const ValidationResult({
    required this.isAllowed,
    this.title,
    this.errorMessage,
    this.requiresUpgrade = false,
  });

  factory ValidationResult.allowed() {
    return const ValidationResult(isAllowed: true);
  }

  factory ValidationResult.denied({
    required String title,
    required String errorMessage,
    bool requiresUpgrade = true,
  }) {
    return ValidationResult(
      isAllowed: false,
      title: title,
      errorMessage: errorMessage,
      requiresUpgrade: requiresUpgrade,
    );
  }
}

class AddonItem {
  final String id;
  final String name;
  final double price;
  final String description;
  final String validity;
  final String usage;
  final AddonType type;
  final int quantity;

  const AddonItem({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.validity,
    required this.usage,
    required this.type,
    required this.quantity,
  });
}

class BillingData {
  final double currentBill;
  final DateTime nextInvoiceDate;
  final double outstandingBalance;
  final double paidAmount;
  final double tax;
  final double discount;
  final String? couponCode;

  const BillingData({
    required this.currentBill,
    required this.nextInvoiceDate,
    required this.outstandingBalance,
    required this.paidAmount,
    required this.tax,
    required this.discount,
    this.couponCode,
  });

  BillingData copyWith({
    double? currentBill,
    DateTime? nextInvoiceDate,
    double? outstandingBalance,
    double? paidAmount,
    double? tax,
    double? discount,
    String? couponCode,
  }) {
    return BillingData(
      currentBill: currentBill ?? this.currentBill,
      nextInvoiceDate: nextInvoiceDate ?? this.nextInvoiceDate,
      outstandingBalance: outstandingBalance ?? this.outstandingBalance,
      paidAmount: paidAmount ?? this.paidAmount,
      tax: tax ?? this.tax,
      discount: discount ?? this.discount,
      couponCode: couponCode ?? this.couponCode,
    );
  }
}

class PaymentMethodItem {
  final String id;
  final PaymentMethodType type;
  final String name;
  final String details;
  final bool isDefault;
  final bool isVerified;

  const PaymentMethodItem({
    required this.id,
    required this.type,
    required this.name,
    required this.details,
    required this.isDefault,
    required this.isVerified,
  });

  PaymentMethodItem copyWith({
    String? id,
    PaymentMethodType? type,
    String? name,
    String? details,
    bool? isDefault,
    bool? isVerified,
  }) {
    return PaymentMethodItem(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      details: details ?? this.details,
      isDefault: isDefault ?? this.isDefault,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}

class SubscriptionHistoryItem {
  final String id;
  final String planName;
  final double price;
  final String billingCycle;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String paymentStatus;
  final String invoiceNumber;

  const SubscriptionHistoryItem({
    required this.id,
    required this.planName,
    required this.price,
    required this.billingCycle,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.paymentStatus,
    required this.invoiceNumber,
  });
}

class SubscriptionInvoice {
  final String invoiceNumber;
  final String planName;
  final double amount;
  final double vat;
  final double discount;
  final String status; // Paid, Pending, Failed
  final DateTime createdDate;
  final DateTime? paidDate;

  const SubscriptionInvoice({
    required this.invoiceNumber,
    required this.planName,
    required this.amount,
    required this.vat,
    required this.discount,
    required this.status,
    required this.createdDate,
    this.paidDate,
  });
}

class SubscriptionAnalyticsData {
  final List<double> monthlySpending;
  final double subscriptionCost;
  final double addonSpending;
  final Map<String, double> featureUsagePercent;
  final List<double> storageGrowthGb;
  final List<double> adUsageGrowth;
  final List<double> productGrowth;
  final double roi;
  final double subscriptionSavings;
  final String recommendedPlanId;

  const SubscriptionAnalyticsData({
    required this.monthlySpending,
    required this.subscriptionCost,
    required this.addonSpending,
    required this.featureUsagePercent,
    required this.storageGrowthGb,
    required this.adUsageGrowth,
    required this.productGrowth,
    required this.roi,
    required this.subscriptionSavings,
    required this.recommendedPlanId,
  });
}

class SubscriptionNotification {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final String type; // Alert, Success, Warning, Info

  const SubscriptionNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.type,
  });
}



