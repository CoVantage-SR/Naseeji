// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../orders/presentation/providers/orders_provider.dart';

/// PrimaryButton - Rounded brand primary button
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
          Flexible(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

/// SecondaryButton - Rounded outline button
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? color;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? AppColors.primary;
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: resolvedColor,
        side: BorderSide(color: resolvedColor),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
          Flexible(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

/// QualityScoreCard - Card showing the quality score, percentage, and classification
class QualityScoreCard extends StatelessWidget {
  final double score;
  final String ratingText;

  const QualityScoreCard({
    super.key,
    required this.score,
    required this.ratingText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    Color scoreColor;
    if (score >= 90) {
      scoreColor = AppColors.success;
    } else if (score >= 75) {
      scoreColor = AppColors.primary;
    } else if (score >= 50) {
      scoreColor = AppColors.warning;
    } else {
      scoreColor = AppColors.error;
    }

    return Card(
      color: scoreColor.withValues(alpha: isDark ? 0.15 : 0.08),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rLG,
        side: BorderSide(color: scoreColor.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Column(
          children: [
            const Text(
              'التقييم الإجمالي للجودة',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${score.toInt()}%',
                  style: context.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: scoreColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: scoreColor,
                borderRadius: AppRadius.rRound,
              ),
              child: Text(
                ratingText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// InspectionCard - Card representing a single category rating item
class InspectionCard extends StatelessWidget {
  final String title;
  final int rating;
  final String comment;
  final ValueChanged<int> onRatingChanged;
  final ValueChanged<String> onCommentChanged;

  const InspectionCard({
    super.key,
    required this.title,
    required this.rating,
    required this.comment,
    required this.onRatingChanged,
    required this.onCommentChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController(text: comment);
    textController.selection = TextSelection.fromPosition(
      TextPosition(offset: textController.text.length),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(
          color: context.theme.brightness == Brightness.dark
              ? AppColors.borderDark
              : AppColors.borderLight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  'التقييم:',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Row(
                  children: List.generate(5, (index) {
                    final starValue = index + 1;
                    return GestureDetector(
                      onTap: () => onRatingChanged(starValue),
                      child: Icon(
                        rating >= starValue
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: Colors.amber,
                        size: 28,
                      ),
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                hintText: 'أضف ملاحظاتك أو تعليقاتك هنا...',
                prefixIcon: Icon(Icons.comment_outlined, size: 16),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              style: const TextStyle(fontSize: 12),
              onChanged: onCommentChanged,
            ),
          ],
        ),
      ),
    );
  }
}

/// ChecklistItem - Custom list tile representing a single verification checkbox
class ChecklistItem extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const ChecklistItem({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rSM,
        side: BorderSide(
          color: value
              ? AppColors.primary.withValues(alpha: 0.5)
              : (context.theme.brightness == Brightness.dark
                    ? AppColors.borderDark
                    : AppColors.borderLight),
        ),
      ),
      color: value
          ? AppColors.primary.withValues(alpha: 0.05)
          : Colors.transparent,
      child: CheckboxListTile(
        title: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: value ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      ),
    );
  }
}

/// ImagePreviewCard - Card to display image preview with a delete/remove option
class ImagePreviewCard extends StatelessWidget {
  final String imagePath;
  final VoidCallback? onRemove;

  const ImagePreviewCard({super.key, required this.imagePath, this.onRemove});

  @override
  Widget build(BuildContext context) {
    final isNetwork = imagePath.startsWith('http');
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            borderRadius: AppRadius.rMD,
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            image: DecorationImage(
              image: isNetwork
                  ? NetworkImage(imagePath) as ImageProvider
                  : AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (onRemove != null)
          Positioned(
            top: 6,
            right: 6,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// VideoPreviewCard - Card for displaying video thumbnail with play action overlay
class VideoPreviewCard extends StatelessWidget {
  final String title;
  final VoidCallback? onRemove;

  const VideoPreviewCard({super.key, required this.title, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 140,
          height: 100,
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            borderRadius: AppRadius.rMD,
            color: Colors.black87,
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.play_circle_fill_rounded,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 9),
                ),
              ),
            ],
          ),
        ),
        if (onRemove != null)
          Positioned(
            top: 6,
            right: 6,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// AttachmentCard - File card with attachment design
class AttachmentCard extends StatelessWidget {
  final String fileName;
  final VoidCallback? onRemove;

  const AttachmentCard({super.key, required this.fileName, this.onRemove});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rSM,
        side: BorderSide(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.insert_drive_file_rounded,
          color: AppColors.primary,
        ),
        title: Text(
          fileName,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: onRemove != null
            ? IconButton(
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.error,
                  size: 20,
                ),
                onPressed: onRemove,
              )
            : null,
      ),
    );
  }
}

/// EvidenceUploader - File selector widget
class EvidenceUploader extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const EvidenceUploader({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.rMD,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            style: BorderStyle.solid,
            width: 1.5,
          ),
          borderRadius: AppRadius.rMD,
          color: isDark
              ? AppColors.surfaceDark.withValues(alpha: 0.5)
              : AppColors.backgroundLight,
        ),
        child: Column(
          children: [
            Icon(icon, size: 36, color: AppColors.primary),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// TimelineCard - Styled details card with progress bullet/line
class TimelineCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final bool isLast;

  const TimelineCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.time,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 50,
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: context.theme.brightness == Brightness.dark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(color: Colors.grey, fontSize: 9),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}

/// EmptyStateWidget - Visual layout when lists or files are empty
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.icon = Icons.folder_open_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.grey.shade400, size: 48),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// InformationCard - Information display list container
class InformationCard extends StatelessWidget {
  final String title;
  final List<Map<String, String>> items;

  const InformationCard({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            for (final item in items) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['label'] ?? '',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      item['value'] ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              if (item != items.last)
                Divider(
                  color: isDark
                      ? AppColors.borderDark.withValues(alpha: 0.5)
                      : AppColors.borderLight.withValues(alpha: 0.5),
                  height: 12,
                ),
            ],
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
          label:
              'إرفاق صور إثبات التلف / العيوب الميكانيكية (صور العقد والمطابقة)',
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
          color: context.theme.brightness == Brightness.dark
              ? AppColors.borderDark
              : AppColors.borderLight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'شرح ووصف تفصيلي للمشكلة',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText:
                    'يرجى كتابة تفاصيل دقيقة لتسهل على المورد فهم العيب وحل المشكلة...',
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
          color: context.theme.brightness == Brightness.dark
              ? AppColors.borderDark
              : AppColors.borderLight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ملفات ومستندات فنية داعمة (تقارير مختبرات خارجية / قياسات)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: AppColors.primary,
              ),
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

class ItemsSelectorWidget extends StatelessWidget {
  final OrderModel order;
  final int selectedQuantity;
  final ValueChanged<int> onQuantityChanged;
  final String title;
  final String quantityLabel;

  const ItemsSelectorWidget({
    super.key,
    required this.order,
    required this.selectedQuantity,
    required this.onQuantityChanged,
    required this.title,
    required this.quantityLabel,
  });

  @override
  Widget build(BuildContext context) {
    final maxQuantity = order.quantity;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(
          color: context.theme.brightness == Brightness.dark
              ? AppColors.borderDark
              : AppColors.borderLight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: ClipRRect(
                borderRadius: AppRadius.rSM,
                child: Image.network(
                  order.productImage,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported_rounded),
                ),
              ),
              title: Text(
                order.productName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              subtitle: Text(
                'الكمية الإجمالية المستلمة: ${order.quantity} وحدة',
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  quantityLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.remove_circle_outline_rounded,
                        color: AppColors.primary,
                      ),
                      onPressed: selectedQuantity > 1
                          ? () => onQuantityChanged(selectedQuantity - 1)
                          : null,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                        ),
                        borderRadius: AppRadius.rSM,
                      ),
                      child: Text(
                        '$selectedQuantity',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle_outline_rounded,
                        color: AppColors.primary,
                      ),
                      onPressed: selectedQuantity < maxQuantity
                          ? () => onQuantityChanged(selectedQuantity + 1)
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ReplacementReasonWidget extends StatelessWidget {
  final String selectedReason;
  final ValueChanged<String> onChanged;
  final List<String> reasons;
  final String title;

  const ReplacementReasonWidget({
    super.key,
    required this.selectedReason,
    required this.onChanged,
    required this.reasons,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(
          color: context.theme.brightness == Brightness.dark
              ? AppColors.borderDark
              : AppColors.borderLight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            for (final reason in reasons)
              RadioListTile<String>(
                title: Text(reason, style: const TextStyle(fontSize: 12)),
                value: reason,
                groupValue: selectedReason,
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


