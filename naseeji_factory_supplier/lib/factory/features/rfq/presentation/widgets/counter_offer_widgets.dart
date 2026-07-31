import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/reusable_widgets.dart';

/// 1. OriginalOfferWidget
class OriginalOfferWidget extends StatelessWidget {
  final double originalPrice;
  final int originalQuantity;
  final String originalDeliveryDate;

  const OriginalOfferWidget({
    super.key,
    required this.originalPrice,
    required this.originalQuantity,
    required this.originalDeliveryDate,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      color: AppColors.secondary.withValues(alpha: 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline_rounded, color: AppColors.secondary, size: 18),
              const SizedBox(width: 8),
              Text(
                'تفاصيل العرض الأصلي المقدم من المورد',
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStat('السعر الأصلي للوحدة', '${originalPrice.toInt()} ج.م'),
              _buildStat('الكمية المطلوبة', '$originalQuantity وحدة'),
              _buildStat('تاريخ التسليم المقترح', originalDeliveryDate),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}


