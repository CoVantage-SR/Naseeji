// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_details_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$offerDetailsControllerHash() =>
    r'82ab3da3bb94c3ff4312ce5d424ce7e5d0ef77d3';

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

abstract class _$OfferDetailsController
    extends BuildlessAutoDisposeAsyncNotifier<OfferDetails> {
  late final String rfqId;

  FutureOr<OfferDetails> build(
    String rfqId,
  );
}

/// See also [OfferDetailsController].
@ProviderFor(OfferDetailsController)
const offerDetailsControllerProvider = OfferDetailsControllerFamily();

/// See also [OfferDetailsController].
class OfferDetailsControllerFamily extends Family<AsyncValue<OfferDetails>> {
  /// See also [OfferDetailsController].
  const OfferDetailsControllerFamily();

  /// See also [OfferDetailsController].
  OfferDetailsControllerProvider call(
    String rfqId,
  ) {
    return OfferDetailsControllerProvider(
      rfqId,
    );
  }

  @override
  OfferDetailsControllerProvider getProviderOverride(
    covariant OfferDetailsControllerProvider provider,
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
  String? get name => r'offerDetailsControllerProvider';
}

/// See also [OfferDetailsController].
class OfferDetailsControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<OfferDetailsController,
        OfferDetails> {
  /// See also [OfferDetailsController].
  OfferDetailsControllerProvider(
    String rfqId,
  ) : this._internal(
          () => OfferDetailsController()..rfqId = rfqId,
          from: offerDetailsControllerProvider,
          name: r'offerDetailsControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$offerDetailsControllerHash,
          dependencies: OfferDetailsControllerFamily._dependencies,
          allTransitiveDependencies:
              OfferDetailsControllerFamily._allTransitiveDependencies,
          rfqId: rfqId,
        );

  OfferDetailsControllerProvider._internal(
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
  FutureOr<OfferDetails> runNotifierBuild(
    covariant OfferDetailsController notifier,
  ) {
    return notifier.build(
      rfqId,
    );
  }

  @override
  Override overrideWith(OfferDetailsController Function() create) {
    return ProviderOverride(
      origin: this,
      override: OfferDetailsControllerProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<OfferDetailsController, OfferDetails>
      createElement() {
    return _OfferDetailsControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OfferDetailsControllerProvider && other.rfqId == rfqId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, rfqId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin OfferDetailsControllerRef
    on AutoDisposeAsyncNotifierProviderRef<OfferDetails> {
  /// The parameter `rfqId` of this provider.
  String get rfqId;
}

class _OfferDetailsControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<OfferDetailsController,
        OfferDetails> with OfferDetailsControllerRef {
  _OfferDetailsControllerProviderElement(super.provider);

  @override
  String get rfqId => (origin as OfferDetailsControllerProvider).rfqId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

