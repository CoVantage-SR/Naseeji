import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/products_providers.dart';
import '../widgets/list/product_card_widget.dart';
import '../widgets/list/product_filter_bar.dart';
import '../widgets/subscription/product_subscription_banner_widget.dart';
import '../widgets/subscription/subscription_limit_dialog.dart';

class ProductsTab extends ConsumerWidget {
  const ProductsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsListProvider);
    final limitsAsync = ref.watch(productSubscriptionLimitsProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(productsListProvider);
        ref.invalidate(productSubscriptionLimitsProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Part 3: Subscription & Usage Limits Banner
            const ProductSubscriptionBannerWidget(),
            const SizedBox(height: 16),

            // Header Row: Title & "إضافة منتج جديد" Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'قائمة المنتجات',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                    fontSize: 16,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    final limits = limitsAsync.valueOrNull;
                    if (limits != null && !limits.canAddProduct) {
                      SubscriptionLimitDialog.show(
                        context,
                        title: 'لقد وصلت للحد الأقصى في باقتك الحالية',
                        message: 'يمكنك ترقية الباقة لإضافة منتجات أكثر.',
                      );
                    } else {
                      context.push('/add-product');
                    }
                  },
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('إضافة منتج جديد'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    elevation: 0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Search Bar & Filter Chips
            const ProductFilterBar(),
            const SizedBox(height: 14),

            // Product Cards List
            productsAsync.when(
              loading: () => Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(color: colorScheme.primary),
                ),
              ),
              error: (err, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Icon(Icons.error_outline_rounded, size: 40, color: colorScheme.error),
                      const SizedBox(height: 8),
                      Text('تعذر تحميل المنتجات: $err'),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => ref.invalidate(productsListProvider),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (products) {
                if (products.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(32),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 56,
                          color: colorScheme.outline.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'لا توجد منتجات مطابقة في القائمة',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'جرب التعديل في خيارات البحث أو قم بإضافة منتج جديد الآن',
                          style: TextStyle(fontSize: 12, color: colorScheme.outline),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => context.push('/add-product'),
                          icon: const Icon(Icons.add),
                          label: const Text('إضافة منتج الآن'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCardWidget(
                      product: product,
                      onTap: () => context.push('/products/details/${product.id}'),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
