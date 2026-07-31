import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../providers/quality_provider.dart';
import 'quality_reusable_widgets.dart';

class QualityHeaderWidget extends StatelessWidget {
  final OrderModel order;

  const QualityHeaderWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: AppRadius.rMD,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_user_rounded, color: AppColors.primary, size: 36),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تقرير ومطابقة الجودة الفنية',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'الطلب: ${order.id} | منتج: ${order.productName}',
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

class OverallScoreWidget extends StatelessWidget {
  final double score;
  final String ratingText;

  const OverallScoreWidget({
    super.key,
    required this.score,
    required this.ratingText,
  });

  @override
  Widget build(BuildContext context) {
    return QualityScoreCard(
      score: score,
      ratingText: ratingText,
    );
  }
}

class InspectionCategoriesWidget extends StatelessWidget {
  final String orderId;
  final List<QualityCategoryRating> ratings;
  final Function(String category, int rating) onRatingChanged;
  final Function(String category, String comment) onCommentChanged;

  const InspectionCategoriesWidget({
    super.key,
    required this.orderId,
    required this.ratings,
    required this.onRatingChanged,
    required this.onCommentChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'بنود فحص الجودة والتفاصيل الفنية',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
        ),
        const SizedBox(height: 12),
        ...ratings.map((item) {
          return InspectionCard(
            title: item.category,
            rating: item.rating,
            comment: item.comment,
            onRatingChanged: (val) => onRatingChanged(item.category, val),
            onCommentChanged: (val) => onCommentChanged(item.category, val),
          );
        }),
      ],
    );
  }
}

class QualityChecklistWidget extends StatelessWidget {
  final Map<String, bool> checklist;
  final ValueChanged<String> onItemToggled;

  const QualityChecklistWidget({
    super.key,
    required this.checklist,
    required this.onItemToggled,
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
              'مطابقة العينات والمواصفات الفنية',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
            ),
            const SizedBox(height: 8),
            const Text(
              'يرجى تأكيد تطابق البنود التالية:',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ...checklist.entries.map((entry) {
              return ChecklistItem(
                label: entry.key,
                value: entry.value,
                onChanged: (val) => onItemToggled(entry.key),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class NotesWidget extends StatelessWidget {
  final String notes;
  final ValueChanged<String> onChanged;

  const NotesWidget({
    super.key,
    required this.notes,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: notes);
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
              'تقرير الملاحظات العامة والتوصيات الفنية',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'اكتب هنا أي ملاحظات إضافية حول التوريد أو جودة المنتج...',
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

class ApprovalWidget extends StatelessWidget {
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const ApprovalWidget({
    super.key,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrimaryButton(
          label: 'اعتماد جودة الشحنة وصرف المستحقات',
          icon: Icons.check_circle_rounded,
          onPressed: onApprove,
        ),
        const SizedBox(height: 10),
        SecondaryButton(
          label: 'رفض جودة الشحنة بالكامل أو الإبلاغ عن عيوب تصنيع',
          icon: Icons.gavel_rounded,
          color: AppColors.error,
          onPressed: onReject,
        ),
      ],
    );
  }
}



