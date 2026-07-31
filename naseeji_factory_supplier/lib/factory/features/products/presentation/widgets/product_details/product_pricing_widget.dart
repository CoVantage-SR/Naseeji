import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/constants/app_colors.dart';
import 'package:naseeji_factory/core/constants/app_spacing.dart';
import 'package:naseeji_factory/core/widgets/reusable_widgets.dart';

import '../../providers/products_provider.dart';

/// Displays the base unit price, MOQ, and preparation time.
/// Migrated from ProductPricingWidget in product_details_widgets.dart.
class ProductPricingWidget extends StatelessWidget {
  final Product product;

  const ProductPricingWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      color: AppColors.primary.withValues(alpha: 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'السعر المبدئي للوحدة',
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              Text(
                '${product.price.toInt()} ج.م',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          AppSpacing.hMD,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('الحد الأدنى للطلب (MOQ)'),
              Text('${product.moq} وحدة', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('زمن تجهيز الطلب المتوسط'),
              Text('${product.prepTimeDays} أيام عمل', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}


