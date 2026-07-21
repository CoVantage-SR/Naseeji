import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/widgets/app_bottom_navigation_bar.dart';
import '../controllers/supplier_dashboard_controller.dart';
import '../widgets/header/supplier_header_widget.dart';
import '../widgets/overview/business_overview_grid_widget.dart';
import '../widgets/quick_actions/quick_action_grid_widget.dart';
import '../widgets/subscription/subscription_overview_widget.dart';
import '../widgets/rfq/recent_rfq_widget.dart';
import '../widgets/orders/orders_overview_widget.dart';
import '../widgets/finance/finance_overview_widget.dart';
import '../widgets/performance/performance_overview_widget.dart';
import '../widgets/notifications/recent_notifications_widget.dart';
import 'drawer/navigation_drawer_view.dart';

class SupplierDashboardScreen extends ConsumerWidget {
  const SupplierDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final dashboardState = ref.watch(supplierDashboardControllerProvider);

    return Scaffold(
      key: scaffoldKey,
      drawer: const NavigationDrawerView(),
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, child) {
            return RefreshIndicator(
              onRefresh: () =>
                  ref.read(supplierDashboardControllerProvider.notifier).refreshAll(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Error Banner if refresh failed
                    if (dashboardState.errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              color: Theme.of(context).colorScheme.onErrorContainer,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                dashboardState.errorMessage!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.onErrorContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Section 1: Header
                    SupplierHeaderWidget(
                      onOpenDrawer: () => scaffoldKey.currentState?.openDrawer(),
                    ),
                    const SizedBox(height: 16),

                    // Section 2: Business Overview Cards
                    const BusinessOverviewGridWidget(),
                    const SizedBox(height: 20),

                    // Section 8: Quick Actions
                    const QuickActionGridWidget(),
                    const SizedBox(height: 20),

                    // Section 3: Subscription Status
                    const SubscriptionOverviewWidget(),
                    const SizedBox(height: 20),

                    // Section 4: RFQ Activity
                    const RecentRFQWidget(),
                    const SizedBox(height: 20),

                    // Section 5: Orders Overview
                    const OrdersOverviewWidget(),
                    const SizedBox(height: 20),

                    // Section 6: Financial Summary
                    const FinanceOverviewWidget(),
                    const SizedBox(height: 20),

                    // Section 7: Supplier Performance
                    const PerformanceOverviewWidget(),
                    const SizedBox(height: 20),

                    // Section 9: Notifications
                    const RecentNotificationsWidget(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 0),
    );
  }
}
