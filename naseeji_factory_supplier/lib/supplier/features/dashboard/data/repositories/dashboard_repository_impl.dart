import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/supplier_header_model.dart';
import '../../domain/entities/task_item_model.dart';
import '../../domain/entities/active_order_model.dart';
import '../../domain/entities/rfq_item_model.dart';
import '../../domain/entities/finance_overview_model.dart';
import '../../domain/entities/subscription_overview_model.dart';
import '../../domain/entities/notification_item_model.dart';
import '../../domain/entities/sales_stats.dart';
import '../../domain/entities/analytics_data.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';

part 'dashboard_repository_impl.g.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDatasource _remoteDatasource;

  DashboardRepositoryImpl({DashboardRemoteDatasource? remoteDatasource})
      : _remoteDatasource = remoteDatasource ?? DashboardRemoteDatasourceImpl();

  @override
  Future<SupplierHeaderModel> getSupplierHeader() => _remoteDatasource.fetchSupplierHeader();

  @override
  Future<List<TaskItemModel>> getTodayTasks() => _remoteDatasource.fetchTodayTasks();

  @override
  Future<List<ActiveOrderModel>> getActiveOrders() => _remoteDatasource.fetchActiveOrders();

  @override
  Future<List<RfqItemModel>> getRecentRfqs() => _remoteDatasource.fetchRecentRfqs();

  @override
  Future<FinanceOverviewModel> getFinanceSummary() => _remoteDatasource.fetchFinanceSummary();

  @override
  Future<SubscriptionOverviewModel> getSubscriptionOverview() => _remoteDatasource.fetchSubscriptionOverview();

  @override
  Future<List<NotificationItemModel>> getRecentNotifications() => _remoteDatasource.fetchRecentNotifications();

  // Legacy compatibility
  @override
  Future<SalesStats> getSalesStats() async {
    final fin = await getFinanceSummary();
    return SalesStats(
      todaySales: 2500.0,
      monthlyEarnings: fin.monthlyRevenue,
      pendingOrders: 3,
      activeProducts: 58,
      weeklySales: const [80.0, 60.0, 70.0, 30.0, 50.0, 20.0, 90.0],
    );
  }

  @override
  Future<AnalyticsData> getAnalyticsData() async {
    return const AnalyticsData(
      totalSales: 285400.0,
      salesTrend: '+14%',
      isSalesTrendPositive: true,
      netProfits: 84200.0,
      profitsTrend: '+11%',
      isProfitsTrendPositive: true,
      totalCustomers: 142,
      customersTrend: '+8%',
      isCustomersTrendPositive: true,
      completedOrders: 184,
      ordersTrend: '+15%',
      isOrdersTrendPositive: true,
      barData: [
        {'day': 'الجمعة', 'value': 0.5, 'isHighlight': false},
        {'day': 'الخميس', 'value': 0.85, 'isHighlight': true},
        {'day': 'الأربعاء', 'value': 0.7, 'isHighlight': false},
        {'day': 'الثلاثاء', 'value': 0.6, 'isHighlight': false},
        {'day': 'الاثنين', 'value': 0.4, 'isHighlight': false},
        {'day': 'الأحد', 'value': 0.55, 'isHighlight': false},
        {'day': 'السبت', 'value': 0.35, 'isHighlight': false},
      ],
      readyForShippingPercentage: 0.85,
      cottonOrders: 110,
      silkOrders: 42,
      syntheticOrders: 32,
    );
  }
}

@riverpod
DashboardRepository dashboardRepository(DashboardRepositoryRef ref) {
  return DashboardRepositoryImpl();
}
