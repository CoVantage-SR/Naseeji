import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/marketing_models.dart';
import '../../domain/repositories/marketing_repository.dart';

part 'marketing_repository_impl.g.dart';

class MarketingRepositoryImpl implements MarketingRepository {
  // Static state to persist changes across provider rebuilds
  static double _dailyBudget = 500.0;
  static double _monthlyBudget = 15000.0;
  static double _totalSpent = 8520.0;
  static double _campaignBudget = 10000.0;

  static final List<B2BAdvertisement> _ads = [
    B2BAdvertisement(
      id: 'AD-101',
      title: 'أقمشة قطن هندي فاخر 100%',
      productName: 'قطن ممتاز طويل التيلة',
      campaignName: 'حملة الأقمشة الصيفية 2026',
      budget: 2000.0,
      spent: 1240.0,
      reach: 12500,
      clicks: 620,
      ctr: 4.96,
      orders: 24,
      revenue: 120000.0,
      status: AdStatus.active,
      remainingBudget: 760.0,
      description: 'أفضل خامات القطن الهندي الطبيعي المجهز لمصانع الملابس الجاهزة واليونيفورم.',
      callToAction: 'طلب عينة مجانية',
      startDate: DateTime.now().subtract(const Duration(days: 10)),
      endDate: DateTime.now().add(const Duration(days: 20)),
      targeting: const B2BAudienceTarget(
        factoryIndustries: ['مصانع الملابس الجاهزة', 'مصانع اليونيفورم'],
        factorySizes: ['متوسط', 'كبير', 'ضخم'],
        locations: ['السعودية', 'الإمارات', 'مصر'],
        purchasingBehaviors: ['شراء متكرر', 'طلب عينات مسبق'],
        purchaseVolumes: ['مشتريات بالجملة'],
        interestedCategories: ['قطنيات', 'أقمشة'],
        verifiedOnly: true,
        premiumOnly: false,
        vipOnly: false,
        activeLast30Days: true,
        completedPaymentsOnly: true,
        highFrequencyOnly: true,
        searchingSimilarProducts: true,
      ),
    ),
    B2BAdvertisement(
      id: 'AD-102',
      title: 'خيوط بوليستر عالية المتانة للمنسوجات الرياضية',
      productName: 'خيوط بوليستر 150/48',
      campaignName: 'حملة الخيوط واللوازم الربعية',
      budget: 1500.0,
      spent: 450.0,
      reach: 5200,
      clicks: 180,
      ctr: 3.46,
      orders: 8,
      revenue: 35000.0,
      status: AdStatus.active,
      remainingBudget: 1050.0,
      description: 'خيوط البوليستر المطابقة للمواصفات العالمية للمنسوجات الرياضية والملابس الخارجية.',
      callToAction: 'طلب تسعيرة خاصة',
      startDate: DateTime.now().subtract(const Duration(days: 5)),
      endDate: DateTime.now().add(const Duration(days: 25)),
      targeting: const B2BAudienceTarget(
        factoryIndustries: ['مصانع النسيج', 'مصانع الملابس الرياضية'],
        factorySizes: ['كبير', 'ضخم'],
        locations: ['السعودية', 'الرياض'],
        purchasingBehaviors: ['مفاوضات سابقة', 'سحب مستمر'],
        purchaseVolumes: ['كميات ضخمة'],
        interestedCategories: ['خيوط', 'بوليستر'],
        verifiedOnly: true,
        premiumOnly: true,
        vipOnly: false,
        activeLast30Days: true,
        completedPaymentsOnly: true,
        highFrequencyOnly: false,
        searchingSimilarProducts: true,
      ),
    ),
    B2BAdvertisement(
      id: 'AD-103',
      title: 'باقات تغليف كرتوني مخصصة للمصانع الغذائية',
      productName: 'كرتون مضلع سميك 5 طبقات',
      campaignName: 'حملة باقات التغليف والصناديق',
      budget: 3000.0,
      spent: 3000.0,
      reach: 18900,
      clicks: 980,
      ctr: 5.18,
      orders: 19,
      revenue: 95000.0,
      status: AdStatus.completed,
      remainingBudget: 0.0,
      description: 'صناديق كرتونية مخصصة للتعبئة والشحن بقدرات تحمل عالية وتصميمات مخصصة.',
      callToAction: 'حجز موعد استشارة تصميم',
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: DateTime.now().subtract(const Duration(days: 2)),
      targeting: const B2BAudienceTarget(
        factoryIndustries: ['مصانع التعبئة والتغليف', 'مصانع الأغذية'],
        factorySizes: ['صغير', 'متوسط', 'كبير'],
        locations: ['الدمام', 'جدة'],
        purchasingBehaviors: ['استفسار عن عروض التعبئة'],
        purchaseVolumes: ['كميات متوسطة'],
        interestedCategories: ['تغليف', 'كرتون'],
        verifiedOnly: false,
        premiumOnly: false,
        vipOnly: false,
        activeLast30Days: true,
        completedPaymentsOnly: false,
        highFrequencyOnly: false,
        searchingSimilarProducts: true,
      ),
    ),
    B2BAdvertisement(
      id: 'AD-104',
      title: 'أزرار ومستلزمات معدنية مقاومة للصدأ',
      productName: 'أزرار جينز معدنية 15 مم',
      campaignName: 'حملة لوازم وإكسسوارات الملابس',
      budget: 1000.0,
      spent: 80.0,
      reach: 1200,
      clicks: 34,
      ctr: 2.83,
      orders: 2,
      revenue: 8000.0,
      status: AdStatus.pendingReview,
      remainingBudget: 920.0,
      description: 'لوازم معدنية وإكسسوارات عالية الجودة للجينز والسترات والملابس الجلدية.',
      callToAction: 'طلب عينة إكسسوارات',
      startDate: DateTime.now().add(const Duration(days: 2)),
      endDate: DateTime.now().add(const Duration(days: 12)),
      targeting: const B2BAudienceTarget(
        factoryIndustries: ['مصانع الملابس الجاهزة', 'مصانع الحقائب والأحذية'],
        factorySizes: ['متوسط', 'كبير'],
        locations: ['الشارقة', 'عجمان'],
        purchasingBehaviors: ['شراء مستلزمات'],
        purchaseVolumes: ['كميات خفيفة'],
        interestedCategories: ['إكسسوارات ملابس', 'معادن'],
        verifiedOnly: true,
        premiumOnly: false,
        vipOnly: false,
        activeLast30Days: false,
        completedPaymentsOnly: true,
        highFrequencyOnly: true,
        searchingSimilarProducts: false,
      ),
    ),
    B2BAdvertisement(
      id: 'AD-105',
      title: 'أقمشة كتان طبيعي بلجيكي مصبوغ',
      productName: 'كتان بلجيكي ناعم 240 جم',
      campaignName: 'حملة الأقمشة الصيفية 2026',
      budget: 2500.0,
      spent: 0.0,
      reach: 0,
      clicks: 0,
      ctr: 0.0,
      orders: 0,
      revenue: 0.0,
      status: AdStatus.paused,
      remainingBudget: 2500.0,
      description: 'أفضل أنواع الكتان الطبيعي البلجيكي المستورد المناسب للأزياء والملابس الفاخرة.',
      callToAction: 'طلب عينة كتان',
      startDate: DateTime.now().subtract(const Duration(days: 1)),
      endDate: DateTime.now().add(const Duration(days: 14)),
      targeting: const B2BAudienceTarget(
        factoryIndustries: ['مصانع الملابس الجاهزة', 'دور الأزياء المصنعة'],
        factorySizes: ['متوسط', 'كبير'],
        locations: ['دبي', 'الرياض'],
        purchasingBehaviors: ['تصفح الكتان مسبقاً'],
        purchaseVolumes: ['كميات متوسطة'],
        interestedCategories: ['كتان', 'أقمشة طبيعية'],
        verifiedOnly: true,
        premiumOnly: true,
        vipOnly: true,
        activeLast30Days: true,
        completedPaymentsOnly: true,
        highFrequencyOnly: false,
        searchingSimilarProducts: true,
      ),
    )
  ];

  static final List<MarketingCampaign> _campaigns = [
    MarketingCampaign(
      id: 'CAMP-01',
      name: 'حملة الأقمشة الصيفية 2026',
      objective: 'زيادة المبيعات والتحويلات لمصانع ملابس الصيف',
      budget: 5000.0,
      spent: 1240.0,
      productsCount: 4,
      status: CampaignStatus.active,
      durationDays: 30,
      roas: 96.7,
      revenue: 120000.0,
      orders: 24,
      reach: 12500,
      clicks: 620,
      ctr: 4.96,
    ),
    MarketingCampaign(
      id: 'CAMP-02',
      name: 'حملة الخيوط واللوازم الربعية',
      objective: 'توزيع كميات الخيوط والمواد الخام الفائضة',
      budget: 2000.0,
      spent: 450.0,
      productsCount: 2,
      status: CampaignStatus.active,
      durationDays: 30,
      roas: 77.7,
      revenue: 35000.0,
      orders: 8,
      reach: 5200,
      clicks: 180,
      ctr: 3.46,
    ),
    MarketingCampaign(
      id: 'CAMP-03',
      name: 'حملة باقات التغليف والصناديق',
      objective: 'تنشيط عقود مصانع الأغذية والحلويات لتعبئة وتغليف المنتجات',
      budget: 3000.0,
      spent: 3000.0,
      productsCount: 1,
      status: CampaignStatus.completed,
      durationDays: 28,
      roas: 31.6,
      revenue: 95000.0,
      orders: 19,
      reach: 18900,
      clicks: 980,
      ctr: 5.18,
    ),
    MarketingCampaign(
      id: 'CAMP-04',
      name: 'حملة لوازم وإكسسوارات الملابس',
      objective: 'تنشيط طلبات الإكسسوارات المعدنية والمستلزمات الصغيرة للسترات',
      budget: 1500.0,
      spent: 80.0,
      productsCount: 3,
      status: CampaignStatus.scheduled,
      durationDays: 14,
      roas: 100.0,
      revenue: 8000.0,
      orders: 2,
      reach: 1200,
      clicks: 34,
      ctr: 2.83,
    )
  ];

  static final List<FeaturedProductPromotion> _featuredProducts = [
    const FeaturedProductPromotion(
      id: 'FTP-01',
      productName: 'قطن ممتاز طويل التيلة',
      featuredDurationDays: 15,
      priorityLevel: 'High',
      promotionCost: 750.0,
      views: 4500,
      clicks: 320,
      orders: 14,
      revenue: 70000.0,
      active: true,
    ),
    const FeaturedProductPromotion(
      id: 'FTP-02',
      productName: 'صوف كشمير طبيعي ناعم',
      featuredDurationDays: 10,
      priorityLevel: 'Medium',
      promotionCost: 500.0,
      views: 2100,
      clicks: 120,
      orders: 5,
      revenue: 45000.0,
      active: true,
    ),
    const FeaturedProductPromotion(
      id: 'FTP-03',
      productName: 'أقمشة كتان بلجيكي فاخر',
      featuredDurationDays: 7,
      priorityLevel: 'Low',
      promotionCost: 250.0,
      views: 900,
      clicks: 45,
      orders: 1,
      revenue: 12000.0,
      active: false,
    )
  ];

  static final List<PromotionalOffer> _offers = [
    const PromotionalOffer(
      id: 'OFF-01',
      title: 'خصم VIP مصانع الملابس الجاهزة المتعاقدة',
      type: OfferType.vipPricing,
      discountValue: 15.0,
      minQuantity: 1000,
      active: true,
      reach: 480,
      conversions: 18,
      description: 'خصم خاص 15% على إجمالي طلبية خيوط القطن المجهزة فقط للشركاء المسجلين لدينا بمصانع الملابس.',
    ),
    const PromotionalOffer(
      id: 'OFF-02',
      title: 'شحن مجاني للطلبات الكبيرة من أقمشة البوليستر',
      type: OfferType.freeShipping,
      discountValue: 100.0,
      minQuantity: 5000,
      active: true,
      reach: 1200,
      conversions: 42,
      description: 'نوفر شحن وتوريد مجاني لأي مصنع يطلب أكثر من 5000 ياردة من أقمشة بوليستر الصيف.',
    ),
    const PromotionalOffer(
      id: 'OFF-03',
      title: 'باقة التوفير: اشترِ 10 لفات قماش واحصل على 2 مجاناً',
      type: OfferType.buyMoreSaveMore,
      discountValue: 20.0,
      minQuantity: 10,
      active: false,
      reach: 350,
      conversions: 9,
      description: 'عرض تجاري خاص لتوفير المخزون لمصانع الزي الموحد واليونيفورم قبل انطلاق الموسم الدراسي.',
    )
  ];

  static final List<B2BDiscountCoupon> _coupons = [
    B2BDiscountCoupon(
      id: 'CUP-01',
      code: 'COTTONVIP15',
      discountType: 'percentage',
      discountValue: 15.0,
      maxDiscount: 5000.0,
      usageLimit: 50,
      usageCount: 22,
      perCustomerLimit: 1,
      expirationDate: DateTime.now().add(const Duration(days: 30)),
      eligibleProducts: ['قطن ممتاز طويل التيلة', 'أقمشة كتان بلجيكي فاخر'],
      active: true,
    ),
    B2BDiscountCoupon(
      id: 'CUP-02',
      code: 'SHIPPINGSUPPLIER',
      discountType: 'fixed',
      discountValue: 1000.0,
      maxDiscount: 1000.0,
      usageLimit: 20,
      usageCount: 5,
      perCustomerLimit: 2,
      expirationDate: DateTime.now().add(const Duration(days: 15)),
      eligibleProducts: ['كرتون مضلع سميك 5 طبقات', 'خيوط بوليستر 150/48'],
      active: true,
    ),
    B2BDiscountCoupon(
      id: 'CUP-03',
      code: 'EXPIRED30',
      discountType: 'percentage',
      discountValue: 30.0,
      maxDiscount: 2000.0,
      usageLimit: 10,
      usageCount: 10,
      perCustomerLimit: 1,
      expirationDate: DateTime.now().subtract(const Duration(days: 1)),
      eligibleProducts: ['قطن ممتاز طويل التيلة'],
      active: false,
    )
  ];

  static final List<SponsoredProduct> _sponsoredProducts = [
    const SponsoredProduct(
      id: 'SPP-01',
      productName: 'قطن ممتاز طويل التيلة',
      budget: 3000.0,
      spent: 1200.0,
      views: 9400,
      clicks: 450,
      orders: 22,
      revenue: 110000.0,
      active: true,
    ),
    const SponsoredProduct(
      id: 'SPP-02',
      productName: 'خيوط بوليستر 150/48',
      budget: 2000.0,
      spent: 350.0,
      views: 4100,
      clicks: 140,
      orders: 6,
      revenue: 28000.0,
      active: true,
    ),
    const SponsoredProduct(
      id: 'SPP-03',
      productName: 'كرتون مضلع سميك 5 طبقات',
      budget: 1500.0,
      spent: 1500.0,
      views: 8900,
      clicks: 520,
      orders: 14,
      revenue: 70000.0,
      active: false,
    )
  ];

  static final List<MarketingNotification> _notifications = [
    MarketingNotification(
      id: 'NOT-01',
      title: 'تخفيضات 15% على مستلزمات تغليف مصانع الأغذية',
      body: 'يسرنا تقديم خصم خاص لمصانع الأغذية الشريكة على طلبات الكرتون المضلع طوال الأسبوع الحالي.',
      audienceOption: 'مصانع الأغذية والتعبئة والمهتمين بالتغليف',
      notificationType: 'خصم باقة تغليف',
      sentTime: DateTime.now().subtract(const Duration(days: 3)),
      sentCount: 150,
      clicks: 65,
      conversions: 12,
    ),
    MarketingNotification(
      id: 'NOT-02',
      title: 'توفر شحنة جديدة من القطن الهندي العضوي الفاخر',
      body: 'وصلت حديثاً للمستودع شحنة من القطن العضوي طويل التيلة. سارع بحجز طلبيتك والحصول على عينة مجانية.',
      audienceOption: 'عملاء القطن السابقين ومصانع الملابس',
      notificationType: 'إعلان وصول منتج جديد',
      sentTime: DateTime.now().subtract(const Duration(days: 7)),
      sentCount: 300,
      clicks: 140,
      conversions: 24,
    )
  ];

  static final List<MarketingInsight> _insights = [
    const MarketingInsight(
      id: 'INS-01',
      title: 'فئة الأقمشة القطنية تسجل أعلى معدلات CTR',
      description: 'حملة الأقمشة الصيفية حققت نسبة CTR بلغت 4.96%، مما يدل على اهتمام كبير من مصانع الملابس الجاهزة.',
      type: 'success',
      recommendation: 'يُنصح بزيادة الميزانية بنسبة 20% لحملة الأقمشة الصيفية لتغطية مصانع إضافية قيد الطلب.',
    ),
    const MarketingInsight(
      id: 'INS-02',
      title: 'نفاد الميزانية لحملة باقات التغليف والصناديق',
      description: 'الحملة حققت إيرادات بقيمة 95 ألف ريال بروس (ROAS) متميز 31.6x ولكنها متوقفة لنفاذ الميزانية المحددة.',
      type: 'warning',
      recommendation: 'قم بإعادة تمويل حملة الصناديق الكرتونية أو إنشاء عرض مخصص لمصانع الأغذية سريعة التجاوب.',
    ),
    const MarketingInsight(
      id: 'INS-03',
      title: 'أفضل الأوقات لإرسال إشعارات B2B للمصانع',
      description: 'سجلت إشعارات العروض تفاعلاً أعلى بنسبة 40% عند إرسالها صباح يوم الأحد بين 9:00 و11:00 صباحاً.',
      type: 'tip',
      recommendation: 'قم بجدولة الإشعارات الترويجية القادمة للأسبوع القادم ليوم الأحد صباحاً لرفع نسب النقر والقراءة.',
    )
  ];

  @override
  Future<MarketingDashboardData> getDashboardData() async {
    int activeAds = _ads.where((ad) => ad.status == AdStatus.active).length;
    int pendingAds = _ads.where((ad) => ad.status == AdStatus.pendingReview).length;
    int scheduledCamps = _campaigns.where((c) => c.status == CampaignStatus.scheduled).length;
    int runningCamps = _campaigns.where((c) => c.status == CampaignStatus.active).length;

    return MarketingDashboardData(
      campaignBudget: _campaignBudget,
      spent: _totalSpent,
      reach: 36600,
      impressions: 122500,
      clicks: 1780,
      ctr: 4.86,
      conversions: 53,
      ordersGenerated: 51,
      revenueGenerated: 258000.0,
      roas: 30.2,
      activeAdsCount: activeAds,
      pendingReviewCount: pendingAds,
      scheduledCampaignsCount: scheduledCamps,
      runningCampaignsCount: runningCamps,
    );
  }

  @override
  Future<List<B2BAdvertisement>> getAdvertisements() async {
    return _ads;
  }

  @override
  Future<B2BAdvertisement> createAdvertisement(B2BAdvertisement ad) async {
    final newAd = ad.copyWith(
      id: 'AD-${DateTime.now().millisecondsSinceEpoch}',
      spent: 0.0,
      reach: 0,
      clicks: 0,
      ctr: 0.0,
      orders: 0,
      revenue: 0.0,
      remainingBudget: ad.budget,
    );
    _ads.add(newAd);
    return newAd;
  }

  @override
  Future<void> updateAdvertisementStatus(String id, AdStatus status) async {
    final idx = _ads.indexWhere((ad) => ad.id == id);
    if (idx != -1) {
      _ads[idx] = _ads[idx].copyWith(status: status);
    }
  }

  @override
  Future<void> deleteAdvertisement(String id) async {
    _ads.removeWhere((ad) => ad.id == id);
  }

  @override
  Future<List<MarketingCampaign>> getCampaigns() async {
    return _campaigns;
  }

  @override
  Future<MarketingCampaign> createCampaign(MarketingCampaign campaign) async {
    final newCamp = campaign.copyWith(
      id: 'CAMP-${DateTime.now().millisecondsSinceEpoch}',
      spent: 0.0,
      orders: 0,
      revenue: 0.0,
      reach: 0,
      clicks: 0,
      ctr: 0.0,
      roas: 0.0,
    );
    _campaigns.add(newCamp);
    return newCamp;
  }

  @override
  Future<void> updateCampaignStatus(String id, CampaignStatus status) async {
    final idx = _campaigns.indexWhere((c) => c.id == id);
    if (idx != -1) {
      _campaigns[idx] = _campaigns[idx].copyWith(status: status);
    }
  }

  @override
  Future<List<FeaturedProductPromotion>> getFeaturedProducts() async {
    return _featuredProducts;
  }

  @override
  Future<void> promoteProduct(FeaturedProductPromotion promotion) async {
    // Add to featured product promotions
    final idx = _featuredProducts.indexWhere((p) => p.productName == promotion.productName);
    if (idx != -1) {
      _featuredProducts[idx] = promotion;
    } else {
      _featuredProducts.add(promotion);
    }
  }

  @override
  Future<List<PromotionalOffer>> getPromotionalOffers() async {
    return _offers;
  }

  @override
  Future<void> createOffer(PromotionalOffer offer) async {
    _offers.add(offer);
  }

  @override
  Future<List<B2BDiscountCoupon>> getCoupons() async {
    return _coupons;
  }

  @override
  Future<B2BDiscountCoupon> createCoupon(B2BDiscountCoupon coupon) async {
    final newCoupon = coupon.copyWith(
      id: 'CUP-${DateTime.now().millisecondsSinceEpoch}',
      usageCount: 0,
    );
    _coupons.add(newCoupon);
    return newCoupon;
  }

  @override
  Future<void> updateCouponStatus(String id, bool active) async {
    final idx = _coupons.indexWhere((c) => c.id == id);
    if (idx != -1) {
      _coupons[idx] = _coupons[idx].copyWith(active: active);
    }
  }

  @override
  Future<List<SponsoredProduct>> getSponsoredProducts() async {
    return _sponsoredProducts;
  }

  @override
  Future<SponsoredProduct> createSponsoredProduct(SponsoredProduct product) async {
    final newSpp = product.copyWith(
      id: 'SPP-${DateTime.now().millisecondsSinceEpoch}',
      spent: 0.0,
      views: 0,
      clicks: 0,
      orders: 0,
      revenue: 0.0,
    );
    _sponsoredProducts.add(newSpp);
    return newSpp;
  }

  @override
  Future<void> updateSponsoredProductStatus(String id, bool active) async {
    final idx = _sponsoredProducts.indexWhere((p) => p.id == id);
    if (idx != -1) {
      _sponsoredProducts[idx] = _sponsoredProducts[idx].copyWith(active: active);
    }
  }

  @override
  Future<BudgetManagementData> getBudgetInfo() async {
    return BudgetManagementData(
      dailyBudget: _dailyBudget,
      campaignBudget: _campaignBudget,
      monthlyBudget: _monthlyBudget,
      spent: _totalSpent,
      remaining: _monthlyBudget - _totalSpent,
      budgetAlerts: [
        'ميزانية شهر يوليو شارفت على النفاد بنسبة تفوق 80%.',
        'ميزانية حملة باقات التغليف والصناديق مستهلكة بالكامل (100%).'
      ],
      estimatedReach: 60000,
      estimatedOrders: 180,
    );
  }

  @override
  Future<void> updateBudget(double daily, double monthly) async {
    _dailyBudget = daily;
    _monthlyBudget = monthly;
  }

  @override
  Future<MarketingAnalyticsData> getAnalytics() async {
    return const MarketingAnalyticsData(
      monthlyReach: [12000, 18000, 24000, 31000, 45200],
      monthlyImpressions: [29000, 41000, 52000, 68000, 98400],
      monthlyClicks: [380, 510, 890, 1200, 3120],
      monthlyCtr: [1.31, 1.24, 1.71, 1.76, 3.17],
      monthlyConversionRate: [4.2, 5.1, 4.8, 5.2, 5.8],
      monthlyOrders: [16, 26, 42, 62, 75],
      monthlyRevenue: [64000.0, 104000.0, 189000.0, 312000.0, 380000.0],
      monthlyRoas: [18.2, 22.4, 28.6, 36.6, 44.5],
      bestCampaigns: [
        {'name': 'حملة الأقمشة الصيفية 2026', 'revenue': 120000.0, 'orders': 24, 'roas': 96.7},
        {'name': 'حملة باقات التغليف والصناديق', 'revenue': 95000.0, 'orders': 19, 'roas': 31.6},
        {'name': 'حملة الخيوط واللوازم الربعية', 'revenue': 35000.0, 'orders': 8, 'roas': 77.7}
      ],
      bestProducts: [
        {'name': 'قطن ممتاز طويل التيلة', 'clicks': 620, 'orders': 24, 'revenue': 120000.0},
        {'name': 'كرتون مضلع سميك 5 طبقات', 'clicks': 980, 'orders': 19, 'revenue': 95000.0},
        {'name': 'خيوط بوليستر 150/48', 'clicks': 180, 'orders': 8, 'revenue': 35000.0}
      ],
      bestCustomers: [
        {'factoryName': 'مصنع النور للملابس الجاهزة', 'orders': 14, 'revenue': 70000.0, 'industry': 'ملابس جاهزة'},
        {'factoryName': 'شركة تغليف الشرق للمنتجات الغذائية', 'orders': 11, 'revenue': 55000.0, 'industry': 'أغذية وتغليف'},
        {'factoryName': 'مؤسسة دبي للزي الموحد', 'orders': 8, 'revenue': 40000.0, 'industry': 'يونيفورم'}
      ],
    );
  }

  @override
  Future<List<MarketingNotification>> getSentNotifications() async {
    return _notifications;
  }

  @override
  Future<MarketingNotification> sendNotification(MarketingNotification notification) async {
    final newNotif = MarketingNotification(
      id: 'NOT-${DateTime.now().millisecondsSinceEpoch}',
      title: notification.title,
      body: notification.body,
      audienceOption: notification.audienceOption,
      notificationType: notification.notificationType,
      sentTime: DateTime.now(),
      sentCount: 220,
      clicks: 0,
      conversions: 0,
    );
    _notifications.insert(0, newNotif);
    return newNotif;
  }

  @override
  Future<List<MarketingInsight>> getInsights() async {
    return _insights;
  }

  @override
  Future<SmartB2BRecommendation> getRecommendations() async {
    return const SmartB2BRecommendation(
      bestProductsToPromote: [
        'قطن ممتاز طويل التيلة (طلب مرتفع جداً حالياً)',
        'خيوط بوليستر 150/48 (مخزون وافر وتفاعل جيد)'
      ],
      bestTimeLaunch: 'يوم الأحد بين 9:00 و11:00 صباحاً',
      recommendedBudget: 2500.0,
      expectedReach: 15000,
      expectedOrders: 45,
      expectedRevenue: 220000.0,
      recommendedSegments: [
        'مصانع ملابس الصيف النشطة في الـ 30 يوماً الماضية',
        'مصانع الزي الموحد التي أبدت اهتماماً بطلب عينات القطن'
      ],
    );
  }
}

@riverpod
MarketingRepository marketingRepository(MarketingRepositoryRef ref) {
  return MarketingRepositoryImpl();
}
