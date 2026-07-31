// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'procurement_timeline_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$procurementTimelineHash() =>
    r'b5a26ac28d9543af30e9f2d7c05efd40521ff60e';

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

/// See also [procurementTimeline].
@ProviderFor(procurementTimeline)
const procurementTimelineProvider = ProcurementTimelineFamily();

/// See also [procurementTimeline].
class ProcurementTimelineFamily
    extends Family<AsyncValue<List<ProcurementStage>>> {
  /// See also [procurementTimeline].
  const ProcurementTimelineFamily();

  /// See also [procurementTimeline].
  ProcurementTimelineProvider call({
    required String productId,
  }) {
    return ProcurementTimelineProvider(
      productId: productId,
    );
  }

  @override
  ProcurementTimelineProvider getProviderOverride(
    covariant ProcurementTimelineProvider provider,
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
  String? get name => r'procurementTimelineProvider';
}

/// See also [procurementTimeline].
class ProcurementTimelineProvider
    extends AutoDisposeFutureProvider<List<ProcurementStage>> {
  /// See also [procurementTimeline].
  ProcurementTimelineProvider({
    required String productId,
  }) : this._internal(
          (ref) => procurementTimeline(
            ref as ProcurementTimelineRef,
            productId: productId,
          ),
          from: procurementTimelineProvider,
          name: r'procurementTimelineProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$procurementTimelineHash,
          dependencies: ProcurementTimelineFamily._dependencies,
          allTransitiveDependencies:
              ProcurementTimelineFamily._allTransitiveDependencies,
          productId: productId,
        );

  ProcurementTimelineProvider._internal(
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
    FutureOr<List<ProcurementStage>> Function(ProcurementTimelineRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProcurementTimelineProvider._internal(
        (ref) => create(ref as ProcurementTimelineRef),
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
  AutoDisposeFutureProviderElement<List<ProcurementStage>> createElement() {
    return _ProcurementTimelineProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProcurementTimelineProvider && other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ProcurementTimelineRef
    on AutoDisposeFutureProviderRef<List<ProcurementStage>> {
  /// The parameter `productId` of this provider.
  String get productId;
}

class _ProcurementTimelineProviderElement
    extends AutoDisposeFutureProviderElement<List<ProcurementStage>>
    with ProcurementTimelineRef {
  _ProcurementTimelineProviderElement(super.provider);

  @override
  String get productId => (origin as ProcurementTimelineProvider).productId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

