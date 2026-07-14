// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comparison_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$priceQuotationsHash() => r'f236648eea7c4433ea87c25726adba4f0423affa';

/// See also [priceQuotations].
@ProviderFor(priceQuotations)
final priceQuotationsProvider =
    AutoDisposeProvider<List<PriceQuotation>>.internal(
  priceQuotations,
  name: r'priceQuotationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$priceQuotationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PriceQuotationsRef = AutoDisposeProviderRef<List<PriceQuotation>>;
String _$deliveryComparisonItemsHash() =>
    r'9164925164c3efb04f864268333ef82adbe818ee';

/// See also [deliveryComparisonItems].
@ProviderFor(deliveryComparisonItems)
final deliveryComparisonItemsProvider =
    AutoDisposeProvider<List<DeliveryComparisonItem>>.internal(
  deliveryComparisonItems,
  name: r'deliveryComparisonItemsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$deliveryComparisonItemsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DeliveryComparisonItemsRef
    = AutoDisposeProviderRef<List<DeliveryComparisonItem>>;
String _$comparisonNotifierHash() =>
    r'52c96a4bfe78fe13eca311137d7ba08943b536c0';

/// See also [ComparisonNotifier].
@ProviderFor(ComparisonNotifier)
final comparisonNotifierProvider =
    AutoDisposeNotifierProvider<ComparisonNotifier, List<String>>.internal(
  ComparisonNotifier.new,
  name: r'comparisonNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$comparisonNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ComparisonNotifier = AutoDisposeNotifier<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
