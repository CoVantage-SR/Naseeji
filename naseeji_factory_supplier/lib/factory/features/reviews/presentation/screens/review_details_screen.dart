import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/reviews_provider.dart';
import '../widgets/review_details_widgets.dart';
import '../widgets/reviews_reusable_widgets.dart';

class ReviewDetailsScreen extends ConsumerWidget {
  final String reviewId;
  const ReviewDetailsScreen({super.key, required this.reviewId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(reviewsNotifierProvider.notifier);
    final review = notifier.getReviewById(reviewId);

    if (review == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('تفاصيل التقييم')),
        body: const Center(child: Text('لم يتم العثور على التقييم.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل التقييم'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReviewInformationWidget(review: review),
              AppSpacing.hMD,
              RatingsBreakdownWidget(categoryRatings: review.categoryRatings),
              AppSpacing.hMD,
              MediaGalleryWidget(images: review.images, videos: review.videos),
              if (review.images.isNotEmpty || review.videos.isNotEmpty) AppSpacing.hMD,
              if (review.supplierReply != null)
                SupplierReplyCard(
                  supplierName: review.supplierName,
                  replyText: review.supplierReply!,
                  replyDate: review.replyDate ?? '',
                ),
              if (review.supplierReply != null) AppSpacing.hMD,
              ActionButtonsWidget(
                onEdit: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('يمكن تعديل التقييم خلال ٧ أيام من تاريخ نشره.')),
                  );
                },
                onDelete: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('حذف التقييم'),
                      content: const Text('هل أنت متأكد من حذف هذا التقييم؟ لا يمكن التراجع عن هذا الإجراء.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('إلغاء'),
                        ),
                        TextButton(
                          onPressed: () {
                            notifier.deleteReview(reviewId);
                            Navigator.pop(context);
                            context.pop();
                          },
                          child: const Text('حذف', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                onReport: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم إرسال بلاغك. سيتم مراجعته من الفريق المختص.')),
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

