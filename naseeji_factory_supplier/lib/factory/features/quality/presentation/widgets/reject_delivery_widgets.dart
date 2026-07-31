// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import 'quality_reusable_widgets.dart';

class RejectHeaderWidget extends StatelessWidget {
  final OrderModel order;

  const RejectHeaderWidget({super.key, required this.order});

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
          const Icon(Icons.gavel_rounded, color: AppColors.error, size: 36),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'قرار رفض استلام الشحنة وإرجاعها',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'المورد: ${order.supplierName} | رقم الطلب: ${order.id}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
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

class ReasonSelectorWidget extends StatelessWidget {
  final String selectedReason;
  final ValueChanged<String> onChanged;
  final List<String> reasons;

  const ReasonSelectorWidget({
    super.key,
    required this.selectedReason,
    required this.onChanged,
    required this.reasons,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(
          color: context.theme.brightness == Brightness.dark
              ? AppColors.borderDark
              : AppColors.borderLight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'سبب رفض الشحنة الرئيسي',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            for (final reason in reasons)
              RadioListTile<String>(
                title: Text(reason, style: const TextStyle(fontSize: 12)),
                value: reason,
                groupValue: selectedReason,
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

class DeclarationWidget extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const DeclarationWidget({
    super.key,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.error.withValues(alpha: 0.03),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(
          color: isChecked
              ? AppColors.error.withValues(alpha: 0.3)
              : (context.theme.brightness == Brightness.dark
                    ? AppColors.borderDark
                    : AppColors.borderLight),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: isChecked,
              onChanged: onChanged,
              activeColor: AppColors.error,
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'أقر بصفتي ممثل مصنع نسيجي برفض هذه الشحنة بالكامل وإعادتها للمورد، وأتحمل مسؤولية الإجراءات المترتبة على ذلك قانونياً وتجارياً وبدء النزاع المالي.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RejectButtonWidget extends StatelessWidget {
  final VoidCallback onReject;
  final bool isEnabled;

  const RejectButtonWidget({
    super.key,
    required this.onReject,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      label: 'تأكيد الرفض النهائي وبدء النزاع رسميًا',
      icon: Icons.gavel_rounded,
      onPressed: isEnabled ? onReject : () {},
    );
  }
}



