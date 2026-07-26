import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product_model.dart';
import '../../domain/entities/product_subscription_limit_model.dart';
import 'products_providers.dart';
import 'package:naseeji_supplier/core/mock/mock_data.dart';
import 'package:naseeji_supplier/core/mock/deal_mock.dart';

class ProductDetailsState {
  final ProductModel? product;
  final ProductSubscriptionLimitModel? subscriptionLimits;
  final List<DealMock> relatedDeals;
  final bool isSubscriptionExpired;
  final bool isLoading;
  final String? error;

  const ProductDetailsState({
    this.product,
    this.subscriptionLimits,
    this.relatedDeals = const [],
    this.isSubscriptionExpired = false,
    this.isLoading = true,
    this.error,
  });

  ProductDetailsState copyWith({
    ProductModel? product,
    ProductSubscriptionLimitModel? subscriptionLimits,
    List<DealMock>? relatedDeals,
    bool? isSubscriptionExpired,
    bool? isLoading,
    String? error,
  }) {
    return ProductDetailsState(
      product: product ?? this.product,
      subscriptionLimits: subscriptionLimits ?? this.subscriptionLimits,
      relatedDeals: relatedDeals ?? this.relatedDeals,
      isSubscriptionExpired: isSubscriptionExpired ?? this.isSubscriptionExpired,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ProductDetailsNotifier extends StateNotifier<ProductDetailsState> {
  final Ref ref;
  final String productId;

  ProductDetailsNotifier(this.ref, this.productId) : super(const ProductDetailsState()) {
    loadDetails();
  }

  Future<void> loadDetails() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = ref.read(productsRepositoryImplProvider);
      final product = await repo.getProductDetails(productId);
      final limits = await repo.getSubscriptionLimits();

      // Check subscription status from MockDatabase
      final currentSub = MockDatabase.getCurrentSubscription();
      final isExpired = currentSub.isExpired;

      // Related deals for this product
      final deals = MockDatabase.deals.where((d) => d.productId == productId || d.productId == 'P001' || d.productId == 'prod-101').toList();

      state = state.copyWith(
        product: product,
        subscriptionLimits: limits,
        relatedDeals: deals,
        isSubscriptionExpired: isExpired,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> toggleProductStatus() async {
    if (state.product == null) return false;
    final currentStatus = state.product!.status;
    final newStatus = currentStatus == ProductStatus.published
        ? ProductStatus.hidden
        : ProductStatus.published;

    final repo = ref.read(productsRepositoryImplProvider);
    final success = await repo.updateProductStatus(productId, newStatus);
    if (success) {
      final updated = state.product!.copyWith(status: newStatus);
      state = state.copyWith(product: updated);
      ref.invalidate(productsProvider);
      return true;
    }
    return false;
  }

  Future<ProductModel?> duplicateProduct() async {
    if (state.product == null) return null;
    final repo = ref.read(productsRepositoryImplProvider);
    final duplicated = await repo.duplicateProduct(productId);
    ref.invalidate(productsProvider);
    return duplicated;
  }

  Future<bool> updateStock(int newStock) async {
    if (state.product == null) return false;
    final updated = state.product!.copyWith(availableStock: newStock);
    state = state.copyWith(product: updated);
    return true;
  }

  bool canDeleteProduct() {
    if (state.product == null) return false;
    // Rule: Cannot delete if linked to active deals
    return state.relatedDeals.isEmpty && state.product!.dealsCount == 0;
  }
}

final productDetailsNotifierProvider = StateNotifierProvider.family<ProductDetailsNotifier, ProductDetailsState, String>((ref, productId) {
  return ProductDetailsNotifier(ref, productId);
});
