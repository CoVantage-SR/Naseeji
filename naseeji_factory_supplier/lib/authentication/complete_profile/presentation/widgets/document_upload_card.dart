import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';

class DocumentUploadCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final XFile? file;
  final String? errorText;
  final VoidCallback onPick;
  final VoidCallback onDelete;

  const DocumentUploadCard({
    super.key,
    required this.title,
    this.description = 'PDF, PNG, JPG, JPEG (بحد أقصى 10 ميجابايت)',
    this.icon = Icons.cloud_upload_outlined,
    this.file,
    this.errorText,
    required this.onPick,
    required this.onDelete,
  });

  bool get isPdf => file != null && file!.path.toLowerCase().endsWith('.pdf');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark
                ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.03)
                : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: errorText != null
                  ? colorScheme.error
                  : file != null
                      ? AppColors.primary
                      : (isDark ? colorScheme.outline.withValues(alpha: 0.5) : const Color(0xFFE2E8F0)),
              width: file != null ? .05 : .01,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: file != null
                                ? AppColors.primary.withValues(alpha: 0.15)
                                : (isDark ? colorScheme.surface : Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            file != null ? (isPdf ? Icons.picture_as_pdf_rounded : Icons.task_alt_rounded) : icon,
                            color: file != null ? AppColors.primary : colorScheme.onSurfaceVariant,
                            size: 10,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? colorScheme.onSurface : const Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                file != null ? file!.name : description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: file != null
                                      ? AppColors.primary
                                      : (isDark ? colorScheme.onSurfaceVariant : const Color(0xFF64748B)),
                                  fontSize: 11.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Actions: Upload / Replace / Delete
                  if (file == null)
                    ElevatedButton.icon(
                      onPressed: onPick,
                      icon: const Icon(Icons.file_upload_outlined, size: 16),
                      label: const Text('رفع'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        minimumSize: const Size(0, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    )
                  else
                    Row(
                      children: [
                        IconButton(
                          onPressed: onPick,
                          icon: const Icon(Icons.sync_rounded, size: 18),
                          color: AppColors.primary,
                          tooltip: 'استبدال المستند',
                        ),
                        IconButton(
                          onPressed: onDelete,
                          icon: const Icon(Icons.delete_outline_rounded, size: 18),
                          color: colorScheme.error,
                          tooltip: 'حذف',
                        ),
                      ],
                    ),
                ],
              ),

              // Image Thumbnail Preview if applicable
              if (file != null && !isPdf) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(file!.path),
                    height: 80,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Text(
              errorText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
