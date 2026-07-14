import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/comparison_provider.dart';

/// 1. DeliveryCardWidget
class DeliveryCardWidget extends StatelessWidget {
  final DeliveryComparisonItem item;
  final bool isFastest;

  const DeliveryCardWidget({
    super.key,
    required this.item,
    required this.isFastest,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return PrimaryCard(
      color: isFastest ? AppColors.info.withValues(alpha: 0.04) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SupplierAvatar(name: item.supplierName, size: 36),
                  const SizedBox(width: 10),
                  Text(
                    item.supplierName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
              if (isFastest)
                const StatusChip(label: 'الأسرع توصيلاً ⚡', color: AppColors.info)
            ],
          ),
          AppSpacing.hMD,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetric('زمن التجهيز', '${item.prepTimeDays} أيام'),
              _buildMetric('زمن الشحن', '${item.shippingTimeDays} أيام'),
              _buildMetric('الوصول الكلي المتوقع', '${item.totalEstimatedTime} أيام'),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatItem('دقة التسليم', item.deliveryPerformance, AppColors.success),
              const SizedBox(width: 32),
              _buildStatItem('نسبة التأخر', '${item.lateDeliveryPercent}%', AppColors.error),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              value,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ],
    );
  }
}
