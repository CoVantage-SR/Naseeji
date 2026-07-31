// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documents_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$documentsHash() => r'eecb3cd0f909ea682b9fab06c8c99ba9738ee5d5';

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

/// See also [documents].
@ProviderFor(documents)
const documentsProvider = DocumentsFamily();

/// See also [documents].
class DocumentsFamily extends Family<AsyncValue<List<DocumentItem>>> {
  /// See also [documents].
  const DocumentsFamily();

  /// See also [documents].
  DocumentsProvider call({
    required String productId,
  }) {
    return DocumentsProvider(
      productId: productId,
    );
  }

  @override
  DocumentsProvider getProviderOverride(
    covariant DocumentsProvider provider,
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
  String? get name => r'documentsProvider';
}

/// See also [documents].
class DocumentsProvider extends AutoDisposeFutureProvider<List<DocumentItem>> {
  /// See also [documents].
  DocumentsProvider({
    required String productId,
  }) : this._internal(
          (ref) => documents(
            ref as DocumentsRef,
            productId: productId,
          ),
          from: documentsProvider,
          name: r'documentsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$documentsHash,
          dependencies: DocumentsFamily._dependencies,
          allTransitiveDependencies: DocumentsFamily._allTransitiveDependencies,
          productId: productId,
        );

  DocumentsProvider._internal(
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
    FutureOr<List<DocumentItem>> Function(DocumentsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DocumentsProvider._internal(
        (ref) => create(ref as DocumentsRef),
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
  AutoDisposeFutureProviderElement<List<DocumentItem>> createElement() {
    return _DocumentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DocumentsProvider && other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DocumentsRef on AutoDisposeFutureProviderRef<List<DocumentItem>> {
  /// The parameter `productId` of this provider.
  String get productId;
}

class _DocumentsProviderElement
    extends AutoDisposeFutureProviderElement<List<DocumentItem>>
    with DocumentsRef {
  _DocumentsProviderElement(super.provider);

  @override
  String get productId => (origin as DocumentsProvider).productId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

