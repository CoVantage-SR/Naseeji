import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/widgets/reusable_widgets.dart';

/// Displays a tappable supplier preview card.
/// Migrated from SupplierPreviewWidget in product_details_widgets.dart.
class SupplierPreviewWidget extends StatelessWidget {
  final String supplierName;
  final VoidCallback onTap;

  const SupplierPreviewWidget({
    super.key,
    required this.supplierName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return PrimaryCard(
      onTap: onTap,
      child: Row(
        children: [
          SupplierAvatar(name: supplierName, size: 48),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(supplierName, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(
                  'اضغط لعرض الملف التعريفي والشهادات الفنية للمورد.',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}
