import 'package:flutter/material.dart';
import 'package:naseeji_factory/factory/core/constants/app_colors.dart';
import 'package:naseeji_factory/factory/core/constants/app_radius.dart';
import 'package:naseeji_factory/factory/core/extensions/context_extensions.dart';
import 'package:naseeji_factory/factory/core/widgets/reusable_widgets.dart';

/// 1. FormSectionContainer
class FormSectionContainer extends StatelessWidget {
  final String title;
  final Widget child;

  const FormSectionContainer({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 6),
          const Divider(),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

/// 2. AttachmentsWidget
class AttachmentsWidget extends StatelessWidget {
  final List<String> attachments;
  final VoidCallback onAddTap;
  final ValueChanged<int> onRemoveTap;

  const AttachmentsWidget({
    super.key,
    required this.attachments,
    required this.onAddTap,
    required this.onRemoveTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'المستندات والملفات المرفقة (صور، PDF، Excel، CAD)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey),
            ),
            TextButton.icon(
              onPressed: onAddTap,
              icon: const Icon(Icons.attach_file_rounded, size: 16),
              label: const Text('إرفاق ملف', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (attachments.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? AppColors.borderDark : Colors.grey.shade50,
              borderRadius: AppRadius.rMD,
              border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
            ),
            child: const Column(
              children: [
                Icon(Icons.cloud_upload_outlined, color: Colors.grey, size: 32),
                SizedBox(height: 8),
                Text(
                  'لم يتم إرفاق أي ملفات فنية حتى الآن.',
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: attachments.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final filename = attachments[index];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.borderDark : Colors.grey.shade100,
                  borderRadius: AppRadius.rMD,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.insert_drive_file_outlined, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        filename,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: AppColors.error, size: 18),
                      onPressed: () => onRemoveTap(index),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}

