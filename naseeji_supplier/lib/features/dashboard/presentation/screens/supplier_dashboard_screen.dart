import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/supplier_dashboard_controller.dart';
import '../widgets/header/supplier_header_widget.dart';
import '../widgets/today_tasks/today_tasks_widget.dart';
import '../widgets/active_orders/active_orders_widget.dart';
import '../widgets/rfq/recent_rfq_widget.dart';
import '../widgets/finance/finance_summary_widget.dart';
import '../widgets/subscription/subscription_card_widget.dart';
import '../widgets/notifications/recent_notifications_widget.dart';
import '../widgets/quick_actions/quick_actions_bottom_sheet.dart';
import 'drawer/navigation_drawer_view.dart';

class SupplierDashboardScreen extends ConsumerWidget {
  const SupplierDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final dashboardState = ref.watch(supplierDashboardControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      key: scaffoldKey,
      drawer: const NavigationDrawerView(),
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'home_quick_action_fab',
        onPressed: () => QuickActionsBottomSheet.show(context),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        icon: const Icon(Icons.flash_on_rounded),
        label: const Text(
          'عملية سريعة',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
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
                          color: colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              color: colorScheme.onErrorContainer,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                dashboardState.errorMessage!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme.onErrorContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Section 1: Header (Greeting, Supplier Name, Badges, Notification & Profile)
                    SupplierHeaderWidget(
                      onOpenDrawer: () => scaffoldKey.currentState?.openDrawer(),
                    ),
                    const SizedBox(height: 16),

                    // Section 2: Today's Tasks (🔴 Urgent -> 🟠 Today -> 🟡 Waiting -> 🟢 Informational)
                    const TodayTasksWidget(),
                    const SizedBox(height: 20),

                    // Section 3: Active Orders Workflow Cards
                    const ActiveOrdersWidget(),
                    const SizedBox(height: 20),

                    // Section 4: RFQs (Recent RFQs & Action Buttons)
                    const RecentRFQsWidget(),
                    const SizedBox(height: 20),

                    // Section 5: Finance Summary (Revenue, Escrow, Pending, Released, Invoices)
                    const FinanceSummaryWidget(),
                    const SizedBox(height: 20),

                    // Section 6: Subscription Card (Compact Tier Limits & Expiry)
                    const SubscriptionCardWidget(),
                    const SizedBox(height: 20),

                    // Section 7: Notifications (Latest 3 Notifications)
                    const RecentNotificationsWidget(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
