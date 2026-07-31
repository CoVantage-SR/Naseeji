// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import 'quality_reusable_widgets.dart';

class IssueHeaderWidget extends StatelessWidget {
  final OrderModel order;

  const IssueHeaderWidget({super.key, required this.order});

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
          const Icon(Icons.report_problem_rounded, color: AppColors.error, size: 36),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تقرير وحصر المشاكل والعيوب الفنية',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'المورد: ${order.supplierName} | طلب: ${order.id}',
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

class IssueTypeWidget extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onChanged;
  final List<String> issueTypes;

  const IssueTypeWidget({
    super.key,
    required this.selectedType,
    required this.onChanged,
    required this.issueTypes,
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
              'نوع المشكلة / العيب المكتشف',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            for (final type in issueTypes)
              RadioListTile<String>(
                title: Text(type, style: const TextStyle(fontSize: 12)),
                value: type,
                groupValue: selectedType,
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
  final VoidCallback onSaveDraft;

  const SubmitWidget({
    super.key,
    required this.onSubmit,
    required this.onSaveDraft,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrimaryButton(
          label: 'تقديم البلاغ وفتح نزاع رسمي مع المورد',
          icon: Icons.send_rounded,
          onPressed: onSubmit,
        ),
        const SizedBox(height: 10),
        SecondaryButton(
          label: 'حفظ كمسودة ومراجعة لاحقاً',
          icon: Icons.save_alt_rounded,
          onPressed: onSaveDraft,
        ),
      ],
    );
  }
}

