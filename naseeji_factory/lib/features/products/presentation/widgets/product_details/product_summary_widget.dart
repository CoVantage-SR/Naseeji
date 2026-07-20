import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/widgets/reusable_widgets.dart';
import '../../providers/products_provider.dart';

/// Displays product name, rating, verified supplier badge, country of origin, and description.
/// Migrated from ProductInformationWidget in product_details_widgets.dart.
class ProductSummaryWidget extends StatelessWidget {
  final Product product;

  const ProductSummaryWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                product.name,
                style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            if (product.isVerifiedSupplier)
              const StatusChip(label: 'مورد موثق ✅', color: AppColors.success),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
            const SizedBox(width: 4),
            Text(product.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 12),
            Container(width: 1, height: 12, color: Colors.grey),
            const SizedBox(width: 12),
            Text(
              'البلد الأصلي: ${product.countryOfOrigin}',
              style: context.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
        AppSpacing.hLG,
        Text(
          'وصف المنتج',
          style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          product.description,
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}
