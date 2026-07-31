// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'final_agreement_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$finalAgreementControllerHash() =>
    r'cdae166961de1cc88c9d78913b7fe1f6f962152c';

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

abstract class _$FinalAgreementController
    extends BuildlessAutoDisposeAsyncNotifier<FinalAgreement> {
  late final String rfqId;

  FutureOr<FinalAgreement> build(
    String rfqId,
  );
}

/// See also [FinalAgreementController].
@ProviderFor(FinalAgreementController)
const finalAgreementControllerProvider = FinalAgreementControllerFamily();

/// See also [FinalAgreementController].
class FinalAgreementControllerFamily
    extends Family<AsyncValue<FinalAgreement>> {
  /// See also [FinalAgreementController].
  const FinalAgreementControllerFamily();

  /// See also [FinalAgreementController].
  FinalAgreementControllerProvider call(
    String rfqId,
  ) {
    return FinalAgreementControllerProvider(
      rfqId,
    );
  }

  @override
  FinalAgreementControllerProvider getProviderOverride(
    covariant FinalAgreementControllerProvider provider,
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
  String? get name => r'finalAgreementControllerProvider';
}

/// See also [FinalAgreementController].
class FinalAgreementControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FinalAgreementController,
        FinalAgreement> {
  /// See also [FinalAgreementController].
  FinalAgreementControllerProvider(
    String rfqId,
  ) : this._internal(
          () => FinalAgreementController()..rfqId = rfqId,
          from: finalAgreementControllerProvider,
          name: r'finalAgreementControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$finalAgreementControllerHash,
          dependencies: FinalAgreementControllerFamily._dependencies,
          allTransitiveDependencies:
              FinalAgreementControllerFamily._allTransitiveDependencies,
          rfqId: rfqId,
        );

  FinalAgreementControllerProvider._internal(
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
  FutureOr<FinalAgreement> runNotifierBuild(
    covariant FinalAgreementController notifier,
  ) {
    return notifier.build(
      rfqId,
    );
  }

  @override
  Override overrideWith(FinalAgreementController Function() create) {
    return ProviderOverride(
      origin: this,
      override: FinalAgreementControllerProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<FinalAgreementController,
      FinalAgreement> createElement() {
    return _FinalAgreementControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FinalAgreementControllerProvider && other.rfqId == rfqId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, rfqId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FinalAgreementControllerRef
    on AutoDisposeAsyncNotifierProviderRef<FinalAgreement> {
  /// The parameter `rfqId` of this provider.
  String get rfqId;
}

class _FinalAgreementControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FinalAgreementController,
        FinalAgreement> with FinalAgreementControllerRef {
  _FinalAgreementControllerProviderElement(super.provider);

  @override
  String get rfqId => (origin as FinalAgreementControllerProvider).rfqId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member


