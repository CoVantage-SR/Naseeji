import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../subscription/presentation/controllers/subscription_controllers.dart';
import '../../../../subscription/presentation/widgets/subscription_card.dart';
import '../shared/dashboard_section_title.dart';
import '../shared/loading_widget.dart';
import '../shared/error_state_widget.dart';

class SubscriptionCardWidget extends ConsumerWidget {
  const SubscriptionCardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subAsync = ref.watch(activeSubscriptionControllerProvider);
    final usageAsync = ref.watch(subscriptionUsageControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardSectionTitle(
          title: 'اشتراك الباقة والحدود',
          subtitle: 'متابعة رصيد المنتجات والوسائط وطلبات الأسعار',
          icon: Icons.workspace_premium_rounded,
          actionText: 'إدارة الباقة',
          onActionTap: () => context.push('/subscription/manage'),
        ),
        subAsync.when(
          loading: () => const LoadingWidget(height: 140),
          error: (err, stack) => ErrorStateWidget(
            message: 'خطأ في تحميل بيانات الاشتراك: $err',
            onRetry: () =>
                ref.invalidate(activeSubscriptionControllerProvider),
          ),
          data: (sub) => usageAsync.when(
            loading: () => const LoadingWidget(height: 140),
            error: (err, stack) => ErrorStateWidget(
              message: 'خطأ في تحميل استهلاك الاشتراك: $err',
              onRetry: () =>
                  ref.invalidate(subscriptionUsageControllerProvider),
            ),
            data: (usage) => SubscriptionCard(
              subscription: sub,
              usage: usage,
              onManagePressed: () => context.push('/subscription/manage'),
              onUpgradePressed: () => context.push('/subscription/manage'),
            ),
          ),
        ),
      ],
    );
  }
}


