// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sampleInfoHash() => r'4f99fc2af8f758c35988b876689d6c273f76bda7';

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

/// See also [sampleInfo].
@ProviderFor(sampleInfo)
const sampleInfoProvider = SampleInfoFamily();

/// See also [sampleInfo].
class SampleInfoFamily extends Family<AsyncValue<SampleInfo>> {
  /// See also [sampleInfo].
  const SampleInfoFamily();

  /// See also [sampleInfo].
  SampleInfoProvider call({
    required String productId,
  }) {
    return SampleInfoProvider(
      productId: productId,
    );
  }

  @override
  SampleInfoProvider getProviderOverride(
    covariant SampleInfoProvider provider,
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
  String? get name => r'sampleInfoProvider';
}

/// See also [sampleInfo].
class SampleInfoProvider extends AutoDisposeFutureProvider<SampleInfo> {
  /// See also [sampleInfo].
  SampleInfoProvider({
    required String productId,
  }) : this._internal(
          (ref) => sampleInfo(
            ref as SampleInfoRef,
            productId: productId,
          ),
          from: sampleInfoProvider,
          name: r'sampleInfoProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sampleInfoHash,
          dependencies: SampleInfoFamily._dependencies,
          allTransitiveDependencies:
              SampleInfoFamily._allTransitiveDependencies,
          productId: productId,
        );

  SampleInfoProvider._internal(
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
    FutureOr<SampleInfo> Function(SampleInfoRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SampleInfoProvider._internal(
        (ref) => create(ref as SampleInfoRef),
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
  AutoDisposeFutureProviderElement<SampleInfo> createElement() {
    return _SampleInfoProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SampleInfoProvider && other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SampleInfoRef on AutoDisposeFutureProviderRef<SampleInfo> {
  /// The parameter `productId` of this provider.
  String get productId;
}

class _SampleInfoProviderElement
    extends AutoDisposeFutureProviderElement<SampleInfo> with SampleInfoRef {
  _SampleInfoProviderElement(super.provider);

  @override
  String get productId => (origin as SampleInfoProvider).productId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
