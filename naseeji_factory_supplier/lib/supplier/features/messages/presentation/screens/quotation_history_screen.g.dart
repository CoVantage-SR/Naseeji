// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotation_history_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$quotationHistoryHash() => r'632130de95208eaa3724a6f1d7bb0e5d243b0a9a';

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

/// See also [quotationHistory].
@ProviderFor(quotationHistory)
const quotationHistoryProvider = QuotationHistoryFamily();

/// See also [quotationHistory].
class QuotationHistoryFamily extends Family<AsyncValue<List<BusinessMessage>>> {
  /// See also [quotationHistory].
  const QuotationHistoryFamily();

  /// See also [quotationHistory].
  QuotationHistoryProvider call(
    String conversationId,
  ) {
    return QuotationHistoryProvider(
      conversationId,
    );
  }

  @override
  QuotationHistoryProvider getProviderOverride(
    covariant QuotationHistoryProvider provider,
  ) {
    return call(
      provider.conversationId,
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
  String? get name => r'quotationHistoryProvider';
}

/// See also [quotationHistory].
class QuotationHistoryProvider
    extends AutoDisposeFutureProvider<List<BusinessMessage>> {
  /// See also [quotationHistory].
  QuotationHistoryProvider(
    String conversationId,
  ) : this._internal(
          (ref) => quotationHistory(
            ref as QuotationHistoryRef,
            conversationId,
          ),
          from: quotationHistoryProvider,
          name: r'quotationHistoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$quotationHistoryHash,
          dependencies: QuotationHistoryFamily._dependencies,
          allTransitiveDependencies:
              QuotationHistoryFamily._allTransitiveDependencies,
          conversationId: conversationId,
        );

  QuotationHistoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.conversationId,
  }) : super.internal();

  final String conversationId;

  @override
  Override overrideWith(
    FutureOr<List<BusinessMessage>> Function(QuotationHistoryRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: QuotationHistoryProvider._internal(
        (ref) => create(ref as QuotationHistoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        conversationId: conversationId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<BusinessMessage>> createElement() {
    return _QuotationHistoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuotationHistoryProvider &&
        other.conversationId == conversationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, conversationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin QuotationHistoryRef
    on AutoDisposeFutureProviderRef<List<BusinessMessage>> {
  /// The parameter `conversationId` of this provider.
  String get conversationId;
}

class _QuotationHistoryProviderElement
    extends AutoDisposeFutureProviderElement<List<BusinessMessage>>
    with QuotationHistoryRef {
  _QuotationHistoryProviderElement(super.provider);

  @override
  String get conversationId =>
      (origin as QuotationHistoryProvider).conversationId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member


