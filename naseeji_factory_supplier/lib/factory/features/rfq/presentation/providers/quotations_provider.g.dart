// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotations_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$quotationsNotifierHash() =>
    r'00677f605593257af85c8e2ffd1c7e08254ef895';

/// See also [QuotationsNotifier].
@ProviderFor(QuotationsNotifier)
final quotationsNotifierProvider =
    AutoDisposeNotifierProvider<QuotationsNotifier, List<Quotation>>.internal(
  QuotationsNotifier.new,
  name: r'quotationsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$quotationsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$QuotationsNotifier = AutoDisposeNotifier<List<Quotation>>;
String _$selectedQuotesComparisonHash() =>
    r'd1262794acb4dd82b3c9e79a6333bc53db1b6689';

/// See also [SelectedQuotesComparison].
@ProviderFor(SelectedQuotesComparison)
final selectedQuotesComparisonProvider = AutoDisposeNotifierProvider<
    SelectedQuotesComparison, List<String>>.internal(
  SelectedQuotesComparison.new,
  name: r'selectedQuotesComparisonProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedQuotesComparisonHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedQuotesComparison = AutoDisposeNotifier<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member


