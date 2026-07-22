import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/widgets/app_bottom_navigation_bar.dart';

import '../providers/products_providers.dart';
import '../controllers/products_controller.dart';
import '../widgets/products_dashboard_widget.dart';
import '../widgets/subscription_card_widget.dart';
import '../widgets/product_search_widget.dart';
import '../widgets/product_filter_widget.dart';
import '../widgets/performance_suggestion_card.dart';
import '../widgets/product_card_widget.dart';
import '../widgets/empty_products_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/subscription_limit_dialog.dart';
import '../widgets/add_product_wizard_bottom_sheet.dart';

class ProductsModuleScreen extends ConsumerWidget {
  const ProductsModuleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final productsAsync = ref.watch(productsProvider);
    final limitsAsync = ref.watch(subscriptionLimitsProvider);
    final searchQuery = ref.watch(productSearchQueryProvider);
    final statusFilter = ref.watch(productStatusFilterProvider);
    final categoryFilter = ref.watch(productCategoryFilterProvider);
    final sortBy = ref.watch(productSortByProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: colorScheme.surface,
          elevation: 0.5,
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inventory_2_rounded, size: 18, color: AppColors.primary),
              const SizedBox(width: 6),
              const Text(
                'إدارة المنتجات والخامات B2B',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.tune_rounded, size: 20),
              tooltip: 'الفلاتر السريعة',
              onPressed: () {
                ref.read(productStatusFilterProvider.notifier).state = null;
                ref.read(productCategoryFilterProvider.notifier).state = null;
                ref.read(productSearchQueryProvider.notifier).state = '';
              },
            ),
          ],
        ),
        body: productsAsync.when(
          loading: () => const LoadingWidget(),
          error: (err, _) => Center(
            child: Text('حدث خطأ في تحميل المنتجات: $err', style: const TextStyle(color: Colors.red, fontSize: 11)),
          ),
          data: (products) {
            return Column(
              children: [
                const SizedBox(height: 8),

                // 1. Dashboard Mini Cards Header (عدد المنتجات المنشورة والمراجعة والتخزين)
                ProductsDashboardWidget(
                  products: products,
                  activeFilter: statusFilter,
                  onSelectFilter: (filterKey) {
                    ref.read(productStatusFilterProvider.notifier).state = filterKey;
                  },
                ),
                const SizedBox(height: 8),

                // 2. Subscription Status Card (اسم الباقة والمساحة والحدود)
                limitsAsync.when(
                  data: (limits) => SubscriptionCardWidget(
                    limits: limits,
                    onUpgrade: () => context.push('/subscription/plans'),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 8),

                // 3. Search Bar
                ProductSearchWidget(
                  query: searchQuery,
                  onChanged: (val) {
                    ref.read(productSearchQueryProvider.notifier).state = val;
                  },
                  onClear: () {
                    ref.read(productSearchQueryProvider.notifier).state = '';
                  },
                ),
                const SizedBox(height: 6),

                // 4. Compact Filter Bar
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
                const SizedBox(height: 6),

                // 5. Performance Suggestion Card
                if (products.isNotEmpty) PerformanceSuggestionCard(products: products),
                const SizedBox(height: 6),

                // 6. Compact Product Cards List
                Expanded(
                  child: products.isEmpty
                      ? EmptyProductsWidget(
                          onAddProduct: () => _handleAddProduct(context, ref),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return ProductCardWidget(product: products[index]);
                          },
                        ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _handleAddProduct(context, ref),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          icon: const Icon(Icons.add_rounded, size: 20),
          label: const Text('إضافة منتج خامة', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        ),
        bottomNavigationBar: const Directionality(
          textDirection: TextDirection.ltr,
          child: AppBottomNavigationBar(currentIndex: 1),
        ),
      ),
    );
  }

  Future<void> _handleAddProduct(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(productsControllerProvider.notifier);
    final validation = await controller.validateAddProduct();

    if (!validation.isValid) {
      if (context.mounted) {
        SubscriptionLimitDialog.show(context, validation.errorMessage ?? 'وصلت للحد الأقصى المسموح بباقتك.');
      }
    } else {
      if (context.mounted) {
        AddProductWizardBottomSheet.show(context);
      }
    }
  }
}