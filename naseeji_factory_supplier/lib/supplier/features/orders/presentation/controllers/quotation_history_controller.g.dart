// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotation_history_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$quotationHistoryControllerHash() =>
    r'585e389a7244cafd8d33fc95b494642f22edcb8e';

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

abstract class _$QuotationHistoryController
    extends BuildlessAutoDisposeAsyncNotifier<List<QuotationRevision>> {
  late final String rfqId;

  FutureOr<List<QuotationRevision>> build(String rfqId);
}

/// See also [QuotationHistoryController].
@ProviderFor(QuotationHistoryController)
const quotationHistoryControllerProvider = QuotationHistoryControllerFamily();

/// See also [QuotationHistoryController].
class QuotationHistoryControllerFamily
    extends Family<AsyncValue<List<QuotationRevision>>> {
  /// See also [QuotationHistoryController].
  const QuotationHistoryControllerFamily();

  /// See also [QuotationHistoryController].
  QuotationHistoryControllerProvider call(String rfqId) {
    return QuotationHistoryControllerProvider(rfqId);
  }

  @override
  QuotationHistoryControllerProvider getProviderOverride(
    covariant QuotationHistoryControllerProvider provider,
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
  String? get name => r'quotationHistoryControllerProvider';
}

/// See also [QuotationHistoryController].
class QuotationHistoryControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          QuotationHistoryController,
          List<QuotationRevision>
        > {
  /// See also [QuotationHistoryController].
  QuotationHistoryControllerProvider(String rfqId)
    : this._internal(
        () => QuotationHistoryController()..rfqId = rfqId,
        from: quotationHistoryControllerProvider,
        name: r'quotationHistoryControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$quotationHistoryControllerHash,
        dependencies: QuotationHistoryControllerFamily._dependencies,
        allTransitiveDependencies:
            QuotationHistoryControllerFamily._allTransitiveDependencies,
        rfqId: rfqId,
      );

  QuotationHistoryControllerProvider._internal(
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
  FutureOr<List<QuotationRevision>> runNotifierBuild(
    covariant QuotationHistoryController notifier,
  ) {
    return notifier.build(rfqId);
  }

  @override
  Override overrideWith(QuotationHistoryController Function() create) {
    return ProviderOverride(
      origin: this,
      override: QuotationHistoryControllerProvider._internal(
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
    QuotationHistoryController,
    List<QuotationRevision>
  >
  createElement() {
    return _QuotationHistoryControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuotationHistoryControllerProvider && other.rfqId == rfqId;
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
mixin QuotationHistoryControllerRef
    on AutoDisposeAsyncNotifierProviderRef<List<QuotationRevision>> {
  /// The parameter `rfqId` of this provider.
  String get rfqId;
}

class _QuotationHistoryControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          QuotationHistoryController,
          List<QuotationRevision>
        >
    with QuotationHistoryControllerRef {
  _QuotationHistoryControllerProviderElement(super.provider);

  @override
  String get rfqId => (origin as QuotationHistoryControllerProvider).rfqId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

