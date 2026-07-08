// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$subscriptionRepositoryHash() =>
    r'f173c1f217df8c8742435d66de8c96c36322475e';

/// See also [subscriptionRepository].
@ProviderFor(subscriptionRepository)
final subscriptionRepositoryProvider =
    AutoDisposeProvider<SubscriptionRepository>.internal(
      subscriptionRepository,
      name: r'subscriptionRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$subscriptionRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubscriptionRepositoryRef =
    AutoDisposeProviderRef<SubscriptionRepository>;
String _$activeSubscriptionControllerHash() =>
    r'3d14ad7695c6446c2ad2350197255adf69d8aba2';

/// See also [ActiveSubscriptionController].
@ProviderFor(ActiveSubscriptionController)
final activeSubscriptionControllerProvider =
    AutoDisposeAsyncNotifierProvider<
      ActiveSubscriptionController,
      SupplierSubscription
    >.internal(
      ActiveSubscriptionController.new,
      name: r'activeSubscriptionControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeSubscriptionControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ActiveSubscriptionController =
    AutoDisposeAsyncNotifier<SupplierSubscription>;
String _$subscriptionPlansControllerHash() =>
    r'a1b671e3d04a59c38295f2c420138bf7c22d8991';

/// See also [SubscriptionPlansController].
@ProviderFor(SubscriptionPlansController)
final subscriptionPlansControllerProvider =
    AutoDisposeAsyncNotifierProvider<
      SubscriptionPlansController,
      List<SubscriptionPlan>
    >.internal(
      SubscriptionPlansController.new,
      name: r'subscriptionPlansControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$subscriptionPlansControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SubscriptionPlansController =
    AutoDisposeAsyncNotifier<List<SubscriptionPlan>>;
String _$subscriptionUsageControllerHash() =>
    r'1e8c6e18cb53137aab7ef8b4ea4d9907298cd8cf';

/// See also [SubscriptionUsageController].
@ProviderFor(SubscriptionUsageController)
final subscriptionUsageControllerProvider =
    AutoDisposeAsyncNotifierProvider<
      SubscriptionUsageController,
      SubscriptionUsage
    >.internal(
      SubscriptionUsageController.new,
      name: r'subscriptionUsageControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$subscriptionUsageControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SubscriptionUsageController =
    AutoDisposeAsyncNotifier<SubscriptionUsage>;
String _$billingControllerHash() => r'f73221ef62ca5b3f4706dd663903597907b381f2';

/// See also [BillingController].
@ProviderFor(BillingController)
final billingControllerProvider =
    AutoDisposeAsyncNotifierProvider<BillingController, BillingData>.internal(
      BillingController.new,
      name: r'billingControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$billingControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BillingController = AutoDisposeAsyncNotifier<BillingData>;
String _$paymentMethodsControllerHash() =>
    r'0adbae5517df9d80317e368ed6a191bafe1e8c26';

/// See also [PaymentMethodsController].
@ProviderFor(PaymentMethodsController)
final paymentMethodsControllerProvider =
    AutoDisposeAsyncNotifierProvider<
      PaymentMethodsController,
      List<PaymentMethodItem>
    >.internal(
      PaymentMethodsController.new,
      name: r'paymentMethodsControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$paymentMethodsControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PaymentMethodsController =
    AutoDisposeAsyncNotifier<List<PaymentMethodItem>>;
String _$addonsStoreControllerHash() =>
    r'c1c301eb050ec31107a020b8758d961a064b99aa';

/// See also [AddonsStoreController].
@ProviderFor(AddonsStoreController)
final addonsStoreControllerProvider =
    AutoDisposeAsyncNotifierProvider<
      AddonsStoreController,
      List<AddonItem>
    >.internal(
      AddonsStoreController.new,
      name: r'addonsStoreControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$addonsStoreControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AddonsStoreController = AutoDisposeAsyncNotifier<List<AddonItem>>;
String _$subscriptionHistoryControllerHash() =>
    r'13b7a3795b5a7f067c13c806b0428697a780b1d7';

/// See also [SubscriptionHistoryController].
@ProviderFor(SubscriptionHistoryController)
final subscriptionHistoryControllerProvider =
    AutoDisposeAsyncNotifierProvider<
      SubscriptionHistoryController,
      List<SubscriptionHistoryItem>
    >.internal(
      SubscriptionHistoryController.new,
      name: r'subscriptionHistoryControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$subscriptionHistoryControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SubscriptionHistoryController =
    AutoDisposeAsyncNotifier<List<SubscriptionHistoryItem>>;
String _$billingInvoicesControllerHash() =>
    r'ef4b120b3f63d3d331f4eb47b45c3892f895a45b';

/// See also [BillingInvoicesController].
@ProviderFor(BillingInvoicesController)
final billingInvoicesControllerProvider =
    AutoDisposeAsyncNotifierProvider<
      BillingInvoicesController,
      List<SubscriptionInvoice>
    >.internal(
      BillingInvoicesController.new,
      name: r'billingInvoicesControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$billingInvoicesControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BillingInvoicesController =
    AutoDisposeAsyncNotifier<List<SubscriptionInvoice>>;
String _$subscriptionNotificationsControllerHash() =>
    r'086d72b706651af4a0abe6c23773bd4c7d223a93';

/// See also [SubscriptionNotificationsController].
@ProviderFor(SubscriptionNotificationsController)
final subscriptionNotificationsControllerProvider =
    AutoDisposeAsyncNotifierProvider<
      SubscriptionNotificationsController,
      List<SubscriptionNotification>
    >.internal(
      SubscriptionNotificationsController.new,
      name: r'subscriptionNotificationsControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$subscriptionNotificationsControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SubscriptionNotificationsController =
    AutoDisposeAsyncNotifier<List<SubscriptionNotification>>;
String _$subscriptionAnalyticsControllerHash() =>
    r'8f87dec56f71c5a52ba88236483691b8223ad1db';

/// See also [SubscriptionAnalyticsController].
@ProviderFor(SubscriptionAnalyticsController)
final subscriptionAnalyticsControllerProvider =
    AutoDisposeAsyncNotifierProvider<
      SubscriptionAnalyticsController,
      SubscriptionAnalyticsData
    >.internal(
      SubscriptionAnalyticsController.new,
      name: r'subscriptionAnalyticsControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$subscriptionAnalyticsControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SubscriptionAnalyticsController =
    AutoDisposeAsyncNotifier<SubscriptionAnalyticsData>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
