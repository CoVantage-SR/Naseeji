import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/reviews_provider.dart';
import '../widgets/reviews_widgets.dart';

class ReviewsScreen extends ConsumerStatefulWidget {
  final String supplierId;
  const ReviewsScreen({super.key, required this.supplierId});

  @override
  ConsumerState<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends ConsumerState<ReviewsScreen> {
  static const List<String> _filters = [
    'الكل',
    '5 نجوم',
    '4 نجوم',
    '3 نجوم',
    'مع صور',
    'مع فيديو',
  ];
  String _selectedFilter = 'الكل';

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(reviewsNotifierProvider.notifier);
    var reviews = notifier.getReviewsBySupplier(widget.supplierId);
    final avgRating = notifier.getAverageRating(widget.supplierId);
    final breakdown = notifier.getRatingBreakdown(widget.supplierId);

    // If no supplier-specific reviews, show all for demo
    if (reviews.isEmpty) {
      reviews = ref.watch(reviewsNotifierProvider).reviews;
    }

    // Apply filter
    if (_selectedFilter == '5 نجوم') {
      reviews = reviews.where((r) => r.overallRating >= 4.5).toList();
    } else if (_selectedFilter == '4 نجوم') {
      reviews = reviews.where((r) => r.overallRating >= 3.5 && r.overallRating < 4.5).toList();
    } else if (_selectedFilter == '3 نجوم') {
      reviews = reviews.where((r) => r.overallRating >= 2.5 && r.overallRating < 3.5).toList();
    } else if (_selectedFilter == 'مع صور') {
      reviews = reviews.where((r) => r.images.isNotEmpty).toList();
    } else if (_selectedFilter == 'مع فيديو') {
      reviews = reviews.where((r) => r.videos.isNotEmpty).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('تقييمات المورد'),
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
              OverallStatisticsWidget(
                avgRating: avgRating > 0 ? avgRating : 4.3,
                totalReviews: reviews.length,
                breakdown: breakdown.isNotEmpty ? breakdown : {5: 2, 4: 1, 3: 0, 2: 0, 1: 0},
              ),
              AppSpacing.hMD,
              ReviewFiltersWidget(
                filters: _filters,
                selected: _selectedFilter,
                onChanged: (val) => setState(() => _selectedFilter = val),
              ),
              AppSpacing.hMD,
              ReviewsListWidget(
                reviews: reviews,
                onReviewTap: (id) => context.push('/reviews/details/$id'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}



