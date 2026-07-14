// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/products_provider.dart';
import '../providers/suppliers_provider.dart';
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
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('تصفية متقدمة للمنتجات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedCategory = '';
                            _selectedGov = '';
                            _maxPrice = 200000;
                            _verifiedOnly = false;
                            _minRating = 0;
                          });
                          Navigator.of(context).pop();
                        },
                        child: const Text('إعادة ضبط', style: TextStyle(color: AppColors.error)),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 12),
                  FilterSectionWidget(
                    title: 'التصنيف الرئيسي',
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedCategory.isEmpty ? null : _selectedCategory,
                      onChanged: (val) => setSheetState(() => _selectedCategory = val ?? ''),
                      decoration: const InputDecoration(hintText: 'اختر التصنيف'),
                      items: const [
                        DropdownMenuItem(value: 'yarn', child: Text('خيوط وتريكو')),
                        DropdownMenuItem(value: 'fabric', child: Text('أقمشة وصباغة')),
                      ],
                    ),
                  ),
                  AppSpacing.hMD,
                  FilterSectionWidget(
                    title: 'محافظة المورد',
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedGov.isEmpty ? null : _selectedGov,
                      onChanged: (val) => setSheetState(() => _selectedGov = val ?? ''),
                      decoration: const InputDecoration(hintText: 'اختر المحافظة'),
                      items: const [
                        DropdownMenuItem(value: 'الغربية', child: Text('الغربية (المحلة)')),
                        DropdownMenuItem(value: 'الشرقية', child: Text('الشرقية (العاشر)')),
                      ],
                    ),
                  ),
                  AppSpacing.hMD,
                  FilterSectionWidget(
                    title: 'الحد الأقصى للسعر: ${_maxPrice.toInt()} ج.م',
                    child: Slider(
                      value: _maxPrice,
                      min: 0,
                      max: 200000,
                      divisions: 20,
                      activeColor: AppColors.primary,
                      onChanged: (val) => setSheetState(() => _maxPrice = val),
                    ),
                  ),
                  FilterSectionWidget(
                    title: 'الحد الأدنى لتقييم المورد: ${_minRating.toInt()} ⭐',
                    child: Slider(
                      value: _minRating,
                      min: 0,
                      max: 5,
                      divisions: 5,
                      activeColor: AppColors.secondary,
                      onChanged: (val) => setSheetState(() => _minRating = val),
                    ),
                  ),
                  SwitchListTile(
                    title: const Text('موردين موثقين فقط', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    value: _verifiedOnly,
                    activeThumbColor: AppColors.primary,
                    onChanged: (val) => setSheetState(() => _verifiedOnly = val),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {}); // Apply filters to screen state
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                    ),
                    child: const Text('تطبيق التصفية'),
                  ),
                ],
              ),
            );
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
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Text(
                              'البحث الأخير في الكتالوج',
                              style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _recentQueries.length,
                            itemBuilder: (context, index) {
                              final query = _recentQueries[index];
                              return ListTile(
                                leading: const Icon(Icons.history_rounded, color: Colors.grey),
                                title: Text(query),
                                trailing: IconButton(
                                  icon: const Icon(Icons.close_rounded, size: 18),
                                  onPressed: () => setState(() => _recentQueries.remove(query)),
                                ),
                                onTap: () {
                                  _searchController.text = query;
                                  setState(() => _query = query);
                                },
                              );
                            },
                          ),
                        ],
                      ),
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
