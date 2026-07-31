import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/reviews_provider.dart';
import 'reviews_reusable_widgets.dart';

// ─── Review Information Widget ─────────────────────────────────────────────
class ReviewInformationWidget extends StatelessWidget {
  final ReviewModel review;
  const ReviewInformationWidget({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.network(
                    review.factoryLogo,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      width: 44,
                      height: 44,
                      color: AppColors.primary.withValues(alpha: 0.1),
                      child: const Icon(Icons.person_rounded, color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.factoryName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text(review.reviewDate, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: review.isPublic ? AppColors.success.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: AppRadius.rRound,
                  ),
                  child: Text(
                    review.isPublic ? 'عام' : 'خاص',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: review.isPublic ? AppColors.success : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            StarsWidget(rating: review.overallRating, size: 22),
            const SizedBox(height: 8),
            if (review.reviewText.isNotEmpty)
              Text(review.reviewText, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('المورد: ', style: TextStyle(fontSize: 11, color: Colors.grey)),
                Text(review.supplierName, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                const Spacer(),
                if (review.wouldRecommend)
                  Row(
                    children: [
                      const Icon(Icons.thumb_up_rounded, size: 14, color: AppColors.success),
                      const SizedBox(width: 4),
                      const Text('موصى به', style: TextStyle(fontSize: 10, color: AppColors.success)),
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

// ─── Ratings Breakdown Widget ──────────────────────────────────────────────
class RatingsBreakdownWidget extends StatelessWidget {
  final Map<String, double> categoryRatings;
  const RatingsBreakdownWidget({super.key, required this.categoryRatings});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تفاصيل التقييم حسب المعاير',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            ...categoryRatings.entries.map((e) => RatingCard(category: e.key, rating: e.value)),
          ],
        ),
      ),
    );
  }
}

// ─── Review Details Action Buttons Widget ─────────────────────────────────
class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onReport;

  const ActionButtonsWidget({
    super.key,
    required this.onEdit,
    required this.onDelete,
    required this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_rounded, size: 16),
            label: const Text('تعديل التقييم', style: TextStyle(fontSize: 11)),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_rounded, size: 16, color: AppColors.error),
            label: const Text('حذف التقييم', style: TextStyle(fontSize: 11, color: AppColors.error)),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: const BorderSide(color: AppColors.error),
            ),
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          onPressed: onReport,
          icon: const Icon(Icons.flag_rounded, size: 16, color: Colors.grey),
          label: const Text('إبلاغ', style: TextStyle(fontSize: 11, color: Colors.grey)),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          ),
        ),
      ],
    );
  }
}
