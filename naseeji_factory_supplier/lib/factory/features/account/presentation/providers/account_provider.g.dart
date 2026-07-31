// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$factoryHash() => r'91cf9fd28851cd7ff6ca9c6a34c985363a57fe84';

/// See also [factory].
@ProviderFor(factory)
final factoryProvider = AutoDisposeProvider<FactoryProfileEntity>.internal(
  factory,
  name: r'factoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$factoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FactoryRef = AutoDisposeProviderRef<FactoryProfileEntity>;
String _$subscriptionHash() => r'1edfdb1a9030a46d8add39996e5f938d18d87ef4';

/// See also [subscription].
@ProviderFor(subscription)
final subscriptionProvider = AutoDisposeProvider<SubscriptionModel>.internal(
  subscription,
  name: r'subscriptionProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$subscriptionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SubscriptionRef = AutoDisposeProviderRef<SubscriptionModel>;
String _$walletHash() => r'7030e41ea6b371f94fcf4ca4558ed2e88e433ad7';

/// See also [wallet].
@ProviderFor(wallet)
final walletProvider = AutoDisposeProvider<WalletEntity>.internal(
  wallet,
  name: r'walletProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$walletHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WalletRef = AutoDisposeProviderRef<WalletEntity>;
String _$employeesHash() => r'a596fa5cd017dd6f2571e802618b7f8965d085f9';

/// See also [employees].
@ProviderFor(employees)
final employeesProvider = AutoDisposeProvider<EmployeesSummaryModel>.internal(
  employees,
  name: r'employeesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$employeesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef EmployeesRef = AutoDisposeProviderRef<EmployeesSummaryModel>;
String _$rewardPointsHash() => r'7836a19f601240b46d26223fad96b9d7cc3992da';

/// See also [rewardPoints].
@ProviderFor(rewardPoints)
final rewardPointsProvider = AutoDisposeProvider<RewardStateEntity>.internal(
  rewardPoints,
  name: r'rewardPointsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$rewardPointsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RewardPointsRef = AutoDisposeProviderRef<RewardStateEntity>;
String _$notificationsHash() => r'8836a19f601240b46d26223fad96b9d7cc3992da';

/// See also [notifications].
@ProviderFor(notifications)
final notificationsProvider = AutoDisposeProvider<List<NotificationItemEntity>>.internal(
  notifications,
  name: r'notificationsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$notificationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NotificationsRef = AutoDisposeProviderRef<List<NotificationItemEntity>>;
String _$supportTicketsHash() => r'9936a19f601240b46d26223fad96b9d7cc3992da';

/// See also [supportTickets].
@ProviderFor(supportTickets)
final supportTicketsProvider = AutoDisposeProvider<List<SupportTicketEntity>>.internal(
  supportTickets,
  name: r'supportTicketsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$supportTicketsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SupportTicketsRef = AutoDisposeProviderRef<List<SupportTicketEntity>>;
String _$accountNotifierHash() => r'344bc69597ba2550ef7c92cd382543e7cb2adc84';

/// See also [AccountNotifier].
@ProviderFor(AccountNotifier)
final accountNotifierProvider =
    AutoDisposeNotifierProvider<AccountNotifier, AccountState>.internal(
  AccountNotifier.new,
  name: r'accountNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$accountNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AccountNotifier = AutoDisposeNotifier<AccountState>;
String _$securityNotifierHash() => r'267a98bc9142f722b2b026b389afd65dca18f852';

/// See also [SecurityNotifier].
@ProviderFor(SecurityNotifier)
final securityNotifierProvider =
    AutoDisposeNotifierProvider<SecurityNotifier, SecurityModel>.internal(
  SecurityNotifier.new,
  name: r'securityNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$securityNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SecurityNotifier = AutoDisposeNotifier<SecurityModel>;
String _$notificationSettingsNotifierHash() =>
    r'9d888e531e1e73d52ba25a2fe5b3ecb591804613';

/// See also [NotificationSettingsNotifier].
@ProviderFor(NotificationSettingsNotifier)
final notificationSettingsNotifierProvider = AutoDisposeNotifierProvider<
    NotificationSettingsNotifier, NotificationSettingsModel>.internal(
  NotificationSettingsNotifier.new,
  name: r'notificationSettingsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationSettingsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationSettingsNotifier
    = AutoDisposeNotifier<NotificationSettingsModel>;
String _$paymentNotifierHash() => r'7bec1e7ff1e90eb0ab8a0c1e4294e06cc89f6c1a';

/// See also [PaymentNotifier].
@ProviderFor(PaymentNotifier)
final paymentNotifierProvider = AutoDisposeNotifierProvider<PaymentNotifier,
    List<Map<String, String>>>.internal(
  PaymentNotifier.new,
  name: r'paymentNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$paymentNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PaymentNotifier = AutoDisposeNotifier<List<Map<String, String>>>;
String _$settingsNotifierHash() => r'41c8e4b1b5251b635db6b7c26ddc8c64930b4b66';

/// See also [SettingsNotifier].
@ProviderFor(SettingsNotifier)
final settingsNotifierProvider =
    AutoDisposeNotifierProvider<SettingsNotifier, AppSettingsModel>.internal(
  SettingsNotifier.new,
  name: r'settingsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$settingsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SettingsNotifier = AutoDisposeNotifier<AppSettingsModel>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

