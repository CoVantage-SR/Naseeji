// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulk_pricing_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bulkPricingHash() => r'3fca66b82c00a2e3da07b5ec48c344bfcb94ff54';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [bulkPricing].
@ProviderFor(bulkPricing)
const bulkPricingProvider = BulkPricingFamily();

/// See also [bulkPricing].
class BulkPricingFamily extends Family<AsyncValue<List<BulkPricingTier>>> {
  /// See also [bulkPricing].
  const BulkPricingFamily();

  /// See also [bulkPricing].
  BulkPricingProvider call({
    required String productId,
  }) {
    return BulkPricingProvider(
      productId: productId,
    );
  }

  @override
  BulkPricingProvider getProviderOverride(
    covariant BulkPricingProvider provider,
  ) {
    return call(
      productId: provider.productId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'bulkPricingProvider';
}

/// See also [bulkPricing].
class BulkPricingProvider
    extends AutoDisposeFutureProvider<List<BulkPricingTier>> {
  /// See also [bulkPricing].
  BulkPricingProvider({
    required String productId,
  }) : this._internal(
          (ref) => bulkPricing(
            ref as BulkPricingRef,
            productId: productId,
          ),
          from: bulkPricingProvider,
          name: r'bulkPricingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bulkPricingHash,
          dependencies: BulkPricingFamily._dependencies,
          allTransitiveDependencies:
              BulkPricingFamily._allTransitiveDependencies,
          productId: productId,
        );

  BulkPricingProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.productId,
  }) : super.internal();

  final String productId;

  @override
  Override overrideWith(
    FutureOr<List<BulkPricingTier>> Function(BulkPricingRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BulkPricingProvider._internal(
        (ref) => create(ref as BulkPricingRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        productId: productId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<BulkPricingTier>> createElement() {
    return _BulkPricingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BulkPricingProvider && other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin BulkPricingRef on AutoDisposeFutureProviderRef<List<BulkPricingTier>> {
  /// The parameter `productId` of this provider.
  String get productId;
}

class _BulkPricingProviderElement
    extends AutoDisposeFutureProviderElement<List<BulkPricingTier>>
    with BulkPricingRef {
  _BulkPricingProviderElement(super.provider);

  @override
  String get productId => (origin as BulkPricingProvider).productId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
