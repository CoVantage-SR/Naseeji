import 'package:flutter/material.dart';
import 'package:naseeji_factory/supplier/features/deals/domain/entities/deal_model.dart';

class DealFilesWidget extends StatelessWidget {
  final DealModel deal;

  const DealFilesWidget({super.key, required this.deal});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final files = deal.files;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.folder_open_rounded, size: 18, color: colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                'الملفات والمستندات والكتالوجات الرسمية',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (files.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text('لا توجد مستندات مرفقة بهذه الصفقة حالياً', style: TextStyle(fontSize: 11, color: colorScheme.outline)),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: files.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final file = files[index];
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.picture_as_pdf_outlined, color: Colors.red, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(file.title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                            const SizedBox(height: 2),
                            Text('${file.fileType} • ${file.fileSize}', style: TextStyle(fontSize: 9, color: colorScheme.outline)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.download_rounded, color: colorScheme.primary, size: 20),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('جاري تنزيل ${file.title}...')),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

