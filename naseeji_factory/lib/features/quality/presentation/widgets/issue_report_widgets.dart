import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import 'quality_reusable_widgets.dart';

class IssueHeaderWidget extends StatelessWidget {
  final OrderModel order;

  const IssueHeaderWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: AppRadius.rMD,
        border: Border.all(color: AppColors.error.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          const Icon(Icons.report_problem_rounded, color: AppColors.error, size: 36),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تقرير وحصر المشاكل والعيوب الفنية',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'المورد: ${order.supplierName} | طلب: ${order.id}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class IssueTypeWidget extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onChanged;
  final List<String> issueTypes;

  const IssueTypeWidget({
    super.key,
    required this.selectedType,
    required this.onChanged,
    required this.issueTypes,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(
          color: context.theme.brightness == Brightness.dark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'نوع المشكلة / العيب المكتشف',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            for (final type in issueTypes)
              RadioListTile<String>(
                title: Text(type, style: const TextStyle(fontSize: 12)),
                value: type,
                groupValue: selectedType,
                activeColor: AppColors.primary,
                onChanged: (val) => onChanged(val ?? ''),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
          ],
        ),
      ),
    );
  }
}

class PhotoUploaderWidget extends StatelessWidget {
  final List<String> images;
  final VoidCallback onUpload;
  final Function(int) onRemove;

  const PhotoUploaderWidget({
    super.key,
    required this.images,
    required this.onUpload,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EvidenceUploader(
          label: 'إرفاق صور إثبات التلف / العيوب الميكانيكية (صور العقد والمطابقة)',
          icon: Icons.camera_alt_rounded,
          onTap: onUpload,
        ),
        if (images.isNotEmpty) ...[
          const SizedBox(height: 8),
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return ImagePreviewCard(
                  imagePath: images[index],
                  onRemove: () => onRemove(index),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class VideoUploaderWidget extends StatelessWidget {
  final List<String> videos;
  final VoidCallback onUpload;
  final Function(int) onRemove;

  const VideoUploaderWidget({
    super.key,
    required this.videos,
    required this.onUpload,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EvidenceUploader(
          label: 'إرفاق فيديو توضيحي للعيوب (طريقة تفتيح وتجربة المواد)',
          icon: Icons.video_call_rounded,
          onTap: onUpload,
        ),
        if (videos.isNotEmpty) ...[
          const SizedBox(height: 8),
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: videos.length,
              itemBuilder: (context, index) {
                return VideoPreviewCard(
                  title: videos[index],
                  onRemove: () => onRemove(index),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class DescriptionWidget extends StatelessWidget {
  final String description;
  final ValueChanged<String> onChanged;

  const DescriptionWidget({
    super.key,
    required this.description,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: description);
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(
          color: context.theme.brightness == Brightness.dark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'شرح ووصف تفصيلي للمشكلة',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'يرجى كتابة تفاصيل دقيقة لتسهل على المورد فهم العيب وحل المشكلة...',
                contentPadding: EdgeInsets.all(12),
              ),
              style: const TextStyle(fontSize: 12),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class EvidenceWidget extends StatelessWidget {
  final List<String> files;
  final VoidCallback onUpload;
  final Function(int) onRemove;

  const EvidenceWidget({
    super.key,
    required this.files,
    required this.onUpload,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(
          color: context.theme.brightness == Brightness.dark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ملفات ومستندات فنية داعمة (تقارير مختبرات خارجية / قياسات)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            EvidenceUploader(
              label: 'تحميل ملف PDF أو مستند القياسات الفنية والتقارير',
              icon: Icons.file_present_rounded,
              onTap: onUpload,
            ),
            if (files.isNotEmpty) ...[
              const SizedBox(height: 16),
              ...files.asMap().entries.map((entry) {
                return AttachmentCard(
                  fileName: entry.value,
                  onRemove: () => onRemove(entry.key),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}

class SubmitWidget extends StatelessWidget {
  final VoidCallback onSubmit;
  final VoidCallback onSaveDraft;

  const SubmitWidget({
    super.key,
    required this.onSubmit,
    required this.onSaveDraft,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrimaryButton(
          label: 'تقديم البلاغ وفتح نزاع رسمي مع المورد',
          icon: Icons.send_rounded,
          onPressed: onSubmit,
        ),
        const SizedBox(height: 10),
        SecondaryButton(
          label: 'حفظ كمسودة ومراجعة لاحقاً',
          icon: Icons.save_alt_rounded,
          onPressed: onSaveDraft,
        ),
      ],
    );
  }
}
