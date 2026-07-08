import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/subscription_models.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../../data/repositories/subscription_repository_impl.dart';

part 'subscription_controllers.g.dart';

@riverpod
SubscriptionRepository subscriptionRepository(SubscriptionRepositoryRef ref) {
  return SubscriptionRepositoryImpl();
}

@riverpod
class ActiveSubscriptionController extends _$ActiveSubscriptionController {
  @override
  FutureOr<SupplierSubscription> build() {
    return ref.watch(subscriptionRepositoryProvider).getSubscription();
  }

  Future<void> toggleAutoRenew(bool val) async {
    state = const AsyncValue.loading();
    await ref.read(subscriptionRepositoryProvider).toggleAutoRenew(val);
    ref.invalidateSelf();
  }

  Future<void> renew() async {
    state = const AsyncValue.loading();
    await ref.read(subscriptionRepositoryProvider).renewSubscription();
    ref.invalidateSelf();
    // Invalidate usages and invoices to trigger refreshes
    ref.invalidate(subscriptionUsageControllerProvider);
    ref.invalidate(billingInvoicesControllerProvider);
    ref.invalidate(billingControllerProvider);
  }

  Future<void> upgrade(String planId, BillingCycle cycle) async {
    state = const AsyncValue.loading();
    await ref.read(subscriptionRepositoryProvider).upgradePlan(planId, cycle);
    ref.invalidateSelf();
    ref.invalidate(subscriptionUsageControllerProvider);
    ref.invalidate(billingInvoicesControllerProvider);
    ref.invalidate(billingControllerProvider);
    ref.invalidate(subscriptionHistoryControllerProvider);
    ref.invalidate(subscriptionAnalyticsControllerProvider);
  }

  Future<void> downgrade(String planId, BillingCycle cycle) async {
    state = const AsyncValue.loading();
    await ref.read(subscriptionRepositoryProvider).downgradePlan(planId, cycle);
    ref.invalidateSelf();
  }
}

@riverpod
class SubscriptionPlansController extends _$SubscriptionPlansController {
  @override
  FutureOr<List<SubscriptionPlan>> build() {
    return ref.watch(subscriptionRepositoryProvider).getPlans();
  }
}

@riverpod
class SubscriptionUsageController extends _$SubscriptionUsageController {
  @override
  FutureOr<SubscriptionUsage> build() {
    return ref.watch(subscriptionRepositoryProvider).getUsage();
  }
}

@riverpod
class BillingController extends _$BillingController {
  @override
  FutureOr<BillingData> build() {
    return ref.watch(subscriptionRepositoryProvider).getBillingData();
  }

  Future<void> applyCouponCode(String code) async {
    state = const AsyncValue.loading();
    await ref.read(subscriptionRepositoryProvider).applyCoupon(code);
    ref.invalidateSelf();
  }
}

@riverpod
class PaymentMethodsController extends _$PaymentMethodsController {
  @override
  FutureOr<List<PaymentMethodItem>> build() {
    return ref.watch(subscriptionRepositoryProvider).getPaymentMethods();
  }

  Future<void> addMethod(PaymentMethodItem method) async {
    state = const AsyncValue.loading();
    await ref.read(subscriptionRepositoryProvider).addPaymentMethod(method);
    ref.invalidateSelf();
    ref.invalidate(activeSubscriptionControllerProvider);
  }

  Future<void> deleteMethod(String id) async {
    state = const AsyncValue.loading();
    await ref.read(subscriptionRepositoryProvider).deletePaymentMethod(id);
    ref.invalidateSelf();
  }

  Future<void> setDefault(String id) async {
    state = const AsyncValue.loading();
    await ref.read(subscriptionRepositoryProvider).setDefaultPaymentMethod(id);
    ref.invalidateSelf();
    ref.invalidate(activeSubscriptionControllerProvider);
  }
}

@riverpod
class AddonsStoreController extends _$AddonsStoreController {
  @override
  FutureOr<List<AddonItem>> build() {
    return ref.watch(subscriptionRepositoryProvider).getAddons();
  }

  Future<void> buyAddon(String addonId) async {
    state = const AsyncValue.loading();
    await ref.read(subscriptionRepositoryProvider).purchaseAddon(addonId);
    ref.invalidateSelf();
    ref.invalidate(subscriptionUsageControllerProvider);
    ref.invalidate(billingInvoicesControllerProvider);
    ref.invalidate(subscriptionHistoryControllerProvider);
  }

  Future<void> buyPayAsYouGo(String serviceName, double cost) async {
    state = const AsyncValue.loading();
    await ref.read(subscriptionRepositoryProvider).purchasePayAsYouGo(serviceName, cost);
    ref.invalidateSelf();
    ref.invalidate(billingInvoicesControllerProvider);
  }
}

@riverpod
class SubscriptionHistoryController extends _$SubscriptionHistoryController {
  @override
  FutureOr<List<SubscriptionHistoryItem>> build() {
    return ref.watch(subscriptionRepositoryProvider).getSubscriptionHistory();
  }
}

@riverpod
class BillingInvoicesController extends _$BillingInvoicesController {
  @override
  FutureOr<List<SubscriptionInvoice>> build() {
    return ref.watch(subscriptionRepositoryProvider).getInvoices();
  }
}

@riverpod
class SubscriptionNotificationsController extends _$SubscriptionNotificationsController {
  @override
  FutureOr<List<SubscriptionNotification>> build() {
    return ref.watch(subscriptionRepositoryProvider).getNotifications();
  }
}

@riverpod
class SubscriptionAnalyticsController extends _$SubscriptionAnalyticsController {
  @override
  FutureOr<SubscriptionAnalyticsData> build() {
    return ref.watch(subscriptionRepositoryProvider).getAnalytics();
  }
}
