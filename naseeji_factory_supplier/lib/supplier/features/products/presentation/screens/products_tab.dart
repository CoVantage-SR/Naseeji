import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/products_providers.dart';
import '../widgets/product_card_widget.dart';
import '../widgets/product_filter_widget.dart';
import '../widgets/subscription_card_widget.dart';

class ProductsTab extends ConsumerWidget {
  const ProductsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);
    final limitsAsync = ref.watch(subscriptionLimitsProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(productsProvider);
        ref.invalidate(subscriptionLimitsProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            limitsAsync.when(
              data: (limits) => SubscriptionCardWidget(limits: limits, onUpgrade: () {}),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),

            ProductFilterWidget(
              selectedStatus: ref.watch(productStatusFilterProvider),
              selectedCategory: ref.watch(productCategoryFilterProvider),
              selectedSort: ref.watch(productSortByProvider),
              onStatusChanged: (val) => ref.read(productStatusFilterProvider.notifier).state = val,
              onCategoryChanged: (val) => ref.read(productCategoryFilterProvider.notifier).state = val,
              onSortChanged: (val) => ref.read(productSortByProvider.notifier).state = val,
            ),
            const SizedBox(height: 14),

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
                  child: Text('تعذر تحميل المنتجات: $err'),
                ),
              ),
              data: (products) {
                if (products.isEmpty) {
                  return const Center(child: Text('لا توجد منتجات مطابقة في القائمة'));
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCardWidget(product: product);
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

