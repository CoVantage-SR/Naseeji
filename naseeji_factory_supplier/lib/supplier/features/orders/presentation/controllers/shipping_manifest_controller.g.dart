// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_manifest_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$shippingManifestControllerHash() =>
    r'1b0a86554acb21f3876a17287f5c64c0045fc840';

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

abstract class _$ShippingManifestController
    extends BuildlessAutoDisposeAsyncNotifier<ShippingManifest> {
  late final String rfqId;

  FutureOr<ShippingManifest> build(String rfqId);
}

/// See also [ShippingManifestController].
@ProviderFor(ShippingManifestController)
const shippingManifestControllerProvider = ShippingManifestControllerFamily();

/// See also [ShippingManifestController].
class ShippingManifestControllerFamily
    extends Family<AsyncValue<ShippingManifest>> {
  /// See also [ShippingManifestController].
  const ShippingManifestControllerFamily();

  /// See also [ShippingManifestController].
  ShippingManifestControllerProvider call(String rfqId) {
    return ShippingManifestControllerProvider(rfqId);
  }

  @override
  ShippingManifestControllerProvider getProviderOverride(
    covariant ShippingManifestControllerProvider provider,
  ) {
    return call(provider.rfqId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'shippingManifestControllerProvider';
}

/// See also [ShippingManifestController].
class ShippingManifestControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          ShippingManifestController,
          ShippingManifest
        > {
  /// See also [ShippingManifestController].
  ShippingManifestControllerProvider(String rfqId)
    : this._internal(
        () => ShippingManifestController()..rfqId = rfqId,
        from: shippingManifestControllerProvider,
        name: r'shippingManifestControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$shippingManifestControllerHash,
        dependencies: ShippingManifestControllerFamily._dependencies,
        allTransitiveDependencies:
            ShippingManifestControllerFamily._allTransitiveDependencies,
        rfqId: rfqId,
      );

  ShippingManifestControllerProvider._internal(
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
  FutureOr<ShippingManifest> runNotifierBuild(
    covariant ShippingManifestController notifier,
  ) {
    return notifier.build(rfqId);
  }

  @override
  Override overrideWith(ShippingManifestController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ShippingManifestControllerProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<
    ShippingManifestController,
    ShippingManifest
  >
  createElement() {
    return _ShippingManifestControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ShippingManifestControllerProvider && other.rfqId == rfqId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, rfqId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ShippingManifestControllerRef
    on AutoDisposeAsyncNotifierProviderRef<ShippingManifest> {
  /// The parameter `rfqId` of this provider.
  String get rfqId;
}

class _ShippingManifestControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          ShippingManifestController,
          ShippingManifest
        >
    with ShippingManifestControllerRef {
  _ShippingManifestControllerProviderElement(super.provider);

  @override
  String get rfqId => (origin as ShippingManifestControllerProvider).rfqId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
