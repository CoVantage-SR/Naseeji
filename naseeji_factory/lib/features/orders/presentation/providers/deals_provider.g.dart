// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deals_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredDealsHash() => r'0abefec6bfa13554ca11f4960eec69257d342e84';

/// See also [filteredDeals].
@ProviderFor(filteredDeals)
final filteredDealsProvider = AutoDisposeProvider<List<DealModel>>.internal(
  filteredDeals,
  name: r'filteredDealsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredDealsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FilteredDealsRef = AutoDisposeProviderRef<List<DealModel>>;
String _$dealsSummaryHash() => r'807dde98ecc37e99f2bac974ddc2363fe2756d7c';

/// See also [dealsSummary].
@ProviderFor(dealsSummary)
final dealsSummaryProvider = AutoDisposeProvider<DealsSummary>.internal(
  dealsSummary,
  name: r'dealsSummaryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dealsSummaryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DealsSummaryRef = AutoDisposeProviderRef<DealsSummary>;
String _$dealsNotifierHash() => r'005d20337e83aca8c9ecc8adc6f37ff5e2fe219e';

/// See also [DealsNotifier].
@ProviderFor(DealsNotifier)
final dealsNotifierProvider =
    AutoDisposeNotifierProvider<DealsNotifier, List<DealModel>>.internal(
  DealsNotifier.new,
  name: r'dealsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dealsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DealsNotifier = AutoDisposeNotifier<List<DealModel>>;
String _$dealsFilterNotifierHash() =>
    r'baf08651bac79efc13f986973d7462360802b24b';

/// See also [DealsFilterNotifier].
@ProviderFor(DealsFilterNotifier)
final dealsFilterNotifierProvider =
    AutoDisposeNotifierProvider<DealsFilterNotifier, String>.internal(
  DealsFilterNotifier.new,
  name: r'dealsFilterNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dealsFilterNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DealsFilterNotifier = AutoDisposeNotifier<String>;
String _$dealsSearchNotifierHash() =>
    r'30038bc13a2da8d6806893d76fb3303e9be2e6f1';

/// See also [DealsSearchNotifier].
@ProviderFor(DealsSearchNotifier)
final dealsSearchNotifierProvider =
    AutoDisposeNotifierProvider<DealsSearchNotifier, String>.internal(
  DealsSearchNotifier.new,
  name: r'dealsSearchNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dealsSearchNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DealsSearchNotifier = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
