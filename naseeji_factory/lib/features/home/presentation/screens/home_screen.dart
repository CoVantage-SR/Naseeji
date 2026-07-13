import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/home_provider.dart';
import '../providers/notifications_provider.dart';
import '../widgets/home_drawer.dart';
import '../widgets/home_widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeDataProvider);
    final notifications = ref.watch(notificationsNotifierProvider);
    final unreadCount = notifications.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: HomeAppBarWidget(
        factoryName: 'مصنع النسيج الحديث',
        logoUrl: '',
        notificationCount: unreadCount,
        onNotificationTap: () => context.push('/notifications'),
        onAvatarTap: () => context.push('/mini-profile'),
      ),
      drawer: const HomeDrawer(currentRoute: '/home'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const GreetingCardWidget(factoryName: 'مصنع النسيج الحديث'),
                AppSpacing.hLG,
                FactorySummaryCardWidget(stats: homeState.summaryStats),
                AppSpacing.hLG,
                const QuickActionsWidget(),
                AppSpacing.hLG,
                const StatisticsCardsWidget(),
                AppSpacing.hLG,
                LatestRFQWidget(
                  rfqs: homeState.latestRfqs,
                  onActionTap: () => context.go('/rfq'),
                ),
                AppSpacing.hLG,
                CurrentOrdersWidget(
                  orders: homeState.currentOrders,
                  onActionTap: () => context.go('/orders'),
                ),
                AppSpacing.hLG,
                RecommendedSuppliersWidget(
                  suppliers: homeState.recommendedSuppliers,
                  onActionTap: () => context.push('/search?type=suppliers'),
                ),
                AppSpacing.hLG,
                RecentActivityWidget(activities: homeState.recentActivities),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
