import '../entities/supplier_header_model.dart';
import '../entities/dashboard_stats_model.dart';
import '../entities/subscription_overview_model.dart';
import '../entities/rfq_item_model.dart';
import '../entities/orders_overview_model.dart';
import '../entities/finance_overview_model.dart';
import '../entities/performance_overview_model.dart';
import '../entities/notification_item_model.dart';
import '../entities/quick_action_item_model.dart';
import '../entities/sales_stats.dart';
import '../entities/analytics_data.dart';

abstract class DashboardRepository {
  Future<SupplierHeaderModel> getSupplierHeader();
  Future<DashboardStatsModel> getDashboardStats();
  Future<SubscriptionOverviewModel> getSubscriptionOverview();
  Future<List<RfqItemModel>> getRecentRfqs();
  Future<OrdersOverviewModel> getOrdersOverview();
  Future<FinanceOverviewModel> getFinanceOverview();
  Future<PerformanceOverviewModel> getPerformanceOverview();
  Future<List<NotificationItemModel>> getRecentNotifications();
  Future<List<QuickActionItemModel>> getQuickActions();

  // Preserved legacy support for existing analytics/sales stats
  Future<SalesStats> getSalesStats();
  Future<AnalyticsData> getAnalyticsData();
}
