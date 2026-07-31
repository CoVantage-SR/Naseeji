import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../providers/products_provider.dart';

/// Renders the top product metadata matching reference screenshot:
/// - Verified supplier pill badge ('مورد معتمد')
/// - Product Title ('قماش قطن 100% أبيض')
/// - Subtitle spec summary ('عرض 150 سم - 140 جم/م²')
/// - Breadcrumbs ('أقمشة > أقمشة قطن')
/// - Rating row ('4.8 ★★★★★ (32 تقييم)')
/// - Price section ('يبدأ من 42.00 ج.م / متر' with 'السعر شامل الضريبة' badge)
/// - 4 metric boxes (التوفر: متوفر, بلد المنشأ: مصر, مدة التجهيز: 5-7 أيام, MOQ: 500 متر)
class ProductSummaryWidget extends StatelessWidget {
  final Product product;

  const ProductSummaryWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Verified Supplier Pill Badge
        if (product.isVerifiedSupplier) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_rounded,
                  size: 15,
                  color: primaryColor,
                ),
                const SizedBox(width: 4),
                Text(
                  'مورد معتمد',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Product Name
        Text(
          product.name,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 4),

        // Subtitle / Dimensions & Weight Summary
        Text(
          '${product.sizes.isNotEmpty ? product.sizes.first : "عرض 150 سم"} - ${product.weight}',
          style: TextStyle(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),

        // Breadcrumbs Category path
        Row(
          children: [
            Text(
              product.category,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.0),
              child: Icon(Icons.chevron_right_rounded, size: 14, color: Colors.grey),
            ),
            Text(
              product.subCategory,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Rating Row
        Row(
          children: [
            Text(
              product.rating.toStringAsFixed(1),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            Row(
              children: List.generate(
                5,
                (i) => const Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                  size: 16,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '(${product.reviewCount} تقييم)',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Price Section
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'يبدأ من',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      product.price.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'ج.م / ${product.unit}',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            // Tax Included Green Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_rounded, color: AppColors.success, size: 13),
                  SizedBox(width: 4),
                  Text(
                    'السعر شامل الضريبة',
                    style: TextStyle(
                      color: AppColors.success,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 4 Key Metric Info Cards (2x2 Grid)
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                context,
                label: 'التوفر',
                value: product.availabilityStatus,
                valueColor: AppColors.success,
                showGreenDot: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMetricCard(
                context,
                label: 'بلد المنشأ',
                value: product.countryOfOrigin,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMetricCard(
                context,
                label: 'مدة التجهيز',
                value: '${product.prepTimeDays - 2} - ${product.prepTimeDays} أيام',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMetricCard(
                context,
                label: 'MOQ',
                value: '${product.moq} ${product.unit}',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String label,
    required String value,
    Color? valueColor,
    bool showGreenDot = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.grey.shade50,
        borderRadius: AppRadius.rSM,
        border: Border.all(
          color: isDark ? AppColors.borderDark : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showGreenDot) ...[
                const Icon(Icons.circle, color: AppColors.success, size: 8),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: valueColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



