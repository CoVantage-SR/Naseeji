import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/reusable_widgets.dart';

/// 1. GrandTotalCardWidget
class GrandTotalCardWidget extends StatelessWidget {
  final double pricePerUnit;
  final int quantity;
  final double shippingCost;
  final double taxRatePercent;

  const GrandTotalCardWidget({
    super.key,
    required this.pricePerUnit,
    required this.quantity,
    required this.shippingCost,
    required this.taxRatePercent,
  });

  @override
  Widget build(BuildContext context) {
    final subtotal = pricePerUnit * quantity;
    final tax = subtotal * (taxRatePercent / 100);
    final grandTotal = subtotal + shippingCost + tax;

    return PrimaryCard(
      color: AppColors.primary.withValues(alpha: 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الملخص المالي والجراند توتال',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 6),
          const Divider(),
          const SizedBox(height: 8),
          _buildBillRow('قيمة البضائع (Subtotal)', '${subtotal.toInt()} ج.م'),
          _buildBillRow('تكلفة الشحن والتسليم', '${shippingCost.toInt()} ج.م'),
          _buildBillRow('ضريبة القيمة المضافة (${taxRatePercent.toInt()}%)', '${tax.toInt()} ج.م'),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'المجموع الكلي النهائي (Grand Total)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Text(
                '${grandTotal.toInt()} ج.م',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}
