import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_factory/supplier/features/products/domain/entities/product_form_data.dart';
import 'package:naseeji_factory/supplier/features/products/presentation/controllers/add_product_controller.dart';

class Step5DocumentsWidget extends ConsumerWidget {
  final ProductFormData formData;

  const Step5DocumentsWidget({super.key, required this.formData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final controller = ref.read(addProductControllerProvider.notifier);
    final docs = formData.pdfDocuments;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الكتالوج وملفات المواصفات (PDF)',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'ارفع الملفات الفنية، الكتالوج الكامل، أو شهادات الجودة ISO.',
                      style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
                ),
                child: Text(
                  'PDF: ${formData.usedPdfsCount} / ${formData.maxPdfsAllowed}',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: colorScheme.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Upload Button Box
          InkWell(
            onTap: () {
              controller.addPdfDocument(
                'تقرير_الفحص_المعملي_لخيوط_الغزل_2026.pdf',
                '3.1 ميجابايت',
                context,
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorScheme.outlineVariant, style: BorderStyle.solid),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.picture_as_pdf_rounded, color: colorScheme.primary, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('اضغط هنا لرفع ملف مواصفات PDF جديد', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                        const SizedBox(height: 2),
                        Text('يدعم ملفات الكتالوجات وشهادات ISO حتى 15 ميجابايت', style: TextStyle(fontSize: 11, color: colorScheme.outline)),
                      ],
                    ),
                  ),
                  Icon(Icons.add_circle_outline_rounded, color: colorScheme.primary),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Uploaded Documents List
          Text('الملفات المرفوعة حالياً:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
          const SizedBox(height: 8),

          if (docs.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text('لم تقم برفع أية ملفات PDF بعد.', style: TextStyle(color: colorScheme.outline)),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: docs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final doc = docs[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.picture_as_pdf_rounded, color: Colors.red, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(doc['title'] ?? 'ملف.pdf', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text('حجم الملف: ${doc['size'] ?? '2.4 MB'}', style: TextStyle(fontSize: 11, color: colorScheme.outline)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                        onPressed: () => controller.removePdfDocument(index),
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

