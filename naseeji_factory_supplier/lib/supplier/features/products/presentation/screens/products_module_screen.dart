// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/products_providers.dart';
import '../controllers/products_controller.dart';
import '../widgets/products_dashboard_widget.dart';
import '../widgets/product_search_widget.dart';
import '../widgets/product_filter_widget.dart';
import '../widgets/product_card_widget.dart';
import '../widgets/empty_products_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/subscription_limit_dialog.dart';
import '../widgets/add_product_wizard_bottom_sheet.dart';

class ProductsModuleScreen extends ConsumerWidget {
  const ProductsModuleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);
    final searchQuery = ref.watch(productSearchQueryProvider);
    final statusFilter = ref.watch(productStatusFilterProvider);
    final categoryFilter = ref.watch(productCategoryFilterProvider);
    final sortBy = ref.watch(productSortByProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF9FAFB),
        body: SafeArea(
          child: Column(
            children: [
              // 1. Custom Top App Bar (Header from design)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Right Side: Icon + Title & Subtitle
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.local_mall_outlined,
                            color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'المنتجات',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : const Color(0xFF111827),
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'إدارة منتجاتك وعروضك',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Left Side: Action Icons (Search & Notifications with Badge 3)
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            context.push('/search');
                          },
                          icon: Icon(
                            Icons.search_rounded,
                            color: isDark ? Colors.white : const Color(0xFF4B5563),
                            size: 24,
                          ),
                        ),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            IconButton(
                              onPressed: () {
                                context.push('/notifications');
                              },
                              icon: const Icon(
                                Icons.notifications_none_rounded,
                                color: Color(0xFF4B5563),
                                size: 24,
                              ),
                            ),
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEF4444),
                                  shape: BoxShape.circle,
                                ),
                                child: const Text(
                                  '3',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 2. Search Field
              ProductSearchWidget(
                query: searchQuery,
                onChanged: (val) {
                  ref.read(productSearchQueryProvider.notifier).state = val;
                },
                onClear: () {
                  ref.read(productSearchQueryProvider.notifier).state = '';
                },
              ),
              const SizedBox(height: 12),

              // 3. Filter Tabs Row (الكل / تم النشر / مسودة / مرفوضة + تصفية)
              ProductFilterWidget(
                selectedStatus: statusFilter,
                selectedCategory: categoryFilter,
                selectedSort: sortBy,
                onStatusChanged: (val) {
                  ref.read(productStatusFilterProvider.notifier).state = val;
                },
                onCategoryChanged: (val) {
                  ref.read(productCategoryFilterProvider.notifier).state = val;
                },
                onSortChanged: (val) {
                  ref.read(productSortByProvider.notifier).state = val;
                },
              ),
              const SizedBox(height: 14),

              // 4. Products Dashboard Summary Cards (128 / 86 / 28 / 14)
              productsAsync.when(
                data: (products) => ProductsDashboardWidget(
                  products: products,
                  activeFilter: statusFilter,
                  onSelectFilter: (filterKey) {
                    ref.read(productStatusFilterProvider.notifier).state = filterKey;
                  },
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 16),

              // 5. Products List Header (قائمة المنتجات + ترتيب)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'قائمة المنتجات',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        final current = ref.read(productSortByProvider);
                        ref.read(productSortByProvider.notifier).state =
                            current == 'updated' ? 'views' : 'updated';
                      },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.tune_rounded,
                            size: 16,
                            color: Color(0xFF6B7280),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'ترتيب',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // 6. Products List
              Expanded(
                child: productsAsync.when(
                  loading: () => const LoadingWidget(),
                  error: (err, _) => Center(
                    child: Text(
                      'حدث خطأ في تحميل المنتجات: $err',
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                  data: (products) {
                    if (products.isEmpty) {
                      return EmptyProductsWidget(
                        onAddProduct: () => _handleAddProduct(context, ref),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return ProductCardWidget(product: products[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // Floating Action Button ("إضافة منتج +")
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'products_add_fab',
          onPressed: () => _handleAddProduct(context, ref),
          backgroundColor: const Color(0xFF2563EB),
          foregroundColor: Colors.white,
          elevation: 4,
          shape: const StadiumBorder(),
          icon: const Icon(Icons.add_rounded, size: 20),
          label: const Text(
            'إضافة منتج',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleAddProduct(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(productsControllerProvider.notifier);
    final validation = await controller.validateAddProduct();

    if (!validation.isValid) {
      if (context.mounted) {
        SubscriptionLimitDialog.show(
          context,
          validation.errorMessage ?? 'وصلت للحد الأقصى المسموح بباقتك.',
        );
      }
    } else {
      if (context.mounted) {
        AddProductWizardBottomSheet.show(context);
      }
    }
  }
}


