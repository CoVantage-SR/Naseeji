// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'production_capacity_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productionCapacityHash() =>
    r'25e30e231c95dd2ec25dfd5e599c19b33f030c3b';

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

/// See also [productionCapacity].
@ProviderFor(productionCapacity)
const productionCapacityProvider = ProductionCapacityFamily();

/// See also [productionCapacity].
class ProductionCapacityFamily extends Family<AsyncValue<ProductionCapacity>> {
  /// See also [productionCapacity].
  const ProductionCapacityFamily();

  /// See also [productionCapacity].
  ProductionCapacityProvider call({
    required String productId,
  }) {
    return ProductionCapacityProvider(
      productId: productId,
    );
  }

  @override
  ProductionCapacityProvider getProviderOverride(
    covariant ProductionCapacityProvider provider,
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
  String? get name => r'productionCapacityProvider';
}

/// See also [productionCapacity].
class ProductionCapacityProvider
    extends AutoDisposeFutureProvider<ProductionCapacity> {
  /// See also [productionCapacity].
  ProductionCapacityProvider({
    required String productId,
  }) : this._internal(
          (ref) => productionCapacity(
            ref as ProductionCapacityRef,
            productId: productId,
          ),
          from: productionCapacityProvider,
          name: r'productionCapacityProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productionCapacityHash,
          dependencies: ProductionCapacityFamily._dependencies,
          allTransitiveDependencies:
              ProductionCapacityFamily._allTransitiveDependencies,
          productId: productId,
        );

  ProductionCapacityProvider._internal(
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
    FutureOr<ProductionCapacity> Function(ProductionCapacityRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductionCapacityProvider._internal(
        (ref) => create(ref as ProductionCapacityRef),
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
  AutoDisposeFutureProviderElement<ProductionCapacity> createElement() {
    return _ProductionCapacityProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductionCapacityProvider && other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ProductionCapacityRef
    on AutoDisposeFutureProviderRef<ProductionCapacity> {
  /// The parameter `productId` of this provider.
  String get productId;
}

class _ProductionCapacityProviderElement
    extends AutoDisposeFutureProviderElement<ProductionCapacity>
    with ProductionCapacityRef {
  _ProductionCapacityProviderElement(super.provider);

  @override
  String get productId => (origin as ProductionCapacityProvider).productId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
