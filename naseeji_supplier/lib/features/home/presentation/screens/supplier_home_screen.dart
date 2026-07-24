import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/features/dashboard/presentation/providers/dashboard_providers.dart';
import '../widgets/supplier_home_header.dart';
import '../widgets/subscription_banner.dart';
import '../widgets/quick_metrics_overview.dart';
import '../widgets/today_tasks_section.dart';
import '../widgets/quick_shortcuts_and_chart.dart';
import '../widgets/notifications_bottom_banner.dart';
import '../widgets/quick_action_fab.dart';

class SupplierHomeScreen extends ConsumerWidget {
  const SupplierHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: const QuickActionFab(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(supplierHeaderProvider);
            ref.invalidate(subscriptionProvider);
            ref.invalidate(todayTasksProvider);
            ref.invalidate(notificationsProvider);
          },
          child: const CustomScrollView(
            slivers: [
              // 1. Header (Avatar, Greeting, Subtitle, Verified Badge, Subscription Overview Card)
              SliverToBoxAdapter(
                child: SupplierHomeHeader(),
              ),

              // 2. Subscription Warning Banner (If < 7 days remaining)
              SliverToBoxAdapter(
                child: SubscriptionBanner(),
              ),

              // 3. Quick Metrics Grid (Products, Deals, RFQs, Total Sales)
              SliverToBoxAdapter(
                child: QuickMetricsOverviewWidget(),
              ),

              // 4. Today Tasks Section (Task Cards)
              SliverToBoxAdapter(
                child: TodayTasksSection(),
              ),

              // 5. Quick Shortcuts Grid & Sales Performance Chart Card
              SliverToBoxAdapter(
                child: QuickShortcutsAndChartWidget(),
              ),

              // 6. Notifications Bottom Banner
              SliverToBoxAdapter(
                child: NotificationsBottomBannerWidget(),
              ),

              // 7. Bottom Clearance Padding
              SliverPadding(
                padding: EdgeInsets.only(bottom: 90),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
