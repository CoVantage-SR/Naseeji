import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/products_provider.dart';
import '../widgets/products_widgets.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  String _selectedCategory = 'all';
  String _searchQuery = '';
  int _currentPage = 1;
  final int _itemsPerPage = 4;

  @override
  Widget build(BuildContext context) {
    final allProducts = ref.watch(productsNotifierProvider);
    final notifier = ref.read(productsNotifierProvider.notifier);

    // Apply filters
    var filteredProducts = allProducts;

    if (_selectedCategory != 'all') {
      if (_selectedCategory == 'yarn') {
        filteredProducts = filteredProducts.where((p) => p.id == 'prod_1' || p.id == 'prod_3').toList();
      } else if (_selectedCategory == 'fabric') {
        filteredProducts = filteredProducts.where((p) => p.id == 'prod_2').toList();
      } else {
        filteredProducts = [];
      }
    }

    if (_searchQuery.isNotEmpty) {
      filteredProducts = filteredProducts
          .where((p) => p.name.contains(_searchQuery) || p.supplierName.contains(_searchQuery))
          .toList();
    }

    // Pagination
    final totalItems = filteredProducts.length;
    final totalPages = (totalItems / _itemsPerPage).ceil() == 0 ? 1 : (totalItems / _itemsPerPage).ceil();

    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final paginatedProducts = filteredProducts.skip(startIndex).take(_itemsPerPage).toList();

    return Scaffold(
      appBar: ProductsAppBarWidget(
        onSearchTap: () => context.push('/product-search'),
        onFavoritesTap: () => context.push('/favorite-suppliers'),
        onComparisonTap: () => context.push('/suppliers-comparison'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SearchBarWidget(
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                        _currentPage = 1;
                      });
                    },
                    onFilterTap: () => context.push('/product-search'),
                  ),
                ),
                AppSpacing.hMD,
                CategoriesWidget(
                  selectedCategory: _selectedCategory,
                  onCategorySelected: (cat) {
                    setState(() {
                      _selectedCategory = cat;
                      _currentPage = 1;
                    });
                  },
                ),
                AppSpacing.hMD,
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: FeaturedBannerWidget(),
                ),
                AppSpacing.hLG,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ProductsGridWidget(
                    products: paginatedProducts,
                    onFavoriteToggle: (id) => notifier.toggleFavorite(id),
                    onProductTap: (prod) => context.push('/products/${prod.id}'),
                  ),
                ),
                if (totalPages > 1) ...[
                  AppSpacing.hLG,
                  PaginationWidget(
                    currentPage: _currentPage,
                    totalPages: totalPages,
                    onPageChanged: (page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
