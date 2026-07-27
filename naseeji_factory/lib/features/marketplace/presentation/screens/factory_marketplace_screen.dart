import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/reusable_widgets.dart' show checkGuestAction;
import '../providers/marketplace_providers.dart';
import '../widgets/active_filters_bar.dart';
import '../widgets/category_chips.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/marketplace_empty_widget.dart';
import '../widgets/marketplace_error_widget.dart';
import '../widgets/marketplace_header.dart';
import '../widgets/marketplace_loading_widget.dart';
import '../widgets/marketplace_search_bar.dart';
import '../widgets/product_card.dart';
import '../widgets/recent_searches.dart';
import '../widgets/recommended_products.dart';
import '../widgets/supplier_card.dart';

class FactoryMarketplaceScreen extends ConsumerStatefulWidget {
  const FactoryMarketplaceScreen({super.key});

  @override
  ConsumerState<FactoryMarketplaceScreen> createState() => _FactoryMarketplaceScreenState();
}

class _FactoryMarketplaceScreenState extends ConsumerState<FactoryMarketplaceScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MarketplaceHeader(
        unreadNotificationsCount: 3,
        onNotificationsTap: () => checkGuestAction(context, ref, () => context.push('/notifications')),
        onSearchTap: () => context.push('/search'),
        onFilterTap: () => FilterBottomSheet.show(context),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(marketplaceProvider);
            ref.invalidate(categoriesProvider);
            ref.invalidate(productsProvider);
            ref.invalidate(suppliersProvider);
            ref.invalidate(recommendedProductsProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Search Bar & Filter Button
                  MarketplaceSearchBar(
                    controller: _searchController,
                    onSubmitted: (query) {
                      if (query.trim().isNotEmpty) {
                        ref.read(recentSearchesProvider.notifier).addSearch(query.trim());
                        context.push('/search?q=${Uri.encodeComponent(query)}');
                      }
                    },
                    onFilterTap: () => FilterBottomSheet.show(context),
                  ),

                  // 2. Category Horizontal Chips
                  _buildCategoriesSection(ref),

                  const SizedBox(height: 6),

                  // 3. Active Filters Bar
                  _buildActiveFiltersSection(ref),

                  const SizedBox(height: 12),

                  // 4. Products Section (أحدث المنتجات)
                  _buildProductsSection(context, ref),

                  const SizedBox(height: 16),

                  // 5. Suppliers Section (الموردون)
                  _buildSuppliersSection(context, ref),

                  const SizedBox(height: 16),

                  // 6. Recommended Products Section (مقترح لك)
                  _buildRecommendedSection(context, ref),

                  const SizedBox(height: 16),

                  // 7. Recent Searches Section (آخر عمليات البحث)
                  _buildRecentSearchesSection(ref),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Granular Section Builders ---

  Widget _buildCategoriesSection(WidgetRef ref) {
    final categoriesState = ref.watch(categoriesProvider);

    return categoriesState.when(
      data: (categories) => CategoryChips(
        categories: categories,
        onCategoryTap: (category) {
          ref.read(categoriesProvider.notifier).selectCategory(category.id);
        },
      ),
      loading: () => const MarketplaceLoadingWidget(height: 72),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildActiveFiltersSection(WidgetRef ref) {
    final filters = ref.watch(filtersProvider);

    return ActiveFiltersBar(
      filters: filters,
      onRemoveFilter: (filter) {
        ref.read(filtersProvider.notifier).removeFilter(filter.id);
      },
    );
  }

  Widget _buildProductsSection(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productsProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'أحدث المنتجات',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        productsState.when(
          data: (products) {
            if (products.isEmpty) {
              return const MarketplaceEmptyWidget(title: 'لا توجد منتجات متاحة');
            }
            return SizedBox(
              height: 295,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(
                    product: product,
                    onTap: () => context.push('/products/${product.id}'),
                    onSendRfq: () => checkGuestAction(context, ref, () => context.push('/rfq/create')),
                    onToggleFavorite: () {
                      ref.read(productsProvider.notifier).toggleFavorite(product.id);
                    },
                  );
                },
              ),
            );
          },
          loading: () => const MarketplaceLoadingWidget(height: 280),
          error: (err, stack) => MarketplaceErrorWidget(
            message: 'تعذر تحميل المنتجات',
            onRetry: () => ref.read(productsProvider.notifier).loadProducts(),
          ),
        ),
      ],
    );
  }

  Widget _buildSuppliersSection(BuildContext context, WidgetRef ref) {
    final suppliersState = ref.watch(suppliersProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الموردون',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              InkWell(
                onTap: () => context.push('/suppliers'),
                child: Row(
                  children: [
                    Text(
                      'عرض الكل',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      Icons.chevron_left_rounded,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        suppliersState.when(
          data: (suppliers) {
            if (suppliers.isEmpty) {
              return const MarketplaceEmptyWidget(title: 'لا يوجد موردون');
            }
            return SizedBox(
              height: 145,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                itemCount: suppliers.length,
                itemBuilder: (context, index) {
                  final supplier = suppliers[index];
                  return SupplierCard(
                    supplier: supplier,
                    onTap: () => context.push('/suppliers/${supplier.id}'),
                  );
                },
              ),
            );
          },
          loading: () => const MarketplaceLoadingWidget(height: 140),
          error: (err, stack) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildRecommendedSection(BuildContext context, WidgetRef ref) {
    final recommendedState = ref.watch(recommendedProductsProvider);

    return recommendedState.when(
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();
        return RecommendedProducts(
          items: items,
          onItemTap: (item) => context.push('/products/${item.id}'),
        );
      },
      loading: () => const MarketplaceLoadingWidget(height: 130),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildRecentSearchesSection(WidgetRef ref) {
    final recentSearches = ref.watch(recentSearchesProvider);

    return RecentSearches(
      searches: recentSearches,
      onSearchTap: (query) {
        _searchController.text = query;
        context.push('/search?q=${Uri.encodeComponent(query)}');
      },
    );
  }
}
