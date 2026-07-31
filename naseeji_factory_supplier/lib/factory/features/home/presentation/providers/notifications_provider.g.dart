// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedNotificationCategoryHash() =>
    r'3d1d3f8a06b274dcacb9d577007655b871269556';

/// See also [selectedNotificationCategory].
@ProviderFor(selectedNotificationCategory)
final selectedNotificationCategoryProvider =
    AutoDisposeProvider<String>.internal(
  selectedNotificationCategory,
  name: r'selectedNotificationCategoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedNotificationCategoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SelectedNotificationCategoryRef = AutoDisposeProviderRef<String>;
String _$notificationsNotifierHash() =>
    r'4212c58833915ce375e2790cd77910ace7a0ae8e';

/// See also [NotificationsNotifier].
@ProviderFor(NotificationsNotifier)
final notificationsNotifierProvider = AutoDisposeNotifierProvider<
    NotificationsNotifier, List<AppNotification>>.internal(
  NotificationsNotifier.new,
  name: r'notificationsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationsNotifier = AutoDisposeNotifier<List<AppNotification>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

