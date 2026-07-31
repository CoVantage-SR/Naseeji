// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:naseeji_factory/supplier/features/products/domain/entities/product_model.dart';

class MediaFilesSectionWidget extends StatelessWidget {
  final ProductModel product;

  const MediaFilesSectionWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.perm_media_outlined, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'الصور والوسائط والكتالوجات',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: colorScheme.outlineVariant.withValues(alpha: 0.4), height: 1),
          const SizedBox(height: 12),

          // Cover Main Image
          Text('الصورة الرئيسية المعروضة:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              product.mainImageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 180,
                color: colorScheme.primaryContainer.withValues(alpha: 0.2),
                child: Icon(Icons.image_not_supported_outlined, color: colorScheme.primary, size: 48),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Gallery Additional Images
          if (product.additionalImages.isNotEmpty) ...[
            Text('الصور الإضافية المعروضة في الكتالوج:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
            const SizedBox(height: 6),
            SizedBox(
              height: 70,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: product.additionalImages.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product.additionalImages[index],
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Video Section
          if (product.videoUrl != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.play_circle_fill_rounded, color: Colors.red.shade800, size: 32),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('فيديو استعراض خطوات التصنيع', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.red.shade900)),
                        Text('فيديو توضيحي لجودة الخامة والنسيج', style: TextStyle(fontSize: 11, color: Colors.red.shade700)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Catalog & PDF Files
          if (product.pdfUrls.isNotEmpty || product.catalogUrl != null) ...[
            Text('ملفات المواصفات والكتالوج (PDF):', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (product.catalogUrl != null)
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.picture_as_pdf_rounded, size: 16),
                    label: const Text('تحميل الكتالوج الكامل'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      minimumSize: Size.zero,
                    ),
                  ),
                ...product.pdfUrls.map((url) => OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.description_outlined, size: 16),
                      label: const Text('ملف المواصفات الفنية'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                      ),
                    )),
              ],
            ),
          ],
        ],
      ),
    );
  }
}



