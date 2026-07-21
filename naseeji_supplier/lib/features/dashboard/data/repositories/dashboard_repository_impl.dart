import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/supplier_header_model.dart';
import '../../domain/entities/dashboard_stats_model.dart';
import '../../domain/entities/subscription_overview_model.dart';
import '../../domain/entities/rfq_item_model.dart';
import '../../domain/entities/orders_overview_model.dart';
import '../../domain/entities/finance_overview_model.dart';
import '../../domain/entities/performance_overview_model.dart';
import '../../domain/entities/notification_item_model.dart';
import '../../domain/entities/quick_action_item_model.dart';
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
  Future<DashboardStatsModel> getDashboardStats() => _remoteDatasource.fetchDashboardStats();

  @override
  Future<SubscriptionOverviewModel> getSubscriptionOverview() => _remoteDatasource.fetchSubscriptionOverview();

  @override
  Future<List<RfqItemModel>> getRecentRfqs() => _remoteDatasource.fetchRecentRfqs();

  @override
  Future<OrdersOverviewModel> getOrdersOverview() => _remoteDatasource.fetchOrdersOverview();

  @override
  Future<FinanceOverviewModel> getFinanceOverview() => _remoteDatasource.fetchFinanceOverview();

  @override
  Future<PerformanceOverviewModel> getPerformanceOverview() => _remoteDatasource.fetchPerformanceOverview();

  @override
  Future<List<NotificationItemModel>> getRecentNotifications() => _remoteDatasource.fetchRecentNotifications();

  @override
  Future<List<QuickActionItemModel>> getQuickActions() => _remoteDatasource.fetchQuickActions();

  // Legacy compatibility implementations
  @override
  Future<SalesStats> getSalesStats() async {
    final stats = await getDashboardStats();
    return SalesStats(
      todaySales: 2500.0,
      monthlyEarnings: stats.monthlyRevenue,
      pendingOrders: stats.ordersInProduction,
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
