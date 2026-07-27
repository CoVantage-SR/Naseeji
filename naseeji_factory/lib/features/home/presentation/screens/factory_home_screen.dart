import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/reusable_widgets.dart' show checkGuestAction;
import '../providers/factory_home_providers.dart';
import '../widgets/factory_home/active_deals_section.dart';
import '../widgets/factory_home/empty_state_widget.dart';
import '../widgets/factory_home/factory_filter_bottom_sheet.dart';
import '../widgets/factory_home/factory_home_header.dart';
import '../widgets/factory_home/factory_search_bar.dart';
import '../widgets/factory_home/favorite_suppliers_section.dart';
import '../widgets/factory_home/loading_widget.dart';
import '../widgets/factory_home/notifications_section.dart';
import '../widgets/factory_home/quick_actions_section.dart';
import '../widgets/factory_home/recent_quotations_section.dart';
import '../widgets/factory_home/recent_rfqs_section.dart';
import '../widgets/factory_home/today_tasks_section.dart';

class FactoryHomeScreen extends ConsumerWidget {
  const FactoryHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(factoryDashboardProvider);
            ref.invalidate(recentQuotationsProvider);
            ref.invalidate(rfqProvider);
            ref.invalidate(dealsProvider);
            ref.invalidate(suppliersProvider);
            ref.invalidate(notificationsProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Header (Factory Name, Verification, Notifications, Profile, Greeting)
                  _buildHeader(context, ref),

                  // 2. Search & Filter Bar
                  FactorySearchBar(
                    onSubmitted: (query) {
                      if (query.trim().isNotEmpty) {
                        context.push('/search?q=${Uri.encodeComponent(query)}');
                      }
                    },
                    onFilterTap: () => FactoryFilterBottomSheet.show(context),
                  ),

                  const SizedBox(height: 8),

                  // 3. Quick Actions
                  QuickActionsSection(
                    onSendRfq: () => checkGuestAction(context, ref, () => context.push('/rfq/create')),
                    onSearchSupplier: () => context.push('/suppliers'),
                    onOrders: () => checkGuestAction(context, ref, () => context.push('/orders')),
                    onDeals: () => checkGuestAction(context, ref, () => context.push('/orders')),
                  ),

                  const SizedBox(height: 12),

                  // 4. Today's Tasks Section
                  _buildTodayTasks(context, ref),

                  const SizedBox(height: 12),

                  // 5. Recent Quotations Section
                  _buildRecentQuotations(context, ref),

                  const SizedBox(height: 12),

                  // 6. Active Deals Section
                  _buildActiveDeals(context, ref),

                  const SizedBox(height: 12),

                  // 7. Recent RFQs Section
                  _buildRecentRFQs(context, ref),

                  const SizedBox(height: 12),

                  // 8. Favorite Suppliers Section
                  _buildFavoriteSuppliers(context, ref),

                  const SizedBox(height: 12),

                  // 9. Notifications Section
                  _buildNotifications(context, ref),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Granular Section Builders ---

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(factoryDashboardProvider);

    return dashboardAsync.when(
      data: (data) => FactoryHomeHeader(
        data: data,
        onNotificationsTap: () => checkGuestAction(context, ref, () => context.push('/notifications')),
        onProfileTap: () => checkGuestAction(context, ref, () => context.push('/account/profile')),
      ),
      loading: () => const LoadingWidget(height: 64),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildTodayTasks(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(factoryDashboardProvider);

    return dashboardAsync.when(
      data: (data) {
        if (data.todayTasks.isEmpty) {
          return const EmptyStateWidget(title: 'لا توجد مهام اليوم');
        }
        return TodayTasksSection(
          tasks: data.todayTasks,
          onTaskTap: (task) => checkGuestAction(context, ref, () => context.push(task.routePath)),
        );
      },
      loading: () => const LoadingWidget(height: 100),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildRecentQuotations(BuildContext context, WidgetRef ref) {
    final quotationsAsync = ref.watch(recentQuotationsProvider);

    return quotationsAsync.when(
      data: (quotes) {
        if (quotes.isEmpty) {
          return const EmptyStateWidget(title: 'لا توجد عروض أسعار');
        }
        return RecentQuotationsSection(
          quotations: quotes,
          onViewAll: () => checkGuestAction(context, ref, () => context.push('/rfq')),
          onQuotationTap: (quote) => checkGuestAction(
            context,
            ref,
            () => context.push('/rfq/quotation/${quote.id}'),
          ),
        );
      },
      loading: () => const LoadingWidget(height: 180),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildActiveDeals(BuildContext context, WidgetRef ref) {
    final dealsAsync = ref.watch(dealsProvider);

    return dealsAsync.when(
      data: (deals) {
        if (deals.isEmpty) {
          return const EmptyStateWidget(title: 'لا توجد صفقات نشطة');
        }
        return ActiveDealsSection(
          deals: deals,
          onViewAll: () => checkGuestAction(context, ref, () => context.push('/orders')),
          onDealTap: (deal) => checkGuestAction(
            context,
            ref,
            () => context.push('/orders/${deal.dealId.replaceAll('#', '')}'),
          ),
        );
      },
      loading: () => const LoadingWidget(height: 180),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildRecentRFQs(BuildContext context, WidgetRef ref) {
    final rfqsAsync = ref.watch(rfqProvider);

    return rfqsAsync.when(
      data: (rfqs) {
        if (rfqs.isEmpty) {
          return const EmptyStateWidget(title: 'لا توجد طلبات RFQ');
        }
        return RecentRFQsSection(
          rfqs: rfqs,
          onViewAll: () => checkGuestAction(context, ref, () => context.push('/rfq')),
          onRfqTap: (rfq) => checkGuestAction(
            context,
            ref,
            () => context.push('/rfq/${rfq.id}'),
          ),
        );
      },
      loading: () => const LoadingWidget(height: 180),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildFavoriteSuppliers(BuildContext context, WidgetRef ref) {
    final suppliersAsync = ref.watch(suppliersProvider);

    return suppliersAsync.when(
      data: (suppliers) {
        if (suppliers.isEmpty) {
          return const EmptyStateWidget(title: 'لا يوجد موردين مفضلين');
        }
        return FavoriteSuppliersSection(
          suppliers: suppliers,
          onViewAll: () => context.push('/favorite-suppliers'),
          onSupplierTap: (sup) => context.push('/suppliers/${sup.id}'),
        );
      },
      loading: () => const LoadingWidget(height: 150),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildNotifications(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return notificationsAsync.when(
      data: (notifs) {
        if (notifs.isEmpty) {
          return const EmptyStateWidget(title: 'لا توجد إشعارات جديدة');
        }
        return NotificationsSection(
          notifications: notifs,
          onViewAll: () => checkGuestAction(context, ref, () => context.push('/notifications')),
          onNotificationTap: (notif) => checkGuestAction(context, ref, () => context.push('/notifications')),
        );
      },
      loading: () => const LoadingWidget(height: 100),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
