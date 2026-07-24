import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/features/dashboard/presentation/providers/dashboard_providers.dart';
import '../widgets/supplier_home_header.dart';
import '../widgets/subscription_banner.dart';
import '../widgets/quick_metrics_overview.dart';
import '../widgets/today_tasks_section.dart';
import '../widgets/quick_shortcuts_and_chart.dart';
import '../widgets/notifications_bottom_banner.dart';

class SupplierHomeScreen extends ConsumerStatefulWidget {
  const SupplierHomeScreen({super.key});

  @override
  ConsumerState<SupplierHomeScreen> createState() => _SupplierHomeScreenState();
}

class _SupplierHomeScreenState extends ConsumerState<SupplierHomeScreen> {
  late final ScrollController _scrollController;
  bool _showNotificationBubble = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      if (_scrollController.offset > 15 && _showNotificationBubble) {
        setState(() {
          _showNotificationBubble = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl, // Force Arabic RTL Layout across the entire screen
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _showNotificationBubble = true;
              });
              ref.invalidate(supplierHeaderProvider);
              ref.invalidate(subscriptionProvider);
              ref.invalidate(todayTasksProvider);
              ref.invalidate(notificationsProvider);
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // 1. Header (Avatar, Greeting, Verified Badge, Subscription Card, Notification Popover)
                SliverToBoxAdapter(
                  child: SupplierHomeHeader(
                    showNotificationBubble: _showNotificationBubble,
                  ),
                ),

                // 2. Subscription Warning Banner (If < 7 days remaining)
                const SliverToBoxAdapter(
                  child: SubscriptionBanner(),
                ),

                // 3. Quick Metrics Grid (Products, Deals, RFQs, Total Sales)
                const SliverToBoxAdapter(
                  child: QuickMetricsOverviewWidget(),
                ),

                // 4. Quick Shortcuts Grid & Sales Performance Chart Card
                const SliverToBoxAdapter(
                  child: QuickShortcutsAndChartWidget(),
                ),

                // 5. Today Tasks Section (Task Cards matching reference design)
                const SliverToBoxAdapter(
                  child: TodayTasksSection(),
                ),

                // 6. Notifications Bottom Banner
                const SliverToBoxAdapter(
                  child: NotificationsBottomBannerWidget(),
                ),

                // 7. Bottom Clearance Padding
                const SliverPadding(
                  padding: EdgeInsets.only(bottom: 90),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
