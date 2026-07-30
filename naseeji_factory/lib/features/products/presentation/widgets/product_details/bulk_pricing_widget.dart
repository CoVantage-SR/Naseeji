import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../../core/constants/app_colors.dart';
import '../../../../../../../core/constants/app_radius.dart';
import '../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../../core/widgets/reusable_widgets.dart';
import '../../providers/bulk_pricing_provider.dart';
import '../../../domain/entities/product_detail_entities.dart';

/// Displays tiered bulk pricing table with discount percentages.
/// Reads data from [bulkPricingProvider].
class BulkPricingWidget extends ConsumerWidget {
  final String productId;

  const BulkPricingWidget({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bulkPricingProvider(productId: productId));
    final isDark = context.theme.brightness == Brightness.dark;

    return state.when(
      loading: () => const SizedBox(height: 80, child: Center(child: CircularProgressIndicator())),
      error: (_, _) => const SizedBox.shrink(),
      data: (tiers) => PrimaryCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.layers_rounded, color: AppColors.secondary, size: 18),
                const SizedBox(width: 8),
                Text(
                  'أسعار الجملة والكميات',
                  style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            AppSpacing.hMD,
            // Table header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.borderDark : Colors.grey.shade100,
                borderRadius: AppRadius.rSM,
              ),
              child: Row(
                children: [
                  Expanded(flex: 3, child: Text('نطاق الكمية', style: context.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey))),
                  Expanded(flex: 2, child: Text('سعر الوحدة', textAlign: TextAlign.center, style: context.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey))),
                  Expanded(flex: 2, child: Text('الخصم', textAlign: TextAlign.center, style: context.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey))),
                ],
              ),
            ),
            const SizedBox(height: 4),
            ...tiers.map((tier) => _TierRow(tier: tier, tiers: tiers)),
          ],
        ),
      ),
    );
  }
}

class _TierRow extends StatelessWidget {
  final BulkPricingTier tier;
  final List<BulkPricingTier> tiers;

  const _TierRow({required this.tier, required this.tiers});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final isFirst = tiers.first == tier;
    final rangeText = tier.maxQty == 0
        ? '${tier.minQty}+ وحدة'
        : '${tier.minQty} – ${tier.maxQty} وحدة';
    final hasDiscount = tier.discountPercent > 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: isFirst ? Colors.transparent : (isDark ? AppColors.primary.withValues(alpha: 0.04) : AppColors.primary.withValues(alpha: 0.03)),
        border: Border(bottom: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(rangeText, style: const TextStyle(fontSize: 12))),
          Expanded(
            flex: 2,
            child: Text(
              '${tier.pricePerUnit.toInt()} ج.م',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: hasDiscount ? AppColors.success : null),
            ),
          ),
          Expanded(
            flex: 2,
            child: hasDiscount
                ? Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: AppRadius.rRound,
                        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        '${tier.discountPercent.toInt()}%',
                        style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                  )
                : const Center(child: Text('—', style: TextStyle(color: Colors.grey))),
          ),
        ],
      ),
    );
  }
}
