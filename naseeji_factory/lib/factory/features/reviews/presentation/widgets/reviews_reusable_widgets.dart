import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/reviews_provider.dart';

/// StarsWidget - Read-only star rating display
class StarsWidget extends StatelessWidget {
  final double rating;
  final double size;
  const StarsWidget({super.key, required this.rating, this.size = 18});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < rating.floor();
        final halfFilled = !filled && (i < rating);
        return Icon(
          filled ? Icons.star_rounded : halfFilled ? Icons.star_half_rounded : Icons.star_outline_rounded,
          color: Colors.amber,
          size: size,
        );
      }),
    );
  }
}

/// CategoryRatingWidget - Interactive star rating for a single category
class CategoryRatingWidget extends StatelessWidget {
  final String label;
  final double rating;
  final ValueChanged<double>? onRatingChanged;
  final bool readOnly;

  const CategoryRatingWidget({
    super.key,
    required this.label,
    required this.rating,
    this.onRatingChanged,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ),
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: List.generate(5, (i) {
                return GestureDetector(
                  onTap: readOnly ? null : () => onRatingChanged?.call((i + 1).toDouble()),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Icon(
                      i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: Colors.amber,
                      size: 22,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

/// ReviewCard - Compact display of a submitted review
class ReviewCard extends StatelessWidget {
  final ReviewModel review;
  final VoidCallback onTap;

  const ReviewCard({super.key, required this.review, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 12),
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
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                        width: 40,
                        height: 40,
                        color: AppColors.primary.withValues(alpha: 0.1),
                        child: const Icon(Icons.person_rounded, color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(review.factoryName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Text(review.reviewDate, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                  ),
                  StarsWidget(rating: review.overallRating, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    review.overallRating.toStringAsFixed(1),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
              if (review.reviewText.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  review.reviewText,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11),
                ),
              ],
              if (review.images.isNotEmpty) ...[
                const SizedBox(height: 10),
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: review.images.length,
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: ClipRRect(
                        borderRadius: AppRadius.rSM,
                        child: Image.network(
                          review.images[i],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image_rounded),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              if (review.supplierReply != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    borderRadius: AppRadius.rSM,
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'رد المورد (${review.supplierName}):',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(review.supplierReply!, style: const TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: review.isPublic ? AppColors.success.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                      borderRadius: AppRadius.rRound,
                    ),
                    child: Text(
                      review.isPublic ? 'تقييم عام' : 'تقييم خاص',
                      style: TextStyle(
                        fontSize: 9,
                        color: review.isPublic ? AppColors.success : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (review.wouldRecommend)
                    const Row(
                      children: [
                        Icon(Icons.thumb_up_rounded, size: 12, color: AppColors.success),
                        SizedBox(width: 4),
                        Text('يوصي بهذا المورد', style: TextStyle(fontSize: 10, color: AppColors.success)),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// RatingCard - Displays a single category rating with a bar
class RatingCard extends StatelessWidget {
  final String category;
  final double rating;
  const RatingCard({super.key, required this.category, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(category, style: const TextStyle(fontSize: 11)),
          ),
          Expanded(
            flex: 4,
            child: LinearProgressIndicator(
              value: rating / 5.0,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

/// SupplierReplyCard - Displays a supplier reply to a review
class SupplierReplyCard extends StatelessWidget {
  final String supplierName;
  final String replyText;
  final String replyDate;
  const SupplierReplyCard({
    super.key,
    required this.supplierName,
    required this.replyText,
    required this.replyDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: AppRadius.rMD,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.reply_rounded, color: AppColors.primary, size: 16),
              const SizedBox(width: 6),
              Text(
                'رد $supplierName:',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
              ),
              const Spacer(),
              Text(replyDate, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 8),
          Text(replyText, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

/// RecommendationCard - Recommendation selection widget
class RecommendationCard extends StatelessWidget {
  final bool? selected;
  final ValueChanged<bool>? onChanged;
  final bool readOnly;

  const RecommendationCard({
    super.key,
    required this.selected,
    this.onChanged,
    this.readOnly = false,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'هل توصي بهذا المورد لمصانع أخرى؟',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: readOnly ? null : () => onChanged?.call(true),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selected == true
                            ? AppColors.success.withValues(alpha: 0.1)
                            : Colors.transparent,
                        borderRadius: AppRadius.rSM,
                        border: Border.all(
                          color: selected == true ? AppColors.success : AppColors.borderLight,
                          width: selected == true ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.thumb_up_rounded,
                              color: selected == true ? AppColors.success : Colors.grey, size: 28),
                          const SizedBox(height: 4),
                          Text(
                            'نعم، أوصي به',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: selected == true ? AppColors.success : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: readOnly ? null : () => onChanged?.call(false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selected == false
                            ? AppColors.error.withValues(alpha: 0.08)
                            : Colors.transparent,
                        borderRadius: AppRadius.rSM,
                        border: Border.all(
                          color: selected == false ? AppColors.error : AppColors.borderLight,
                          width: selected == false ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.thumb_down_rounded,
                              color: selected == false ? AppColors.error : Colors.grey, size: 28),
                          const SizedBox(height: 4),
                          Text(
                            'لا، لا أوصي به',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: selected == false ? AppColors.error : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// MediaGalleryWidget - Displays review images and videos in a gallery
class MediaGalleryWidget extends StatelessWidget {
  final List<String> images;
  final List<String> videos;
  const MediaGalleryWidget({super.key, required this.images, required this.videos});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty && videos.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الصور والمرئيات المرفقة',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length + videos.length,
            itemBuilder: (context, i) {
              if (i < images.length) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ClipRRect(
                    borderRadius: AppRadius.rSM,
                    child: Image.network(
                      images[i],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_rounded),
                      ),
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: AppRadius.rSM,
                    ),
                    child: const Icon(Icons.play_circle_rounded, color: Colors.white, size: 36),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
