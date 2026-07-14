import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/reusable_widgets.dart';

/// 1. RejectionHeaderWidget
class RejectionHeaderWidget extends StatelessWidget {
  final String supplierName;

  const RejectionHeaderWidget({super.key, required this.supplierName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'رفض عرض السعر المقدم',
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.error,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'أنت بصدد رفض عرض السعر المقدم من مورد "$supplierName". يرجى تحديد أسباب الرفض لمساعدتنا على تحسين التوصيات وتحديث سجل التفاوض.',
          style: const TextStyle(color: Colors.grey, fontSize: 12, height: 1.4),
        ),
      ],
    );
  }
}
