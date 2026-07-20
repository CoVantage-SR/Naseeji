import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_radius.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/widgets/reusable_widgets.dart';
import '../../providers/reviews_provider.dart';
import '../../../../domain/entities/product_detail_entities.dart';

/// Displays the top B2B factory reviews for a product.
/// Reads data from [reviewsProvider].
class ProductReviewsWidget extends ConsumerWidget {
  final String productId;

  const ProductReviewsWidget({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reviewsProvider(productId: productId));

    return state.when(
      loading: () => const SizedBox(height: 80, child: Center(child: CircularProgressIndicator())),
      error: (_, _) => const SizedBox.shrink(),
      data: (reviews) {
        if (reviews.isEmpty) return const SizedBox.shrink();
        final avgRating = reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;

        return PrimaryCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'تقييمات المصانع',
                    style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    avgRating.toStringAsFixed(1),
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16),
                  ),
                  const Text(' / 5', style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
              AppSpacing.hMD,
              ...reviews.map((review) => _ReviewCard(review: review)),
            ],
          ),
        );
      },
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final ProductReview review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.borderDark.withValues(alpha: 0.5) : Colors.grey.shade50,
        borderRadius: AppRadius.rMD,
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.reviewerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text(
                      review.factoryName,
                      style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (i) => Icon(
                      i < review.rating.round() ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: Colors.amber,
                      size: 14,
                    )),
                  ),
                  const SizedBox(height: 2),
                  if (review.verifiedPurchase)
                    StatusChip(label: 'شراء موثق', color: AppColors.success),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(review.comment, style: context.textTheme.bodySmall?.copyWith(height: 1.5)),
          const SizedBox(height: 4),
          Text(
            review.date,
            style: context.textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
