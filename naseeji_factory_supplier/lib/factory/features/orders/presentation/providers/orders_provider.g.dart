// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ordersNotifierHash() => r'a9a457fdbeb74aaa3d3b5fa9c790f81c941d8f1f';

/// See also [OrdersNotifier].
@ProviderFor(OrdersNotifier)
final ordersNotifierProvider =
    AutoDisposeNotifierProvider<OrdersNotifier, List<OrderModel>>.internal(
  OrdersNotifier.new,
  name: r'ordersNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ordersNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OrdersNotifier = AutoDisposeNotifier<List<OrderModel>>;
String _$timelineNotifierHash() => r'5d5d72d3566e734b5fde3641cb3114c982e90ebf';

/// See also [TimelineNotifier].
@ProviderFor(TimelineNotifier)
final timelineNotifierProvider = AutoDisposeNotifierProvider<TimelineNotifier,
    Map<String, List<OrderTimelineItem>>>.internal(
  TimelineNotifier.new,
  name: r'timelineNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$timelineNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TimelineNotifier
    = AutoDisposeNotifier<Map<String, List<OrderTimelineItem>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

