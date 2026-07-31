import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../providers/reviews_provider.dart';
import '../widgets/rate_supplier_widgets.dart';
import '../widgets/reviews_reusable_widgets.dart';

class RateSupplierScreen extends ConsumerWidget {
  final String orderId;
  const RateSupplierScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersNotifierProvider);
    final notifier = ref.read(reviewsNotifierProvider.notifier);

    final OrderModel? order = () {
      try {
        return orders.firstWhere((o) => o.id == orderId);
      } catch (_) {
        return null;
      }
    }();

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('تقييم المورد')),
        body: const Center(child: Text('لم يتم العثور على الطلب.')),
      );
    }

    final overallRating = ref.watch(
      reviewsNotifierProvider.select((s) => notifier.getDraftOverallRating(orderId)),
    );
    final recommendation = ref.watch(
      reviewsNotifierProvider.select((s) => notifier.getDraftRecommendation(orderId)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('تقييم المورد'),
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
              RateSupplierHeaderWidget(orderId: orderId),
              AppSpacing.hMD,
              SupplierSummaryWidget(
                supplierName: order.supplierName,
                productName: order.productName,
                orderDate: order.orderDate,
              ),
              AppSpacing.hMD,
              OverallRatingWidget(rating: overallRating),
              AppSpacing.hMD,
              CategoryRatingsWidget(
                ratings: {
                  for (final cat in kRatingCategories)
                    cat: notifier.getDraftCategoryRating(orderId, cat),
                },
                onRatingChanged: (cat, val) {
                  notifier.updateDraftCategoryRating(orderId, cat, val);
                },
              ),
              AppSpacing.hMD,
              RecommendationCard(
                selected: recommendation,
                onChanged: (val) => notifier.updateDraftRecommendation(orderId, val),
              ),
              AppSpacing.hLG,
              RateSubmitWidget(
                isEnabled: overallRating > 0,
                onSubmit: () => context.push('/reviews/write/$orderId'),
                onCancel: () => context.pop(),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}



