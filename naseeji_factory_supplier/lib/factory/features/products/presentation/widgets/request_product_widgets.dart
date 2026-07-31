import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/products_provider.dart';

/// 1. SelectedProductWidget
class SelectedProductWidget extends StatelessWidget {
  final Product product;

  const SelectedProductWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return PrimaryCard(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: AppRadius.rMD,
            child: Image.network(
              product.imageUrl,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 64,
                height: 64,
                color: isDark ? AppColors.borderDark : Colors.grey.shade100,
                child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  product.supplierName,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
                const SizedBox(height: 4),
                Text(
                  '${product.price.toInt()} ج.م / وحدة',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 2. OrderSummaryWidget
class OrderSummaryWidget extends StatelessWidget {
  final Product product;
  final int quantity;
  final double estimatedCost;

  const OrderSummaryWidget({
    super.key,
    required this.product,
    required this.quantity,
    required this.estimatedCost,
  });

  @override
  Widget build(BuildContext context) {
    final hasMoqIssue = quantity < product.moq;

    return PrimaryCard(
      color: hasMoqIssue ? AppColors.error.withValues(alpha: 0.05) : AppColors.primary.withValues(alpha: 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('الحد الأدنى للمورد (MOQ)', style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text('${product.moq} وحدة', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('الكمية المطلوبة حالياً', style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text(
                '$quantity وحدة',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: hasMoqIssue ? AppColors.error : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'التكلفة الإجمالية التقديرية',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Text(
                '${estimatedCost.toInt()} ج.م',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          if (hasMoqIssue) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'الكمية المطلوبة أقل من الحد الأدنى للطلب (${product.moq} وحدة). قد يرفض المورد طلبك.',
                      style: const TextStyle(color: AppColors.error, fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}


