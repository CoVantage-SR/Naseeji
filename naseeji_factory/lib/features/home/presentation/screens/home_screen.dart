import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/reusable_widgets.dart' show checkGuestAction;

// Import Providers
import '../providers/action_center_provider.dart';
import '../providers/activity_provider.dart';
import '../providers/current_orders_provider.dart';
import '../providers/favorite_suppliers_provider.dart';
import '../providers/home_statistics_provider.dart';
import '../providers/latest_rfq_provider.dart';
import '../providers/monthly_statistics_provider.dart';
import '../providers/quotation_provider.dart';
import '../providers/recommendation_provider.dart';
import '../providers/shipment_provider.dart';

// Import Widgets
import '../widgets/action_center/action_center_widget.dart';
import '../widgets/common/error_widget.dart' as common;
import '../widgets/common/shimmer_widget.dart';
import '../widgets/favorite_suppliers/favorite_suppliers_widget.dart';
import '../widgets/home_app_bar/home_app_bar_widget.dart';
import '../widgets/home_drawer.dart';
import '../widgets/latest_quotes/latest_quotation_widget.dart';
import '../widgets/latest_rfqs/latest_rfqs_widget.dart';
import '../widgets/monthly_statistics/monthly_statistics_widget.dart';
import '../widgets/orders/current_orders_widget.dart';
import '../widgets/quick_actions/quick_actions_widget.dart';
import '../widgets/recent_activity/recent_activity_widget.dart';
import '../widgets/recommendations/smart_recommendations_widget.dart';
import '../widgets/shipments/shipments_widget.dart';
import '../widgets/statistics/statistics_section_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hour = DateTime.now().hour;
    final greetingText = hour < 12 ? 'صباح الخير 👋' : 'مساء الخير 👋';
    const factoryNameText = 'مصنع النسيج الحديث';

    return Scaffold(
      appBar: HomeAppBarWidget(
        factoryName: factoryNameText,
        greeting: greetingText,
        notificationCount: 3, // Mock count or watch notification provider if available
        messageCount: 5, // Mock count
        onMenuPressed: () => Scaffold.of(context).openDrawer(),
        onSearchPressed: () => context.push('/search'),
        onMessagesPressed: () => checkGuestAction(context, ref, () => context.push('/chat')),
        onNotificationsPressed: () => checkGuestAction(context, ref, () => context.push('/notifications')),
      ),
      drawer: const HomeDrawer(currentRoute: '/home'),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Invalidate all providers to trigger a reload
            ref.invalidate(actionCenterProvider);
            ref.invalidate(homeStatisticsProvider);
            ref.invalidate(latestRfqProvider);
            ref.invalidate(quotationProvider);
            ref.invalidate(currentOrdersProvider);
            ref.invalidate(shipmentProvider);
            ref.invalidate(favoriteSuppliersProvider);
            ref.invalidate(monthlyStatisticsProvider);
            ref.invalidate(activityProvider);
            ref.invalidate(recommendationProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Action Center Alerts (Horizontal scrollable)
                  _buildActionCenterSection(ref),
                  AppSpacing.hMD,

                  // 2. Quick Actions Grid
                  _buildQuickActionsSection(context, ref),
                  AppSpacing.hLG,

                  // 3. Factory Statistics
                  _buildStatisticsSection(context, ref),
                  AppSpacing.hLG,

                  // 4. Monthly Purchasing Summary with Mini Line Chart
                  _buildMonthlyStatisticsSection(ref),
                  AppSpacing.hLG,

                  // 5. Latest RFQs Section
                  _buildLatestRFQsSection(context, ref),
                  AppSpacing.hLG,

                  // 6. Latest Received Quotations Section
                  _buildLatestQuotationsSection(context, ref),
                  AppSpacing.hLG,

                  // 7. Active Orders Section
                  _buildCurrentOrdersSection(context, ref),
                  AppSpacing.hLG,

                  // 8. Shipments Section
                  _buildShipmentsSection(context, ref),
                  AppSpacing.hLG,

                  // 9. Favorite Suppliers Grid
                  _buildFavoriteSuppliersSection(context, ref),
                  AppSpacing.hLG,

                  // 10. Smart AI Recommendations (Horizontal scrollable)
                  _buildRecommendationsSection(context, ref),
                  AppSpacing.hLG,

                  // 11. Recent Activities Timeline
                  _buildRecentActivitiesSection(context, ref),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- SECTION BUILDERS ---

  Widget _buildActionCenterSection(WidgetRef ref) {
    final state = ref.watch(actionCenterProvider);
    return state.when(
      data: (alerts) => ActionCenterWidget(
        alerts: alerts,
        onAlertTap: (alert) => checkGuestAction(
          ref.context,
          ref,
          () => ref.context.push(alert.routePath),
        ),
      ),
      loading: () => const ShimmerWidget(width: double.infinity, height: 90),
      error: (err, stack) => const SizedBox.shrink(), // Silently hide or show standard error
    );
  }

  Widget _buildQuickActionsSection(BuildContext context, WidgetRef ref) {
    return QuickActionsWidget(
      onCreateRfq: () => checkGuestAction(context, ref, () => context.push('/rfq')),
      onSearchSupplier: () => context.push('/search?type=suppliers'),
      onOrders: () => checkGuestAction(context, ref, () => context.push('/orders')),
      onMessages: () => checkGuestAction(context, ref, () => context.push('/chat')),
      onReports: () => checkGuestAction(context, ref, () => context.push('/statistics')),
      onFavoriteSuppliers: () => context.push('/search?type=suppliers&favorites=true'),
    );
  }

  Widget _buildStatisticsSection(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeStatisticsProvider);
    return state.when(
      data: (stats) => StatisticsSectionWidget(
        statistics: stats,
        onHeaderActionTap: () => checkGuestAction(context, ref, () => context.push('/statistics')),
        onCompletedOrdersTap: () => checkGuestAction(context, ref, () => context.push('/orders')),
        onPendingOrdersTap: () => checkGuestAction(context, ref, () => context.push('/orders')),
        onNewQuotesTap: () => checkGuestAction(context, ref, () => context.push('/rfq')),
        onShipmentsTap: () => checkGuestAction(context, ref, () => context.push('/orders')),
        onPurchasesTap: () => checkGuestAction(context, ref, () => context.push('/statistics')),
        onFavoritesTap: () => context.push('/search?type=suppliers&favorites=true'),
      ),
      loading: () => const Column(
        children: [
          ShimmerWidget(width: 150, height: 24),
          SizedBox(height: 12),
          ShimmerWidget(width: double.infinity, height: 200),
        ],
      ),
      error: (err, stack) => common.ErrorWidget(
        message: 'خطأ في تحميل الإحصاءات العامة',
        onRetry: () => ref.refresh(homeStatisticsProvider),
      ),
    );
  }

  Widget _buildMonthlyStatisticsSection(WidgetRef ref) {
    final state = ref.watch(monthlyStatisticsProvider);
    return state.when(
      data: (monthlyStats) => MonthlyStatisticsWidget(
        monthlyStats: monthlyStats,
        onHeaderActionTap: () => checkGuestAction(ref.context, ref, () => ref.context.push('/statistics')),
      ),
      loading: () => const ShimmerWidget(width: double.infinity, height: 160),
      error: (err, stack) => common.ErrorWidget(
        message: 'خطأ في تحميل تحليل المشتريات',
        onRetry: () => ref.refresh(monthlyStatisticsProvider),
      ),
    );
  }

  Widget _buildLatestRFQsSection(BuildContext context, WidgetRef ref) {
    final state = ref.watch(latestRfqProvider);
    return state.when(
      data: (rfqs) => LatestRFQsWidget(
        rfqs: rfqs,
        onHeaderActionTap: () => checkGuestAction(context, ref, () => context.push('/rfq')),
        onViewRfq: (rfq) => checkGuestAction(context, ref, () => context.push('/rfq/${rfq.id}')),
        onContinueRfq: (rfq) => checkGuestAction(context, ref, () => context.push('/rfq/${rfq.id}')),
      ),
      loading: () => const ShimmerWidget(width: double.infinity, height: 180),
      error: (err, stack) => common.ErrorWidget(
        message: 'خطأ في تحميل عروض الأسعار',
        onRetry: () => ref.refresh(latestRfqProvider),
      ),
    );
  }

  Widget _buildLatestQuotationsSection(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quotationProvider);
    return state.when(
      data: (quotes) => LatestQuotationWidget(
        quotations: quotes,
        onHeaderActionTap: () => checkGuestAction(context, ref, () => context.push('/rfq')),
        onCompareQuotation: (q) => checkGuestAction(context, ref, () => context.push('/rfq/comparison')),
        onApproveQuotation: (q) => checkGuestAction(context, ref, () => context.push('/rfq/approve')),
        onRejectQuotation: (q) => checkGuestAction(context, ref, () => context.push('/rfq/reject')),
      ),
      loading: () => const ShimmerWidget(width: double.infinity, height: 180),
      error: (err, stack) => common.ErrorWidget(
        message: 'خطأ في تحميل العروض المستلمة',
        onRetry: () => ref.refresh(quotationProvider),
      ),
    );
  }

  Widget _buildCurrentOrdersSection(BuildContext context, WidgetRef ref) {
    final state = ref.watch(currentOrdersProvider);
    return state.when(
      data: (orders) => CurrentOrdersWidget(
        orders: orders,
        onHeaderActionTap: () => checkGuestAction(context, ref, () => context.push('/orders')),
        onTrackOrder: (order) => checkGuestAction(context, ref, () => context.push('/orders/${order.orderNumber}')),
      ),
      loading: () => const ShimmerWidget(width: double.infinity, height: 180),
      error: (err, stack) => common.ErrorWidget(
        message: 'خطأ في تحميل الطلبات الجارية',
        onRetry: () => ref.refresh(currentOrdersProvider),
      ),
    );
  }

  Widget _buildShipmentsSection(BuildContext context, WidgetRef ref) {
    final state = ref.watch(shipmentProvider);
    return state.when(
      data: (shipments) => ShipmentsWidget(
        shipments: shipments,
        onHeaderActionTap: () => checkGuestAction(context, ref, () => context.push('/orders')),
        onTrackShipment: (shipment) => checkGuestAction(context, ref, () => context.push('/orders')), // default routing
      ),
      loading: () => const ShimmerWidget(width: double.infinity, height: 180),
      error: (err, stack) => common.ErrorWidget(
        message: 'خطأ في تحميل الشحنات',
        onRetry: () => ref.refresh(shipmentProvider),
      ),
    );
  }

  Widget _buildFavoriteSuppliersSection(BuildContext context, WidgetRef ref) {
    final state = ref.watch(favoriteSuppliersProvider);
    return state.when(
      data: (suppliers) => FavoriteSuppliersWidget(
        suppliers: suppliers,
        onHeaderActionTap: () => context.push('/search?type=suppliers&favorites=true'),
        onViewProfile: (sup) => context.push('/suppliers/${sup.id}'),
        onSendRfq: (sup) => checkGuestAction(context, ref, () => context.push('/rfq')),
      ),
      loading: () => const ShimmerWidget(width: double.infinity, height: 220),
      error: (err, stack) => common.ErrorWidget(
        message: 'خطأ في تحميل الموردين المفضلين',
        onRetry: () => ref.refresh(favoriteSuppliersProvider),
      ),
    );
  }

  Widget _buildRecommendationsSection(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recommendationProvider);
    return state.when(
      data: (recs) => SmartRecommendationsWidget(
        recommendations: recs,
        onRecommendationTap: (rec) => checkGuestAction(context, ref, () => context.push(rec.routePath)),
      ),
      loading: () => const ShimmerWidget(width: double.infinity, height: 130),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildRecentActivitiesSection(BuildContext context, WidgetRef ref) {
    final state = ref.watch(activityProvider);
    return state.when(
      data: (acts) => RecentActivityWidget(
        activities: acts,
        onHeaderActionTap: () => checkGuestAction(context, ref, () => context.push('/statistics')),
      ),
      loading: () => const ShimmerWidget(width: double.infinity, height: 200),
      error: (err, stack) => common.ErrorWidget(
        message: 'خطأ في تحميل سجل النشاطات',
        onRetry: () => ref.refresh(activityProvider),
      ),
    );
  }
}
