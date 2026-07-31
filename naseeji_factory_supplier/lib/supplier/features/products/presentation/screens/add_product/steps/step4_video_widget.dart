import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_factory/supplier/features/products/domain/entities/product_form_data.dart';
import 'package:naseeji_factory/supplier/features/products/presentation/controllers/add_product_controller.dart';

class Step4VideoWidget extends ConsumerWidget {
  final ProductFormData formData;

  const Step4VideoWidget({super.key, required this.formData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final controller = ref.read(addProductControllerProvider.notifier);

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
                      'فيديو استعراض المنتج والنسيج',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'رفع فيديو توضيحي لمراحل الغزل والنسيج يرفع معدل اهتمام المشتريين 3 أضعاف.',
                      style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(
                  'الفيديو: ${formData.usedVideosCount} / ${formData.maxVideosAllowed}',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.red.shade900),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (formData.videoUrl != null) ...[
            // Render Selected Video Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.play_circle_fill_rounded, color: Colors.red.shade800, size: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formData.videoFileName ?? 'فيديو_استعراض_المنتج.mp4',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.red.shade900),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'مدة الفيديو: ${formData.videoDuration} • الحجم: ${formData.videoSizeMb} ميجابايت',
                          style: TextStyle(fontSize: 11, color: Colors.red.shade700),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                    onPressed: () => controller.removeVideo(),
                  ),
                ],
              ),
            ),
          ] else ...[
            // Video Upload Prompt Dropzone
            InkWell(
              onTap: () {
                controller.setVideo(
                  'https://example.com/videos/yarn_demo.mp4',
                  'فيديو_اختبار_المتانة_والغزل.mp4',
                  '01:30 دقيقة',
                  14.5,
                  context,
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorScheme.outlineVariant, style: BorderStyle.solid),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.video_call_rounded, size: 48, color: Colors.red.shade700),
                    const SizedBox(height: 8),
                    Text('اضغط هنا لرفع فيديو استعراض المنتج (MP4 / MOV)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                    const SizedBox(height: 4),
                    Text('الحد الأقصى لمدّة الفيديو 3 دقائق بحجم لا يتجاوز 50 ميجابايت', style: TextStyle(fontSize: 11, color: colorScheme.outline)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}


