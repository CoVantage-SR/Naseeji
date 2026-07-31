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
String _$subscriptionServiceHash() =>
    r'4c9f11fe90286e9f2540bddb549e4dd8b9ba5ea5';

/// See also [subscriptionService].
@ProviderFor(subscriptionService)
final subscriptionServiceProvider =
    AutoDisposeProvider<SubscriptionService>.internal(
      subscriptionService,
      name: r'subscriptionServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$subscriptionServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubscriptionServiceRef = AutoDisposeProviderRef<SubscriptionService>;
String _$subscriptionHash() => r'ef5d63d466ed9d01daf8e143129784607682185b';

/// Direct provider alias: subscriptionProvider
///
/// Copied from [subscription].
@ProviderFor(subscription)
final subscriptionProvider =
    AutoDisposeFutureProvider<SupplierSubscription>.internal(
      subscription,
      name: r'subscriptionProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$subscriptionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubscriptionRef = AutoDisposeFutureProviderRef<SupplierSubscription>;
String _$subscriptionUsageHash() => r'76b3757ac2254086e30eb10a423fe7bc3cc1f33b';

/// Direct provider alias: subscriptionUsageProvider
///
/// Copied from [subscriptionUsage].
@ProviderFor(subscriptionUsage)
final subscriptionUsageProvider =
    AutoDisposeFutureProvider<SubscriptionUsage>.internal(
      subscriptionUsage,
      name: r'subscriptionUsageProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$subscriptionUsageHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubscriptionUsageRef = AutoDisposeFutureProviderRef<SubscriptionUsage>;
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
    r'013a55e6f7f4f5d15804e87542c1bb2e8014c8a1';

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
String _$subscriptionValidationHash() =>
    r'69178c08609d68751fbba1cbd80f7fb2d479a9fb';

/// Riverpod provider for subscription validations
///
/// Copied from [SubscriptionValidation].
@ProviderFor(SubscriptionValidation)
final subscriptionValidationProvider =
    AutoDisposeNotifierProvider<SubscriptionValidation, void>.internal(
      SubscriptionValidation.new,
      name: r'subscriptionValidationProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$subscriptionValidationHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SubscriptionValidation = AutoDisposeNotifier<void>;
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
    r'cfcecfcd3dbd963112a715846029fb2b8ef47450';

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
