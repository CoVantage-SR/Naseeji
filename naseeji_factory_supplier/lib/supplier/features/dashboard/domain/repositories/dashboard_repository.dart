import '../entities/supplier_header_model.dart';
import '../entities/task_item_model.dart';
import '../entities/active_order_model.dart';
import '../entities/rfq_item_model.dart';
import '../entities/finance_overview_model.dart';
import '../entities/subscription_overview_model.dart';
import '../entities/notification_item_model.dart';
import '../entities/sales_stats.dart';
import '../entities/analytics_data.dart';

abstract class DashboardRepository {
  Future<SupplierHeaderModel> getSupplierHeader();
  Future<List<TaskItemModel>> getTodayTasks();
  Future<List<ActiveOrderModel>> getActiveOrders();
  Future<List<RfqItemModel>> getRecentRfqs();
  Future<FinanceOverviewModel> getFinanceSummary();
  Future<SubscriptionOverviewModel> getSubscriptionOverview();
  Future<List<NotificationItemModel>> getRecentNotifications();

  // Legacy compatibility
  Future<SalesStats> getSalesStats();
  Future<AnalyticsData> getAnalyticsData();
}
