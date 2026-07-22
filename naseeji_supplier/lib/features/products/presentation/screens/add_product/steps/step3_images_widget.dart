import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/product_form_data.dart';
import '../controllers/add_product_controller.dart';

class Step3ImagesWidget extends ConsumerWidget {
  final ProductFormData formData;

  const Step3ImagesWidget({super.key, required this.formData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final controller = ref.read(addProductControllerProvider.notifier);

    final List<String> mockGalleryOptions = [
      'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=400&q=80',
      'https://images.unsplash.com/photo-1584992236310-6edddc08acff?auto=format&fit=crop&w=400&q=80',
      'https://images.unsplash.com/photo-1606744824163-985d376605aa?auto=format&fit=crop&w=400&q=80',
      'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?auto=format&fit=crop&w=400&q=80',
      'https://images.unsplash.com/photo-1528459801416-a9e53bbf4e17?auto=format&fit=crop&w=400&q=80',
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'صور المنتج والمعرض البصري',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'ارفع صورة رئيسية وصور إضافية عالية الجودة للمنتج.',
                    style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
              // Subscription Limit Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
                ),
                child: Text(
                  'الصور: ${formData.usedImagesCount} / ${formData.maxImagesAllowed}',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: colorScheme.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Cover Image Selection Card
          Text('الصورة الرئيسية غلاف الكتالوج *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  child: formData.mainCoverImage != null
                      ? Image.network(
                          formData.mainCoverImage!,
                          fit: BoxFit.cover,
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo_outlined, size: 36, color: colorScheme.primary),
                            const SizedBox(height: 6),
                            Text('اضغط لاختيار الصورة الرئيسية للمنتج', style: TextStyle(fontSize: 12, color: colorScheme.outline)),
                          ],
                        ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      controller.setMainImage(mockGalleryOptions[0]);
                    },
                    icon: const Icon(Icons.upload_file_rounded, size: 14),
                    label: const Text('اختيار/تغيير'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 32),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Additional Gallery Grid & Upload Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('الصور الإضافية المعروضة:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
              TextButton.icon(
                onPressed: () {
                  final nextIndex = formData.additionalImages.length % mockGalleryOptions.length;
                  controller.addAdditionalImage(mockGalleryOptions[nextIndex], context);
                },
                icon: const Icon(Icons.add_photo_alternate_outlined, size: 16),
                label: const Text('إضافة صورة معرض'),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Gallery Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.0,
            ),
            itemCount: formData.additionalImages.length + 1,
            itemBuilder: (context, index) {
              if (index == formData.additionalImages.length) {
                return InkWell(
                  onTap: () {
                    final nextIndex = formData.additionalImages.length % mockGalleryOptions.length;
                    controller.addAdditionalImage(mockGalleryOptions[nextIndex], context);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colorScheme.outlineVariant, style: BorderStyle.solid),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_rounded, color: colorScheme.primary, size: 28),
                        const SizedBox(height: 2),
                        Text('إضافة جديدة', style: TextStyle(fontSize: 10, color: colorScheme.primary)),
                      ],
                    ),
                  ),
                );
              }

              final imgUrl = formData.additionalImages[index];
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imgUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => controller.removeAdditionalImage(index),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close_rounded, color: Colors.white, size: 14),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
