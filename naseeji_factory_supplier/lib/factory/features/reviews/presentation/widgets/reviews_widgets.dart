import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/reviews_provider.dart';
import 'reviews_reusable_widgets.dart';

// ─── Reviews Overview Statistics Widget ────────────────────────────────────
class OverallStatisticsWidget extends StatelessWidget {
  final double avgRating;
  final int totalReviews;
  final Map<int, int> breakdown;

  const OverallStatisticsWidget({
    super.key,
    required this.avgRating,
    required this.totalReviews,
    required this.breakdown,
  });

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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  avgRating.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
                StarsWidget(rating: avgRating, size: 18),
                const SizedBox(height: 4),
                Text('$totalReviews تقييم', style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                children: [5, 4, 3, 2, 1].map((star) {
                  final count = breakdown[star] ?? 0;
                  final fraction = totalReviews > 0 ? count / totalReviews : 0.0;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Text('$star', style: const TextStyle(fontSize: 10)),
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 12),
                        const SizedBox(width: 6),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: fraction,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text('$count', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Review Filters Widget ─────────────────────────────────────────────────
class ReviewFiltersWidget extends StatelessWidget {
  final List<String> filters;
  final String selected;
  final ValueChanged<String> onChanged;

  const ReviewFiltersWidget({
    super.key,
    required this.filters,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final isSelected = f == selected;
          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: FilterChip(
              label: Text(f, style: TextStyle(fontSize: 11, color: isSelected ? Colors.white : null)),
              selected: isSelected,
              onSelected: (_) => onChanged(f),
              selectedColor: AppColors.primary,
              checkmarkColor: Colors.white,
              showCheckmark: false,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.rRound,
                side: BorderSide(color: isSelected ? AppColors.primary : AppColors.borderLight),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Reviews List Widget ───────────────────────────────────────────────────
class ReviewsListWidget extends StatelessWidget {
  final List<ReviewModel> reviews;
  final Function(String) onReviewTap;

  const ReviewsListWidget({super.key, required this.reviews, required this.onReviewTap});

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 48),
          child: Column(
            children: [
              Icon(Icons.rate_review_rounded, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('لا توجد تقييمات حتى الآن', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                'تقييماتك تساعد المصانع الأخرى على اتخاذ قرارات أفضل.',
                style: TextStyle(fontSize: 11, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: reviews.length,
      itemBuilder: (_, i) => ReviewCard(
        review: reviews[i],
        onTap: () => onReviewTap(reviews[i].id),
      ),
    );
  }
}


