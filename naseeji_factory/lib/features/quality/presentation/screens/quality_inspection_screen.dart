import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../providers/quality_provider.dart';
import '../widgets/quality_inspection_widgets.dart';

class QualityInspectionScreen extends ConsumerWidget {
  final String orderId;

  const QualityInspectionScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(ordersNotifierProvider.notifier).getOrderById(orderId);

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('خطأ')),
        body: const Center(child: Text('الطلب المطلوب غير موجود.')),
      );
    }

    final qualityState = ref.watch(qualityNotifierProvider.select(
      (notifierMap) => notifierMap[orderId] ?? ref.read(qualityNotifierProvider.notifier).getOrCreateState(orderId),
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('تقرير فحص الجودة'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              QualityHeaderWidget(order: order),
              AppSpacing.hMD,
              OverallScoreWidget(
                score: qualityState.overallScore,
                ratingText: qualityState.scoreRatingText,
              ),
              AppSpacing.hMD,
              InspectionCategoriesWidget(
                orderId: orderId,
                ratings: qualityState.categoryRatings,
                onRatingChanged: (category, val) {
                  ref.read(qualityNotifierProvider.notifier).updateCategoryRating(
                        orderId,
                        category,
                        val,
                      );
                },
                onCommentChanged: (category, val) {
                  ref.read(qualityNotifierProvider.notifier).updateCategoryRating(
                        orderId,
                        category,
                        ref.read(qualityNotifierProvider.notifier).getOrCreateState(orderId)
                            .categoryRatings.firstWhere((element) => element.category == category).rating,
                        comment: val,
                      );
                },
              ),
              AppSpacing.hMD,
              QualityChecklistWidget(
                checklist: qualityState.qualityChecklist,
                onItemToggled: (item) {
                  ref.read(qualityNotifierProvider.notifier).updateQualityChecklist(
                        orderId,
                        item,
                        !(qualityState.qualityChecklist[item] ?? false),
                      );
                },
              ),
              AppSpacing.hMD,
              NotesWidget(
                notes: qualityState.notes,
                onChanged: (val) {
                  ref.read(qualityNotifierProvider.notifier).updateNotes(orderId, val);
                },
              ),
              AppSpacing.hLG,
              ApprovalWidget(
                onApprove: () {
                  ref.read(qualityNotifierProvider.notifier).approveQuality(orderId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم تأكيد جودة الطلب وتحديث حالة الدفع للمورد بنجاح.')),
                  );
                  context.go('/orders/$orderId');
                },
                onReject: () {
                  // Direct to reject screen to confirm rejection and file dispute
                  context.push('/orders/$orderId/reject-delivery');
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
