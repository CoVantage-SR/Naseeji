// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$factoryHash() => r'b974b5961b93dddc59ce630f3a7e7e0b3ae6a913';

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
String _$subscriptionHash() => r'3d56ec3f440130440b979d07410e001e98b3849d';

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
String _$walletHash() => r'26f41c3cddf1b8b897d86ccd951ed0978754a578';

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
String _$employeesHash() => r'9f67f0e3670cb22795d410c34d5ca956e0b4e659';

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
String _$rewardPointsHash() => r'71434fdac40a6e12275781a52bbd322f313f7237';

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
String _$notificationsHash() => r'e409752365ec298f81a0a3f2e1fc14e1980366c4';

/// See also [notifications].
@ProviderFor(notifications)
final notificationsProvider =
    AutoDisposeProvider<List<NotificationItemEntity>>.internal(
  notifications,
  name: r'notificationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NotificationsRef = AutoDisposeProviderRef<List<NotificationItemEntity>>;
String _$supportTicketsHash() => r'b940c1c05c55b5f3e90418b303c624b4dea03ab9';

/// See also [supportTickets].
@ProviderFor(supportTickets)
final supportTicketsProvider =
    AutoDisposeProvider<List<SupportTicketEntity>>.internal(
  supportTickets,
  name: r'supportTicketsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$supportTicketsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SupportTicketsRef = AutoDisposeProviderRef<List<SupportTicketEntity>>;
String _$accountNotifierHash() => r'd9fb9013a638d2488f7126d026a4b68a03c029e6';

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
String _$securityNotifierHash() => r'4e360a01033d8c3184b326cbfc7125f1efb39541';

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
String _$settingsNotifierHash() => r'301d891d19fb51c1f1978932fcc78eb9c8ca6bb8';

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
