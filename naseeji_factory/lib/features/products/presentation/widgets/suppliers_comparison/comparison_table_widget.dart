import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../providers/suppliers_provider.dart';
import '../suppliers_comparison_widgets.dart';

class ComparisonTableWidget extends StatelessWidget {
  final List<Supplier> selectedSuppliers;
  final VoidCallback onDeliveryComparisonTap;
  final VoidCallback onPriceComparisonTap;

  const ComparisonTableWidget({
    super.key,
    required this.selectedSuppliers,
    required this.onDeliveryComparisonTap,
    required this.onPriceComparisonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ComparisonRowWidget(
          label: 'الشكل القانوني',
          values: selectedSuppliers.map((s) => s.type).toList(),
        ),
        ComparisonRowWidget(
          label: 'التقييم العام',
          values: selectedSuppliers.map((s) => '${s.rating} ⭐').toList(),
          highlightBest: selectedSuppliers.map((s) => s.rating == selectedSuppliers.map((s) => s.rating).reduce((a, b) => a > b ? a : b)).toList(),
        ),
        ComparisonRowWidget(
          label: 'سنوات الخبرة',
          values: selectedSuppliers.map((s) => s.experience).toList(),
        ),
        ComparisonRowWidget(
          label: 'الطلبات المكتملة',
          values: selectedSuppliers.map((s) => '${s.completedOrders}+').toList(),
        ),
        ComparisonRowWidget(
          label: 'الالتزام بالتسليم',
          values: selectedSuppliers.map((s) => s.deliveryPerformance).toList(),
        ),
        ComparisonRowWidget(
          label: 'سرعة الرد',
          values: selectedSuppliers.map((s) => s.responseSpeed).toList(),
        ),
        ComparisonRowWidget(
          label: 'شهادات الاعتماد',
          values: selectedSuppliers.map((s) => s.certificates.join('، ')).toList(),
        ),
        ComparisonRowWidget(
          label: 'حالة التوثيق',
          values: selectedSuppliers.map((s) => s.isVerified ? 'موثق ✅' : 'نشط').toList(),
        ),
        AppSpacing.hLG,
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onDeliveryComparisonTap,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: AppColors.primary),
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                ),
                child: const Text('مقارنة مواعيد الشحن'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: onPriceComparisonTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                ),
                child: const Text('مقارنة الأسعار والعروض'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
