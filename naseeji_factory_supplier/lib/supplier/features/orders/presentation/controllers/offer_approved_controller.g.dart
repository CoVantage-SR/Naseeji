// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_approved_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$offerApprovedControllerHash() =>
    r'fac84846b3cd001e6295bb590dd471802e8960f2';

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

abstract class _$OfferApprovedController
    extends BuildlessAutoDisposeAsyncNotifier<OfferApproved> {
  late final String rfqId;

  FutureOr<OfferApproved> build(
    String rfqId,
  );
}

/// See also [OfferApprovedController].
@ProviderFor(OfferApprovedController)
const offerApprovedControllerProvider = OfferApprovedControllerFamily();

/// See also [OfferApprovedController].
class OfferApprovedControllerFamily extends Family<AsyncValue<OfferApproved>> {
  /// See also [OfferApprovedController].
  const OfferApprovedControllerFamily();

  /// See also [OfferApprovedController].
  OfferApprovedControllerProvider call(
    String rfqId,
  ) {
    return OfferApprovedControllerProvider(
      rfqId,
    );
  }

  @override
  OfferApprovedControllerProvider getProviderOverride(
    covariant OfferApprovedControllerProvider provider,
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
  String? get name => r'offerApprovedControllerProvider';
}

/// See also [OfferApprovedController].
class OfferApprovedControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<OfferApprovedController,
        OfferApproved> {
  /// See also [OfferApprovedController].
  OfferApprovedControllerProvider(
    String rfqId,
  ) : this._internal(
          () => OfferApprovedController()..rfqId = rfqId,
          from: offerApprovedControllerProvider,
          name: r'offerApprovedControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$offerApprovedControllerHash,
          dependencies: OfferApprovedControllerFamily._dependencies,
          allTransitiveDependencies:
              OfferApprovedControllerFamily._allTransitiveDependencies,
          rfqId: rfqId,
        );

  OfferApprovedControllerProvider._internal(
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
  FutureOr<OfferApproved> runNotifierBuild(
    covariant OfferApprovedController notifier,
  ) {
    return notifier.build(
      rfqId,
    );
  }

  @override
  Override overrideWith(OfferApprovedController Function() create) {
    return ProviderOverride(
      origin: this,
      override: OfferApprovedControllerProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<OfferApprovedController,
      OfferApproved> createElement() {
    return _OfferApprovedControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OfferApprovedControllerProvider && other.rfqId == rfqId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, rfqId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin OfferApprovedControllerRef
    on AutoDisposeAsyncNotifierProviderRef<OfferApproved> {
  /// The parameter `rfqId` of this provider.
  String get rfqId;
}

class _OfferApprovedControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<OfferApprovedController,
        OfferApproved> with OfferApprovedControllerRef {
  _OfferApprovedControllerProviderElement(super.provider);

  @override
  String get rfqId => (origin as OfferApprovedControllerProvider).rfqId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
