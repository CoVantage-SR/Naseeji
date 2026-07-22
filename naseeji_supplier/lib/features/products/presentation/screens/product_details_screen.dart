import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/products_providers.dart';
import '../widgets/details/basic_info_section_widget.dart';
import '../widgets/details/media_files_section_widget.dart';
import '../widgets/details/pricing_tier_section_widget.dart';
import '../widgets/details/manufacturing_capacity_section_widget.dart';
import '../widgets/details/quality_certificates_section_widget.dart';
import '../widgets/details/packaging_pickup_section_widget.dart';
import '../widgets/details/product_performance_section_widget.dart';
import '../widgets/details/product_quick_actions_bar_widget.dart';
import '../widgets/details/product_lifecycle_timeline_widget.dart';

class ProductDetailsScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailsProvider(productId));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'تفاصيل المنتج والمواصفات',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'تعديل المنتج',
              onPressed: () => context.push('/add-product'),
            ),
          ],
        ),
        body: SafeArea(
          child: productAsync.when(
            loading: () => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: colorScheme.primary),
                  const SizedBox(height: 12),
                  Text(
                    'جاري تحميل تفاصيل المنتج...',
                    style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            error: (err, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline_rounded, size: 48, color: colorScheme.error),
                    const SizedBox(height: 12),
                    Text('تعذر تحميل تفاصيل المنتج: $err'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(productDetailsProvider(productId)),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            ),
            data: (product) {
              if (product == null) {
                return const Center(child: Text('المنتج غير موجود'));
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1: Basic Info
                    BasicInfoSectionWidget(product: product),
                    const SizedBox(height: 16),

                    // Section 2: Media & Files
                    MediaFilesSectionWidget(product: product),
                    const SizedBox(height: 16),

                    // Section 3: Pricing & MOQ Tiers
                    PricingTierSectionWidget(product: product),
                    const SizedBox(height: 16),

                    // Section 4: Manufacturing & Capacity
                    ManufacturingCapacitySectionWidget(product: product),
                    const SizedBox(height: 16),

                    // Section 5: Quality Certificates & ISO Standards
                    QualityCertificatesSectionWidget(product: product),
                    const SizedBox(height: 16),

                    // Section 6: Packaging & Pickup Warehouse Location
                    PackagingPickupSectionWidget(product: product),
                    const SizedBox(height: 16),

                    // Section 7: Product Performance Analytics
                    ProductPerformanceSectionWidget(product: product),
                    const SizedBox(height: 16),

                    // Part 4: Lifecycle 12-Step Timeline Tracker
                    ProductLifecycleTimelineWidget(product: product),
                    const SizedBox(height: 16),

                    // Section 8: Quick Actions Bar
                    ProductQuickActionsBarWidget(product: product),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
