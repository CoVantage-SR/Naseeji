import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/agreement_model.dart';

class AttachmentsWidget extends StatelessWidget {
  final List<AgreementDocument> documents;

  const AttachmentsWidget({super.key, required this.documents});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
          ),
        ],
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.attach_file_outlined, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Text(
                'القسم السادس: المستندات والمرفقات الرسمية',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              Text(
                '${documents.length} ملفات',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 12),

          if (documents.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'لا توجد ملفات مرفقة لهذا الاتفاق حالياً.',
                  style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.outline),
                ),
              ),
            )
          else
            Column(
              children: documents.map((doc) {
                IconData icon = Icons.insert_drive_file_outlined;
                Color iconColor = AppColors.primary;

                if (doc.type.contains('عرض السعر')) {
                  icon = Icons.receipt_long_outlined;
                  iconColor = const Color(0xFF2563EB);
                } else if (doc.type.contains('الكتالوج')) {
                  icon = Icons.menu_book_outlined;
                  iconColor = const Color(0xFF8B5CF6);
                } else if (doc.type.contains('شهادات الجودة')) {
                  icon = Icons.workspace_premium_outlined;
                  iconColor = const Color(0xFF16A34A);
                } else if (doc.type.contains('صور')) {
                  icon = Icons.image_outlined;
                  iconColor = const Color(0xFFF97316);
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: iconColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(icon, size: 20, color: iconColor),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doc.name,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'النوع: ${doc.type} • الحجم: ${doc.size}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.outline,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('معاينة المستند: ${doc.name}')),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.download_outlined, size: 18),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('تم بدء تحميل الملف: ${doc.name}')),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

