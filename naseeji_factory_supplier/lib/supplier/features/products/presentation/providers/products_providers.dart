import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product_model.dart';
import '../../domain/entities/product_performance_model.dart';
import '../../domain/entities/product_subscription_limit_model.dart';
import '../../domain/services/product_service.dart';
import '../../domain/services/subscription_service.dart';
import '../../domain/services/analytics_service.dart';
import '../../domain/services/product_validation_service.dart';
import '../../data/repositories/products_repository_impl.dart';

final productsRepositoryImplProvider = Provider<ProductsRepositoryImpl>((ref) {
  return ProductsRepositoryImpl();
});

final productServiceProvider = Provider<ProductService>((ref) {
  final repo = ref.watch(productsRepositoryImplProvider);
  return ProductService(repo);
});

final subscriptionServiceProvider = Provider<SubscriptionService>((ref) {
  final repo = ref.watch(productsRepositoryImplProvider);
  return SubscriptionService(repo);
});

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  final repo = ref.watch(productsRepositoryImplProvider);
  return AnalyticsService(repo);
});

final productValidationServiceProvider = Provider<ProductValidationService>((ref) {
  return ProductValidationService();
});

// State Providers for Search & Filters
final productSearchQueryProvider = StateProvider<String>((ref) => '');
final productStatusFilterProvider = StateProvider<String?>((ref) => null);
final productCategoryFilterProvider = StateProvider<String?>((ref) => null);
final productSortByProvider = StateProvider<String>((ref) => 'updated');

// Main Products List Provider
final productsProvider = FutureProvider<List<ProductModel>>((ref) async {
  final service = ref.watch(productServiceProvider);
  final searchQuery = ref.watch(productSearchQueryProvider);
  final statusFilter = ref.watch(productStatusFilterProvider);
  final categoryFilter = ref.watch(productCategoryFilterProvider);
  final sortBy = ref.watch(productSortByProvider);

  return service.getProducts(
    searchQuery: searchQuery,
    statusFilter: statusFilter,
    categoryFilter: categoryFilter,
    sortBy: sortBy,
  );
});

// Single Product Details Provider
final productDetailsProvider = FutureProvider.family<ProductModel?, String>((ref, productId) async {
  final service = ref.watch(productServiceProvider);
  return service.getProductById(productId);
});

// Subscription Limit & Quota Provider
final subscriptionLimitsProvider = FutureProvider<ProductSubscriptionLimitModel>((ref) async {
  final service = ref.watch(subscriptionServiceProvider);
  return service.getLimits();
});

// Product Analytics Provider
final productAnalyticsProvider = FutureProvider.family<ProductPerformanceModel, String>((ref, productId) async {
  final service = ref.watch(analyticsServiceProvider);
  return service.getProductAnalytics(productId);
});


