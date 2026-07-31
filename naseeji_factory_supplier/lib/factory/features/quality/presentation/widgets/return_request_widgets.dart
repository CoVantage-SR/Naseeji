// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import 'quality_reusable_widgets.dart';

class ReturnHeaderWidget extends StatelessWidget {
  final OrderModel order;

  const ReturnHeaderWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: AppRadius.rMD,
        border: Border.all(color: AppColors.error.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          const Icon(Icons.assignment_return_rounded, color: AppColors.error, size: 36),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'طلب إرجاع البضائع واسترداد الأموال',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'طلب رقم: ${order.id} | المورد: ${order.supplierName}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RefundInformationWidget extends StatelessWidget {
  final String selectedOption;
  final ValueChanged<String> onChanged;
  final List<String> refundOptions;

  const RefundInformationWidget({
    super.key,
    required this.selectedOption,
    required this.onChanged,
    required this.refundOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(
          color: context.theme.brightness == Brightness.dark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'طريقة استرداد القيمة المالية المفضلة',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
            ),
            const SizedBox(height: 8),
            const Text(
              'يرجى تحديد الحساب المالي الذي ترغب في تحويل المستحقات إليه:',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            for (final option in refundOptions)
              RadioListTile<String>(
                title: Text(option, style: const TextStyle(fontSize: 12)),
                value: option,
                groupValue: selectedOption,
                activeColor: AppColors.primary,
                onChanged: (val) => onChanged(val ?? ''),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
          ],
        ),
      ),
    );
  }
}

class SubmitWidget extends StatelessWidget {
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  const SubmitWidget({
    super.key,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrimaryButton(
          label: 'تقديم طلب إرجاع السلع واسترداد الأموال',
          icon: Icons.assignment_return_rounded,
          onPressed: onSubmit,
        ),
        const SizedBox(height: 10),
        SecondaryButton(
          label: 'إلغاء وتراجع',
          icon: Icons.close_rounded,
          color: Colors.grey,
          onPressed: onCancel,
        ),
      ],
    );
  }
}

