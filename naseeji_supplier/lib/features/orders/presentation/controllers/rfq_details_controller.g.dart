// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rfq_details_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$rfqDetailsControllerHash() =>
    r'622f28880ec64f3f408e18e33fa5d120343c05cb';

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

abstract class _$RfqDetailsController
    extends BuildlessAutoDisposeAsyncNotifier<RfqDetails> {
  late final String rfqId;

  FutureOr<RfqDetails> build(String rfqId);
}

/// See also [RfqDetailsController].
@ProviderFor(RfqDetailsController)
const rfqDetailsControllerProvider = RfqDetailsControllerFamily();

/// See also [RfqDetailsController].
class RfqDetailsControllerFamily extends Family<AsyncValue<RfqDetails>> {
  /// See also [RfqDetailsController].
  const RfqDetailsControllerFamily();

  /// See also [RfqDetailsController].
  RfqDetailsControllerProvider call(String rfqId) {
    return RfqDetailsControllerProvider(rfqId);
  }

  @override
  RfqDetailsControllerProvider getProviderOverride(
    covariant RfqDetailsControllerProvider provider,
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
  String? get name => r'rfqDetailsControllerProvider';
}

/// See also [RfqDetailsController].
class RfqDetailsControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<RfqDetailsController, RfqDetails> {
  /// See also [RfqDetailsController].
  RfqDetailsControllerProvider(String rfqId)
    : this._internal(
        () => RfqDetailsController()..rfqId = rfqId,
        from: rfqDetailsControllerProvider,
        name: r'rfqDetailsControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$rfqDetailsControllerHash,
        dependencies: RfqDetailsControllerFamily._dependencies,
        allTransitiveDependencies:
            RfqDetailsControllerFamily._allTransitiveDependencies,
        rfqId: rfqId,
      );

  RfqDetailsControllerProvider._internal(
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
  FutureOr<RfqDetails> runNotifierBuild(
    covariant RfqDetailsController notifier,
  ) {
    return notifier.build(rfqId);
  }

  @override
  Override overrideWith(RfqDetailsController Function() create) {
    return ProviderOverride(
      origin: this,
      override: RfqDetailsControllerProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<RfqDetailsController, RfqDetails>
  createElement() {
    return _RfqDetailsControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RfqDetailsControllerProvider && other.rfqId == rfqId;
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
mixin RfqDetailsControllerRef
    on AutoDisposeAsyncNotifierProviderRef<RfqDetails> {
  /// The parameter `rfqId` of this provider.
  String get rfqId;
}

class _RfqDetailsControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          RfqDetailsController,
          RfqDetails
        >
    with RfqDetailsControllerRef {
  _RfqDetailsControllerProviderElement(super.provider);

  @override
  String get rfqId => (origin as RfqDetailsControllerProvider).rfqId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
