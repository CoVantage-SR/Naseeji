enum AdStatus {
  active,
  scheduled,
  pendingReview,
  paused,
  completed,
  rejected,
}

enum CampaignStatus {
  active,
  scheduled,
  completed,
  paused,
}

enum OfferType {
  percentageDiscount,
  fixedDiscount,
  buyMoreSaveMore,
  freeShipping,
  vipPricing,
  bundleOffers,
  seasonalOffers,
  firstOrderDiscount,
  minimumQuantityDiscount,
}

class MarketingDashboardData {
  final double campaignBudget;
  final double spent;
  final int reach;
  final int impressions;
  final int clicks;
  final double ctr;
  final int conversions;
  final int ordersGenerated;
  final double revenueGenerated;
  final double roas;
  final int activeAdsCount;
  final int pendingReviewCount;
  final int scheduledCampaignsCount;
  final int runningCampaignsCount;

  const MarketingDashboardData({
    required this.campaignBudget,
    required this.spent,
    required this.reach,
    required this.impressions,
    required this.clicks,
    required this.ctr,
    required this.conversions,
    required this.ordersGenerated,
    required this.revenueGenerated,
    required this.roas,
    required this.activeAdsCount,
    required this.pendingReviewCount,
    required this.scheduledCampaignsCount,
    required this.runningCampaignsCount,
  });
}

class B2BAdvertisement {
  final String id;
  final String title;
  final String productName;
  final String campaignName;
  final double budget;
  final double spent;
  final int reach;
  final int clicks;
  final double ctr;
  final int orders;
  final double revenue;
  final AdStatus status;
  final double remainingBudget;
  final String description;
  final String callToAction;
  final DateTime startDate;
  final DateTime endDate;
  final B2BAudienceTarget targeting;

  const B2BAdvertisement({
    required this.id,
    required this.title,
    required this.productName,
    required this.campaignName,
    required this.budget,
    required this.spent,
    required this.reach,
    required this.clicks,
    required this.ctr,
    required this.orders,
    required this.revenue,
    required this.status,
    required this.remainingBudget,
    required this.description,
    required this.callToAction,
    required this.startDate,
    required this.endDate,
    required this.targeting,
  });

  B2BAdvertisement copyWith({
    String? id,
    String? title,
    String? productName,
    String? campaignName,
    double? budget,
    double? spent,
    int? reach,
    int? clicks,
    double? ctr,
    int? orders,
    double? revenue,
    AdStatus? status,
    double? remainingBudget,
    String? description,
    String? callToAction,
    DateTime? startDate,
    DateTime? endDate,
    B2BAudienceTarget? targeting,
  }) {
    return B2BAdvertisement(
      id: id ?? this.id,
      title: title ?? this.title,
      productName: productName ?? this.productName,
      campaignName: campaignName ?? this.campaignName,
      budget: budget ?? this.budget,
      spent: spent ?? this.spent,
      reach: reach ?? this.reach,
      clicks: clicks ?? this.clicks,
      ctr: ctr ?? this.ctr,
      orders: orders ?? this.orders,
      revenue: revenue ?? this.revenue,
      status: status ?? this.status,
      remainingBudget: remainingBudget ?? this.remainingBudget,
      description: description ?? this.description,
      callToAction: callToAction ?? this.callToAction,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      targeting: targeting ?? this.targeting,
    );
  }
}

class B2BAudienceTarget {
  final List<String> factoryIndustries;
  final List<String> factorySizes;
  final List<String> locations;
  final List<String> purchasingBehaviors;
  final List<String> purchaseVolumes;
  final List<String> interestedCategories;
  final bool verifiedOnly;
  final bool premiumOnly;
  final bool vipOnly;
  final bool activeLast30Days;
  final bool completedPaymentsOnly;
  final bool highFrequencyOnly;
  final bool searchingSimilarProducts;

  const B2BAudienceTarget({
    required this.factoryIndustries,
    required this.factorySizes,
    required this.locations,
    required this.purchasingBehaviors,
    required this.purchaseVolumes,
    required this.interestedCategories,
    required this.verifiedOnly,
    required this.premiumOnly,
    required this.vipOnly,
    required this.activeLast30Days,
    required this.completedPaymentsOnly,
    required this.highFrequencyOnly,
    required this.searchingSimilarProducts,
  });

  factory B2BAudienceTarget.empty() {
    return const B2BAudienceTarget(
      factoryIndustries: [],
      factorySizes: [],
      locations: [],
      purchasingBehaviors: [],
      purchaseVolumes: [],
      interestedCategories: [],
      verifiedOnly: false,
      premiumOnly: false,
      vipOnly: false,
      activeLast30Days: false,
      completedPaymentsOnly: false,
      highFrequencyOnly: false,
      searchingSimilarProducts: false,
    );
  }

  B2BAudienceTarget copyWith({
    List<String>? factoryIndustries,
    List<String>? factorySizes,
    List<String>? locations,
    List<String>? purchasingBehaviors,
    List<String>? purchaseVolumes,
    List<String>? interestedCategories,
    bool? verifiedOnly,
    bool? premiumOnly,
    bool? vipOnly,
    bool? activeLast30Days,
    bool? completedPaymentsOnly,
    bool? highFrequencyOnly,
    bool? searchingSimilarProducts,
  }) {
    return B2BAudienceTarget(
      factoryIndustries: factoryIndustries ?? this.factoryIndustries,
      factorySizes: factorySizes ?? this.factorySizes,
      locations: locations ?? this.locations,
      purchasingBehaviors: purchasingBehaviors ?? this.purchasingBehaviors,
      purchaseVolumes: purchaseVolumes ?? this.purchaseVolumes,
      interestedCategories: interestedCategories ?? this.interestedCategories,
      verifiedOnly: verifiedOnly ?? this.verifiedOnly,
      premiumOnly: premiumOnly ?? this.premiumOnly,
      vipOnly: vipOnly ?? this.vipOnly,
      activeLast30Days: activeLast30Days ?? this.activeLast30Days,
      completedPaymentsOnly: completedPaymentsOnly ?? this.completedPaymentsOnly,
      highFrequencyOnly: highFrequencyOnly ?? this.highFrequencyOnly,
      searchingSimilarProducts: searchingSimilarProducts ?? this.searchingSimilarProducts,
    );
  }
}

class MarketingCampaign {
  final String id;
  final String name;
  final String objective;
  final double budget;
  final double spent;
  final int productsCount;
  final CampaignStatus status;
  final int durationDays;
  final double roas;
  final double revenue;
  final int orders;
  final int reach;
  final int clicks;
  final double ctr;

  const MarketingCampaign({
    required this.id,
    required this.name,
    required this.objective,
    required this.budget,
    required this.spent,
    required this.productsCount,
    required this.status,
    required this.durationDays,
    required this.roas,
    required this.revenue,
    required this.orders,
    required this.reach,
    required this.clicks,
    required this.ctr,
  });

  MarketingCampaign copyWith({
    String? id,
    String? name,
    String? objective,
    double? budget,
    double? spent,
    int? productsCount,
    CampaignStatus? status,
    int? durationDays,
    double? roas,
    double? revenue,
    int? orders,
    int? reach,
    int? clicks,
    double? ctr,
  }) {
    return MarketingCampaign(
      id: id ?? this.id,
      name: name ?? this.name,
      objective: objective ?? this.objective,
      budget: budget ?? this.budget,
      spent: spent ?? this.spent,
      productsCount: productsCount ?? this.productsCount,
      status: status ?? this.status,
      durationDays: durationDays ?? this.durationDays,
      roas: roas ?? this.roas,
      revenue: revenue ?? this.revenue,
      orders: orders ?? this.orders,
      reach: reach ?? this.reach,
      clicks: clicks ?? this.clicks,
      ctr: ctr ?? this.ctr,
    );
  }
}

class FeaturedProductPromotion {
  final String id;
  final String productName;
  final int featuredDurationDays;
  final String priorityLevel; // 'High', 'Medium', 'Low'
  final double promotionCost;
  final int views;
  final int clicks;
  final int orders;
  final double revenue;
  final bool active;

  const FeaturedProductPromotion({
    required this.id,
    required this.productName,
    required this.featuredDurationDays,
    required this.priorityLevel,
    required this.promotionCost,
    required this.views,
    required this.clicks,
    required this.orders,
    required this.revenue,
    required this.active,
  });
}

class PromotionalOffer {
  final String id;
  final String title;
  final OfferType type;
  final double discountValue;
  final int minQuantity;
  final bool active;
  final int reach;
  final int conversions;
  final String description;

  const PromotionalOffer({
    required this.id,
    required this.title,
    required this.type,
    required this.discountValue,
    required this.minQuantity,
    required this.active,
    required this.reach,
    required this.conversions,
    required this.description,
  });
}

class B2BDiscountCoupon {
  final String id;
  final String code;
  final String discountType; // 'percentage', 'fixed'
  final double discountValue;
  final double maxDiscount;
  final int usageLimit;
  final int usageCount;
  final int perCustomerLimit;
  final DateTime expirationDate;
  final List<String> eligibleProducts;
  final bool active;

  const B2BDiscountCoupon({
    required this.id,
    required this.code,
    required this.discountType,
    required this.discountValue,
    required this.maxDiscount,
    required this.usageLimit,
    required this.usageCount,
    required this.perCustomerLimit,
    required this.expirationDate,
    required this.eligibleProducts,
    required this.active,
  });

  B2BDiscountCoupon copyWith({
    String? id,
    String? code,
    String? discountType,
    double? discountValue,
    double? maxDiscount,
    int? usageLimit,
    int? usageCount,
    int? perCustomerLimit,
    DateTime? expirationDate,
    List<String>? eligibleProducts,
    bool? active,
  }) {
    return B2BDiscountCoupon(
      id: id ?? this.id,
      code: code ?? this.code,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      maxDiscount: maxDiscount ?? this.maxDiscount,
      usageLimit: usageLimit ?? this.usageLimit,
      usageCount: usageCount ?? this.usageCount,
      perCustomerLimit: perCustomerLimit ?? this.perCustomerLimit,
      expirationDate: expirationDate ?? this.expirationDate,
      eligibleProducts: eligibleProducts ?? this.eligibleProducts,
      active: active ?? this.active,
    );
  }
}

class SponsoredProduct {
  final String id;
  final String productName;
  final double budget;
  final double spent;
  final int views;
  final int clicks;
  final int orders;
  final double revenue;
  final bool active;

  const SponsoredProduct({
    required this.id,
    required this.productName,
    required this.budget,
    required this.spent,
    required this.views,
    required this.clicks,
    required this.orders,
    required this.revenue,
    required this.active,
  });

  SponsoredProduct copyWith({
    String? id,
    String? productName,
    double? budget,
    double? spent,
    int? views,
    int? clicks,
    int? orders,
    double? revenue,
    bool? active,
  }) {
    return SponsoredProduct(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      budget: budget ?? this.budget,
      spent: spent ?? this.spent,
      views: views ?? this.views,
      clicks: clicks ?? this.clicks,
      orders: orders ?? this.orders,
      revenue: revenue ?? this.revenue,
      active: active ?? this.active,
    );
  }
}

class BudgetManagementData {
  final double dailyBudget;
  final double campaignBudget;
  final double monthlyBudget;
  final double spent;
  final double remaining;
  final List<String> budgetAlerts;
  final int estimatedReach;
  final int estimatedOrders;

  const BudgetManagementData({
    required this.dailyBudget,
    required this.campaignBudget,
    required this.monthlyBudget,
    required this.spent,
    required this.remaining,
    required this.budgetAlerts,
    required this.estimatedReach,
    required this.estimatedOrders,
  });
}

class MarketingAnalyticsData {
  final List<double> monthlyReach;
  final List<double> monthlyImpressions;
  final List<double> monthlyClicks;
  final List<double> monthlyCtr;
  final List<double> monthlyConversionRate;
  final List<double> monthlyOrders;
  final List<double> monthlyRevenue;
  final List<double> monthlyRoas;
  final List<Map<String, dynamic>> bestCampaigns;
  final List<Map<String, dynamic>> bestProducts;
  final List<Map<String, dynamic>> bestCustomers;

  const MarketingAnalyticsData({
    required this.monthlyReach,
    required this.monthlyImpressions,
    required this.monthlyClicks,
    required this.monthlyCtr,
    required this.monthlyConversionRate,
    required this.monthlyOrders,
    required this.monthlyRevenue,
    required this.monthlyRoas,
    required this.bestCampaigns,
    required this.bestProducts,
    required this.bestCustomers,
  });
}

class MarketingNotification {
  final String id;
  final String title;
  final String body;
  final String audienceOption;
  final String notificationType;
  final DateTime sentTime;
  final int sentCount;
  final int clicks;
  final int conversions;

  const MarketingNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.audienceOption,
    required this.notificationType,
    required this.sentTime,
    required this.sentCount,
    required this.clicks,
    required this.conversions,
  });
}

class MarketingInsight {
  final String id;
  final String title;
  final String description;
  final String type; // 'success', 'warning', 'tip'
  final String recommendation;

  const MarketingInsight({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.recommendation,
  });
}

class SmartB2BRecommendation {
  final List<String> bestProductsToPromote;
  final String bestTimeLaunch;
  final double recommendedBudget;
  final int expectedReach;
  final int expectedOrders;
  final double expectedRevenue;
  final List<String> recommendedSegments;

  const SmartB2BRecommendation({
    required this.bestProductsToPromote,
    required this.bestTimeLaunch,
    required this.recommendedBudget,
    required this.expectedReach,
    required this.expectedOrders,
    required this.expectedRevenue,
    required this.recommendedSegments,
  });
}
