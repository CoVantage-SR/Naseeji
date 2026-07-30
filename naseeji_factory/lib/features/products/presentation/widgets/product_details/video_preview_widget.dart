import 'package:flutter/material.dart';
import '../../../../../../../core/constants/app_colors.dart';
import '../../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../../core/widgets/reusable_widgets.dart';

/// Displays a video preview row card for the product.
/// Migrated from VideoPreviewWidget in product_details_widgets.dart.
class VideoPreviewWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const VideoPreviewWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return SecondaryCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_circle_outline_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'عرض فيديو توضيحي للمنتج',
                  style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'شاهد خط الإنتاج وجودة الفتل بالصوت والصورة.',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
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
