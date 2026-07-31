// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/products_provider.dart';
import '../providers/suppliers_provider.dart';
import '../widgets/product_search/product_filter_sheet.dart';
import '../widgets/product_search/recent_searches_widget.dart';
import '../widgets/product_search_widgets.dart';

class ProductSearchScreen extends ConsumerStatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  ConsumerState<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends ConsumerState<ProductSearchScreen> {
  final _searchController = TextEditingController();
  final List<String> _recentQueries = ['خيوط قطن ممشط', 'أقمشة ملابس شتوية', 'بوليستر 100%'];
  String _query = '';

  // Filter values
  String _selectedCategory = '';
  String _selectedGov = '';
  double _maxPrice = 200000;
  bool _verifiedOnly = false;
  double _minRating = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ProductFilterSheet(
          initialCategory: _selectedCategory,
          initialGov: _selectedGov,
          initialMaxPrice: _maxPrice,
          initialVerifiedOnly: _verifiedOnly,
          initialMinRating: _minRating,
          onApply: (cat, gov, maxP, verOnly, minR) {
            setState(() {
              _selectedCategory = cat;
              _selectedGov = gov;
              _maxPrice = maxP;
              _verifiedOnly = verOnly;
              _minRating = minR;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productsNotifierProvider);
    final suppliers = ref.watch(suppliersNotifierProvider);

    // Apply Filter Criteria
    var matchedProducts = products;

    if (_query.isNotEmpty) {
      matchedProducts = matchedProducts.where((p) => p.name.contains(_query) || p.supplierName.contains(_query)).toList();
    }

    if (_selectedCategory.isNotEmpty) {
      if (_selectedCategory == 'yarn') {
        matchedProducts = matchedProducts.where((p) => p.id == 'prod_1' || p.id == 'prod_3').toList();
      } else if (_selectedCategory == 'fabric') {
        matchedProducts = matchedProducts.where((p) => p.id == 'prod_2').toList();
      }
    }

    if (_selectedGov.isNotEmpty) {
      matchedProducts = matchedProducts.where((p) {
        final supplier = suppliers.firstWhere((s) => s.id == p.supplierId);
        return supplier.governorate == _selectedGov;
      }).toList();
    }

    matchedProducts = matchedProducts.where((p) => p.price <= _maxPrice).toList();

    if (_verifiedOnly) {
      matchedProducts = matchedProducts.where((p) => p.isVerifiedSupplier).toList();
    }

    if (_minRating > 0) {
      matchedProducts = matchedProducts.where((p) => p.rating >= _minRating).toList();
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: AppSearchBar(
            controller: _searchController,
            hintText: 'ابحث باسم المنتج أو خاماته...',
            onChanged: (val) {
              setState(() {
                _query = val;
              });
            },
            onFilterTap: _showFilterSheet,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Expanded(
              child: _query.isEmpty && _recentQueries.isNotEmpty
                  ? RecentSearchesWidget(
                      recentQueries: _recentQueries,
                      onRemove: (query) => setState(() => _recentQueries.remove(query)),
                      onTap: (query) {
                        _searchController.text = query;
                        setState(() => _query = query);
                      },
                    )
                  : matchedProducts.isEmpty
                      ? const EmptyState(
                          icon: Icons.search_off_rounded,
                          title: 'لا توجد نتائج بحث مطابقة',
                          description: 'جرب تصفية الفئات أو تغيير كلمات البحث الخاصة بك.',
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: matchedProducts.length,
                          separatorBuilder: (context, index) => AppSpacing.hMD,
                          itemBuilder: (context, index) {
                            final prod = matchedProducts[index];
                            return ProductResultCardWidget(
                              product: prod,
                              onTap: () => context.push('/products/${prod.id}'),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

