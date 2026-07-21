import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/products_repository_impl.dart';
import '../../domain/repositories/products_repository.dart';
import '../../domain/entities/product_model.dart';
import '../../domain/entities/product_subscription_limit_model.dart';
import '../../domain/usecases/products_usecases.dart';

// Repository Provider
final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  return ProductsRepositoryImpl();
});

// Use Cases Providers
final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  final repo = ref.watch(productsRepositoryProvider);
  return GetProductsUseCase(repo);
});

final getProductDetailsUseCaseProvider = Provider<GetProductDetailsUseCase>((ref) {
  final repo = ref.watch(productsRepositoryProvider);
  return GetProductDetailsUseCase(repo);
});

final updateProductStatusUseCaseProvider = Provider<UpdateProductStatusUseCase>((ref) {
  final repo = ref.watch(productsRepositoryProvider);
  return UpdateProductStatusUseCase(repo);
});

final duplicateProductUseCaseProvider = Provider<DuplicateProductUseCase>((ref) {
  final repo = ref.watch(productsRepositoryProvider);
  return DuplicateProductUseCase(repo);
});

final getSubscriptionLimitsUseCaseProvider = Provider<GetSubscriptionLimitsUseCase>((ref) {
  final repo = ref.watch(productsRepositoryProvider);
  return GetSubscriptionLimitsUseCase(repo);
});

// State Filters
class ProductFilterState {
  final String statusFilter;
  final String categoryFilter;
  final String searchQuery;

  const ProductFilterState({
    this.statusFilter = 'الكل',
    this.categoryFilter = 'الكل',
    this.searchQuery = '',
  });

  ProductFilterState copyWith({
    String? statusFilter,
    String? categoryFilter,
    String? searchQuery,
  }) {
    return ProductFilterState(
      statusFilter: statusFilter ?? this.statusFilter,
      categoryFilter: categoryFilter ?? this.categoryFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

final productFilterProvider = StateProvider<ProductFilterState>((ref) {
  return const ProductFilterState();
});

// Reactive Products List Provider
final productsListProvider = FutureProvider.autoDispose<List<ProductModel>>((ref) async {
  final filter = ref.watch(productFilterProvider);
  final useCase = ref.watch(getProductsUseCaseProvider);
  return useCase(
    statusFilter: filter.statusFilter,
    categoryFilter: filter.categoryFilter,
    searchQuery: filter.searchQuery,
  );
});

// Product Details Provider
final productDetailsProvider = FutureProvider.autoDispose.family<ProductModel, String>((ref, productId) async {
  final useCase = ref.watch(getProductDetailsUseCaseProvider);
  return useCase(productId);
});

// Subscription Limits Provider
final productSubscriptionLimitsProvider = FutureProvider.autoDispose<ProductSubscriptionLimitModel>((ref) async {
  final useCase = ref.watch(getSubscriptionLimitsUseCaseProvider);
  return useCase();
});
