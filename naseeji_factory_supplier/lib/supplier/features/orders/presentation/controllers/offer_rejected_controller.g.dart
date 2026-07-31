// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_rejected_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$offerRejectedControllerHash() =>
    r'88bf1617a79b0f6dca0098b19eb0e75ae59f937b';

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

abstract class _$OfferRejectedController
    extends BuildlessAutoDisposeAsyncNotifier<OfferRejected> {
  late final String rfqId;

  FutureOr<OfferRejected> build(
    String rfqId,
  );
}

/// See also [OfferRejectedController].
@ProviderFor(OfferRejectedController)
const offerRejectedControllerProvider = OfferRejectedControllerFamily();

/// See also [OfferRejectedController].
class OfferRejectedControllerFamily extends Family<AsyncValue<OfferRejected>> {
  /// See also [OfferRejectedController].
  const OfferRejectedControllerFamily();

  /// See also [OfferRejectedController].
  OfferRejectedControllerProvider call(
    String rfqId,
  ) {
    return OfferRejectedControllerProvider(
      rfqId,
    );
  }

  @override
  OfferRejectedControllerProvider getProviderOverride(
    covariant OfferRejectedControllerProvider provider,
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
  String? get name => r'offerRejectedControllerProvider';
}

/// See also [OfferRejectedController].
class OfferRejectedControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<OfferRejectedController,
        OfferRejected> {
  /// See also [OfferRejectedController].
  OfferRejectedControllerProvider(
    String rfqId,
  ) : this._internal(
          () => OfferRejectedController()..rfqId = rfqId,
          from: offerRejectedControllerProvider,
          name: r'offerRejectedControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$offerRejectedControllerHash,
          dependencies: OfferRejectedControllerFamily._dependencies,
          allTransitiveDependencies:
              OfferRejectedControllerFamily._allTransitiveDependencies,
          rfqId: rfqId,
        );

  OfferRejectedControllerProvider._internal(
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
  FutureOr<OfferRejected> runNotifierBuild(
    covariant OfferRejectedController notifier,
  ) {
    return notifier.build(
      rfqId,
    );
  }

  @override
  Override overrideWith(OfferRejectedController Function() create) {
    return ProviderOverride(
      origin: this,
      override: OfferRejectedControllerProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<OfferRejectedController,
      OfferRejected> createElement() {
    return _OfferRejectedControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OfferRejectedControllerProvider && other.rfqId == rfqId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, rfqId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin OfferRejectedControllerRef
    on AutoDisposeAsyncNotifierProviderRef<OfferRejected> {
  /// The parameter `rfqId` of this provider.
  String get rfqId;
}

class _OfferRejectedControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<OfferRejectedController,
        OfferRejected> with OfferRejectedControllerRef {
  _OfferRejectedControllerProviderElement(super.provider);

  @override
  String get rfqId => (origin as OfferRejectedControllerProvider).rfqId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
