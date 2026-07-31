// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'production_preparation_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productionPreparationControllerHash() =>
    r'3372ece2513a5a078addb54f5b289c48001f3077';

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

abstract class _$ProductionPreparationController
    extends BuildlessAutoDisposeAsyncNotifier<ProductionPreparation> {
  late final String rfqId;

  FutureOr<ProductionPreparation> build(
    String rfqId,
  );
}

/// See also [ProductionPreparationController].
@ProviderFor(ProductionPreparationController)
const productionPreparationControllerProvider =
    ProductionPreparationControllerFamily();

/// See also [ProductionPreparationController].
class ProductionPreparationControllerFamily
    extends Family<AsyncValue<ProductionPreparation>> {
  /// See also [ProductionPreparationController].
  const ProductionPreparationControllerFamily();

  /// See also [ProductionPreparationController].
  ProductionPreparationControllerProvider call(
    String rfqId,
  ) {
    return ProductionPreparationControllerProvider(
      rfqId,
    );
  }

  @override
  ProductionPreparationControllerProvider getProviderOverride(
    covariant ProductionPreparationControllerProvider provider,
  ) {
    return call(
      provider.rfqId,
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
  String? get name => r'productionPreparationControllerProvider';
}

/// See also [ProductionPreparationController].
class ProductionPreparationControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<
        ProductionPreparationController, ProductionPreparation> {
  /// See also [ProductionPreparationController].
  ProductionPreparationControllerProvider(
    String rfqId,
  ) : this._internal(
          () => ProductionPreparationController()..rfqId = rfqId,
          from: productionPreparationControllerProvider,
          name: r'productionPreparationControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productionPreparationControllerHash,
          dependencies: ProductionPreparationControllerFamily._dependencies,
          allTransitiveDependencies:
              ProductionPreparationControllerFamily._allTransitiveDependencies,
          rfqId: rfqId,
        );

  ProductionPreparationControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.rfqId,
  }) : super.internal();

  final String rfqId;

  @override
  FutureOr<ProductionPreparation> runNotifierBuild(
    covariant ProductionPreparationController notifier,
  ) {
    return notifier.build(
      rfqId,
    );
  }

  @override
  Override overrideWith(ProductionPreparationController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProductionPreparationControllerProvider._internal(
        () => create()..rfqId = rfqId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        rfqId: rfqId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ProductionPreparationController,
      ProductionPreparation> createElement() {
    return _ProductionPreparationControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductionPreparationControllerProvider &&
        other.rfqId == rfqId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, rfqId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ProductionPreparationControllerRef
    on AutoDisposeAsyncNotifierProviderRef<ProductionPreparation> {
  /// The parameter `rfqId` of this provider.
  String get rfqId;
}

class _ProductionPreparationControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<
        ProductionPreparationController,
        ProductionPreparation> with ProductionPreparationControllerRef {
  _ProductionPreparationControllerProviderElement(super.provider);

  @override
  String get rfqId => (origin as ProductionPreparationControllerProvider).rfqId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member


