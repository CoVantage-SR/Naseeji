import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/marketing_models.dart';
import '../../data/repositories/marketing_repository_impl.dart';

part 'marketing_controllers.g.dart';

@riverpod
class MarketingDashboardController extends _$MarketingDashboardController {
  @override
  FutureOr<MarketingDashboardData> build() async {
    final repo = ref.watch(marketingRepositoryProvider);
    return repo.getDashboardData();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(marketingRepositoryProvider);
      return repo.getDashboardData();
    });
  }
}

@riverpod
class MarketingAdvertisementsController extends _$MarketingAdvertisementsController {
  @override
  FutureOr<List<B2BAdvertisement>> build() async {
    final repo = ref.watch(marketingRepositoryProvider);
    return repo.getAdvertisements();
  }

  Future<void> createAd(B2BAdvertisement ad) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(marketingRepositoryProvider);
      await repo.createAdvertisement(ad);
      ref.invalidate(marketingDashboardControllerProvider);
      return repo.getAdvertisements();
    });
  }

  Future<void> updateAdStatus(String id, AdStatus status) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(marketingRepositoryProvider);
      await repo.updateAdvertisementStatus(id, status);
      ref.invalidate(marketingDashboardControllerProvider);
      return repo.getAdvertisements();
    });
  }

  Future<void> deleteAd(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(marketingRepositoryProvider);
      await repo.deleteAdvertisement(id);
      ref.invalidate(marketingDashboardControllerProvider);
      return repo.getAdvertisements();
    });
  }
}

@riverpod
class MarketingCampaignsController extends _$MarketingCampaignsController {
  @override
  FutureOr<List<MarketingCampaign>> build() async {
    final repo = ref.watch(marketingRepositoryProvider);
    return repo.getCampaigns();
  }

  Future<void> createCampaign(MarketingCampaign campaign) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(marketingRepositoryProvider);
      await repo.createCampaign(campaign);
      ref.invalidate(marketingDashboardControllerProvider);
      return repo.getCampaigns();
    });
  }

  Future<void> updateCampaignStatus(String id, CampaignStatus status) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(marketingRepositoryProvider);
      await repo.updateCampaignStatus(id, status);
      ref.invalidate(marketingDashboardControllerProvider);
      return repo.getCampaigns();
    });
  }
}

@riverpod
class FeaturedProductsController extends _$FeaturedProductsController {
  @override
  FutureOr<List<FeaturedProductPromotion>> build() async {
    final repo = ref.watch(marketingRepositoryProvider);
    return repo.getFeaturedProducts();
  }

  Future<void> promoteProduct(FeaturedProductPromotion promotion) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(marketingRepositoryProvider);
      await repo.promoteProduct(promotion);
      return repo.getFeaturedProducts();
    });
  }
}

@riverpod
class PromotionalOffersController extends _$PromotionalOffersController {
  @override
  FutureOr<List<PromotionalOffer>> build() async {
    final repo = ref.watch(marketingRepositoryProvider);
    return repo.getPromotionalOffers();
  }

  Future<void> createOffer(PromotionalOffer offer) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(marketingRepositoryProvider);
      await repo.createOffer(offer);
      return repo.getPromotionalOffers();
    });
  }
}

@riverpod
class CouponsController extends _$CouponsController {
  @override
  FutureOr<List<B2BDiscountCoupon>> build() async {
    final repo = ref.watch(marketingRepositoryProvider);
    return repo.getCoupons();
  }

  Future<void> createCoupon(B2BDiscountCoupon coupon) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(marketingRepositoryProvider);
      await repo.createCoupon(coupon);
      return repo.getCoupons();
    });
  }

  Future<void> updateCouponStatus(String id, bool active) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(marketingRepositoryProvider);
      await repo.updateCouponStatus(id, active);
      return repo.getCoupons();
    });
  }
}

@riverpod
class SponsoredProductsController extends _$SponsoredProductsController {
  @override
  FutureOr<List<SponsoredProduct>> build() async {
    final repo = ref.watch(marketingRepositoryProvider);
    return repo.getSponsoredProducts();
  }

  Future<void> createSponsored(SponsoredProduct product) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(marketingRepositoryProvider);
      await repo.createSponsoredProduct(product);
      return repo.getSponsoredProducts();
    });
  }

  Future<void> updateSponsoredStatus(String id, bool active) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(marketingRepositoryProvider);
      await repo.updateSponsoredProductStatus(id, active);
      return repo.getSponsoredProducts();
    });
  }
}

@riverpod
class MarketingBudgetController extends _$MarketingBudgetController {
  @override
  FutureOr<BudgetManagementData> build() async {
    final repo = ref.watch(marketingRepositoryProvider);
    return repo.getBudgetInfo();
  }

  Future<void> updateCap(double daily, double monthly) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(marketingRepositoryProvider);
      await repo.updateBudget(daily, monthly);
      return repo.getBudgetInfo();
    });
  }
}

@riverpod
class MarketingAnalyticsController extends _$MarketingAnalyticsController {
  @override
  FutureOr<MarketingAnalyticsData> build() async {
    final repo = ref.watch(marketingRepositoryProvider);
    return repo.getAnalytics();
  }
}

@riverpod
class MarketingInsightsController extends _$MarketingInsightsController {
  @override
  FutureOr<List<MarketingInsight>> build() async {
    final repo = ref.watch(marketingRepositoryProvider);
    return repo.getInsights();
  }
}

@riverpod
class MarketingNotificationsController extends _$MarketingNotificationsController {
  @override
  FutureOr<List<MarketingNotification>> build() async {
    final repo = ref.watch(marketingRepositoryProvider);
    return repo.getSentNotifications();
  }

  Future<void> sendNotification(MarketingNotification notification) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(marketingRepositoryProvider);
      await repo.sendNotification(notification);
      return repo.getSentNotifications();
    });
  }
}

@riverpod
class SmartB2BRecommendationsController extends _$SmartB2BRecommendationsController {
  @override
  FutureOr<SmartB2BRecommendation> build() async {
    final repo = ref.watch(marketingRepositoryProvider);
    return repo.getRecommendations();
  }
}
