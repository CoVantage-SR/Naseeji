// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reviews_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reviewsHash() => r'3e5068cf518bc19d27f65d9a05c57567f10e57b6';

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

/// See also [reviews].
@ProviderFor(reviews)
const reviewsProvider = ReviewsFamily();

/// See also [reviews].
class ReviewsFamily extends Family<AsyncValue<List<ProductReview>>> {
  /// See also [reviews].
  const ReviewsFamily();

  /// See also [reviews].
  ReviewsProvider call({
    required String productId,
  }) {
    return ReviewsProvider(
      productId: productId,
    );
  }

  @override
  ReviewsProvider getProviderOverride(
    covariant ReviewsProvider provider,
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
  String? get name => r'reviewsProvider';
}

/// See also [reviews].
class ReviewsProvider extends AutoDisposeFutureProvider<List<ProductReview>> {
  /// See also [reviews].
  ReviewsProvider({
    required String productId,
  }) : this._internal(
          (ref) => reviews(
            ref as ReviewsRef,
            productId: productId,
          ),
          from: reviewsProvider,
          name: r'reviewsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$reviewsHash,
          dependencies: ReviewsFamily._dependencies,
          allTransitiveDependencies: ReviewsFamily._allTransitiveDependencies,
          productId: productId,
        );

  ReviewsProvider._internal(
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
    FutureOr<List<ProductReview>> Function(ReviewsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReviewsProvider._internal(
        (ref) => create(ref as ReviewsRef),
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
  AutoDisposeFutureProviderElement<List<ProductReview>> createElement() {
    return _ReviewsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReviewsProvider && other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ReviewsRef on AutoDisposeFutureProviderRef<List<ProductReview>> {
  /// The parameter `productId` of this provider.
  String get productId;
}

class _ReviewsProviderElement
    extends AutoDisposeFutureProviderElement<List<ProductReview>>
    with ReviewsRef {
  _ReviewsProviderElement(super.provider);

  @override
  String get productId => (origin as ReviewsProvider).productId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

