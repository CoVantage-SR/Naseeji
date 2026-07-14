import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/home_provider.dart';
import '../providers/notifications_provider.dart';
import '../widgets/home_drawer.dart';
import '../widgets/home_widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _showGreeting = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _showGreeting = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeDataProvider);
    final notifications = ref.watch(notificationsNotifierProvider);
    final unreadCount = notifications.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: HomeAppBarWidget(
        factoryName: 'مصنع النسيج الحديث',
        logoUrl: '',
        notificationCount: unreadCount,
        onNotificationTap: () => checkGuestAction(context, ref, () => context.push('/notifications')),
        onAvatarTap: () => checkGuestAction(context, ref, () => context.push('/mini-profile')),
      ),
      drawer: const HomeDrawer(currentRoute: '/home'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 400),
                  firstChild: Column(
                    children: [
                      const GreetingCardWidget(factoryName: 'مصنع النسيج الحديث'),
                      AppSpacing.hLG,
                    ],
                  ),
                  secondChild: const SizedBox.shrink(),
                  crossFadeState: _showGreeting
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                ),
                FactorySummaryCardWidget(stats: homeState.summaryStats),
                AppSpacing.hLG,
                const StatisticsCardsWidget(),
                AppSpacing.hLG,
                LatestRFQWidget(
                  rfqs: homeState.latestRfqs,
                  onActionTap: () => checkGuestAction(context, ref, () => context.go('/rfq')),
                ),
                AppSpacing.hLG,
                CurrentOrdersWidget(
                  orders: homeState.currentOrders,
                  onActionTap: () => checkGuestAction(context, ref, () => context.go('/orders')),
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
