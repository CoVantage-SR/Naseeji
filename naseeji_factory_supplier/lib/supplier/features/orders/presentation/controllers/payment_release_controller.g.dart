// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_release_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$paymentReleaseControllerHash() =>
    r'cbdb4a7f4ca6da8376d83e0a94ba3ddfe2981ee9';

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

abstract class _$PaymentReleaseController
    extends BuildlessAutoDisposeAsyncNotifier<PaymentRelease> {
  late final String rfqId;

  FutureOr<PaymentRelease> build(String rfqId);
}

/// See also [PaymentReleaseController].
@ProviderFor(PaymentReleaseController)
const paymentReleaseControllerProvider = PaymentReleaseControllerFamily();

/// See also [PaymentReleaseController].
class PaymentReleaseControllerFamily
    extends Family<AsyncValue<PaymentRelease>> {
  /// See also [PaymentReleaseController].
  const PaymentReleaseControllerFamily();

  /// See also [PaymentReleaseController].
  PaymentReleaseControllerProvider call(String rfqId) {
    return PaymentReleaseControllerProvider(rfqId);
  }

  @override
  PaymentReleaseControllerProvider getProviderOverride(
    covariant PaymentReleaseControllerProvider provider,
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
  String? get name => r'paymentReleaseControllerProvider';
}

/// See also [PaymentReleaseController].
class PaymentReleaseControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          PaymentReleaseController,
          PaymentRelease
        > {
  /// See also [PaymentReleaseController].
  PaymentReleaseControllerProvider(String rfqId)
    : this._internal(
        () => PaymentReleaseController()..rfqId = rfqId,
        from: paymentReleaseControllerProvider,
        name: r'paymentReleaseControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$paymentReleaseControllerHash,
        dependencies: PaymentReleaseControllerFamily._dependencies,
        allTransitiveDependencies:
            PaymentReleaseControllerFamily._allTransitiveDependencies,
        rfqId: rfqId,
      );

  PaymentReleaseControllerProvider._internal(
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
  FutureOr<PaymentRelease> runNotifierBuild(
    covariant PaymentReleaseController notifier,
  ) {
    return notifier.build(rfqId);
  }

  @override
  Override overrideWith(PaymentReleaseController Function() create) {
    return ProviderOverride(
      origin: this,
      override: PaymentReleaseControllerProvider._internal(
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
    PaymentReleaseController,
    PaymentRelease
  >
  createElement() {
    return _PaymentReleaseControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PaymentReleaseControllerProvider && other.rfqId == rfqId;
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
mixin PaymentReleaseControllerRef
    on AutoDisposeAsyncNotifierProviderRef<PaymentRelease> {
  /// The parameter `rfqId` of this provider.
  String get rfqId;
}

class _PaymentReleaseControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          PaymentReleaseController,
          PaymentRelease
        >
    with PaymentReleaseControllerRef {
  _PaymentReleaseControllerProviderElement(super.provider);

  @override
  String get rfqId => (origin as PaymentReleaseControllerProvider).rfqId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
