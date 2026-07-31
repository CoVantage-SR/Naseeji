import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/comparison_provider.dart';

/// 1. QuotationCardWidget
class QuotationCardWidget extends StatelessWidget {
  final PriceQuotation quotation;
  final bool isBestOffer;
  final VoidCallback onChoose;

  const QuotationCardWidget({
    super.key,
    required this.quotation,
    required this.isBestOffer,
    required this.onChoose,
  });

  @override
  Widget build(BuildContext context) {

    return PrimaryCard(
      color: isBestOffer ? AppColors.success.withValues(alpha: 0.04) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SupplierAvatar(name: quotation.supplierName, size: 36),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quotation.supplierName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        'ينتهي العرض: ${quotation.expiryDate}',
                        style: const TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
              if (isBestOffer)
                const StatusChip(label: 'أفضل سعر 💎', color: AppColors.success)
            ],
          ),
          AppSpacing.hMD,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetric('السعر المعلن', '${quotation.quotedPricePerUnit.toInt()} ج.م'),
              _buildMetric('الخصم الممنوح', '${quotation.discountPercent.toInt()}%'),
              _buildMetric('تكلفة الشحن', '${quotation.shippingCost.toInt()} ج.م'),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'السعر النهائي التقديري (للوحدة شاملة الشحن والخصم):',
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${quotation.finalPrice.toStringAsFixed(1)} ج.م',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onChoose,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                  ),
                  child: const Text('اختيار هذا العرض والطلب'),
                ),
              ),
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
}


