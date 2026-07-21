import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/dashboard_providers.dart';
import '../shared/dashboard_section_title.dart';
import '../shared/subscription_card.dart';
import '../shared/loading_widget.dart';
import '../shared/error_state_widget.dart';

class SubscriptionCardWidget extends ConsumerWidget {
  const SubscriptionCardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subAsync = ref.watch(subscriptionProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardSectionTitle(
          title: 'اشتراك الباقة والحدود',
          subtitle: 'متابعة رصيد المنتجات وطلبات الأسعار المتاحة',
          icon: Icons.card_membership_rounded,
          actionText: 'إدارة الباقة',
          onActionTap: () => context.push('/subscription'),
        ),
        subAsync.when(
          loading: () => const LoadingWidget(height: 120),
          error: (err, stack) => ErrorStateWidget(
            message: 'خطأ في تحميل بيانات الاشتراك: $err',
            onRetry: () => ref.invalidate(subscriptionProvider),
          ),
          data: (sub) {
            return SubscriptionCard(subscription: sub);
          },
        ),
      ],
    );
  }
}
