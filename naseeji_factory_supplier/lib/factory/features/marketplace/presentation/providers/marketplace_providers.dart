import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/marketplace_mock_database.dart';
import '../../domain/entities/marketplace_models.dart';

// Categories Provider
final categoriesProvider = StateNotifierProvider<CategoriesNotifier, AsyncValue<List<MarketplaceCategory>>>((ref) {
  return CategoriesNotifier();
});

class CategoriesNotifier extends StateNotifier<AsyncValue<List<MarketplaceCategory>>> {
  CategoriesNotifier() : super(const AsyncValue.loading()) {
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      final categories = await MarketplaceMockDatabase.getCategories();
      state = AsyncValue.data(categories);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void selectCategory(String id) {
    state.whenData((categories) {
      final updated = categories.map((cat) {
        return cat.copyWith(isSelected: cat.id == id);
      }).toList();
      state = AsyncValue.data(updated);
    });
  }
}

// Active Filters Provider
final filtersProvider = StateNotifierProvider<FiltersNotifier, List<ActiveFilterItem>>((ref) {
  return FiltersNotifier();
});

class FiltersNotifier extends StateNotifier<List<ActiveFilterItem>> {
  FiltersNotifier() : super([]) {
    loadFilters();
  }

  Future<void> loadFilters() async {
    final filters = await MarketplaceMockDatabase.getActiveFilters();
    state = filters;
  }

  void removeFilter(String id) {
    state = state.where((f) => f.id != id).toList();
  }

  void addFilter(ActiveFilterItem filter) {
    if (!state.any((f) => f.id == filter.id)) {
      state = [...state, filter];
    }
  }

  void clearAll() {
    state = [];
  }
}

// Products Provider with Favorites State Management
final productsProvider = StateNotifierProvider<ProductsNotifier, AsyncValue<List<MarketplaceProduct>>>((ref) {
  return ProductsNotifier();
});

class ProductsNotifier extends StateNotifier<AsyncValue<List<MarketplaceProduct>>> {
  ProductsNotifier() : super(const AsyncValue.loading()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final products = await MarketplaceMockDatabase.getProducts();
      state = AsyncValue.data(products);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void toggleFavorite(String productId) {
    state.whenData((products) {
      final updated = products.map((prod) {
        if (prod.id == productId) {
          return prod.copyWith(isFavorite: !prod.isFavorite);
        }
        return prod;
      }).toList();
      state = AsyncValue.data(updated);
    });
  }
}

// Suppliers Provider
final suppliersProvider = FutureProvider<List<MarketplaceSupplier>>((ref) async {
  return await MarketplaceMockDatabase.getSuppliers();
});

// Recommended Products Provider
final recommendedProductsProvider = FutureProvider<List<RecommendedProductItem>>((ref) async {
  return await MarketplaceMockDatabase.getRecommendedProducts();
});

// Recent Searches Provider
final recentSearchesProvider = StateNotifierProvider<RecentSearchesNotifier, List<String>>((ref) {
  return RecentSearchesNotifier();
});

class RecentSearchesNotifier extends StateNotifier<List<String>> {
  RecentSearchesNotifier() : super([]) {
    loadSearches();
  }

  Future<void> loadSearches() async {
    final searches = await MarketplaceMockDatabase.getRecentSearches();
    state = searches;
  }

  void addSearch(String query) {
    if (query.trim().isEmpty) return;
    state = [query, ...state.where((s) => s != query)];
  }

  void removeSearch(String query) {
    state = state.where((s) => s != query).toList();
  }
}

// Search Query State Provider
final searchProvider = StateProvider<String>((ref) => '');

// Favorites Set State Provider
final favoritesProvider = Provider<Set<String>>((ref) {
  final productsState = ref.watch(productsProvider);
  return productsState.maybeWhen(
    data: (products) => products.where((p) => p.isFavorite).map((p) => p.id).toSet(),
    orElse: () => {},
  );
});

// Main Marketplace Overview Provider
final marketplaceProvider = FutureProvider<bool>((ref) async {
  await Future.wait([
    ref.read(categoriesProvider.notifier).loadCategories(),
    ref.read(productsProvider.notifier).loadProducts(),
  ]);
  return true;
});



