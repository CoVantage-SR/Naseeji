import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/sales_stats.dart';
import '../../domain/entities/analytics_data.dart';
import '../../domain/repositories/dashboard_repository.dart';

part 'dashboard_repository_impl.g.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  @override
  Future<SalesStats> getSalesStats() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return const SalesStats(
      todaySales: 2500.0,
      monthlyEarnings: 45000.0,
      pendingOrders: 12,
      activeProducts: 154,
      weeklySales: [80.0, 60.0, 70.0, 30.0, 50.0, 20.0, 90.0],
    );
  }

  @override
  Future<AnalyticsData> getAnalyticsData() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const AnalyticsData(
      totalSales: 45230.0,
      salesTrend: '+12%',
      isSalesTrendPositive: true,
      netProfits: 12840.0,
      profitsTrend: '+8%',
      isProfitsTrendPositive: true,
      totalCustomers: 1240,
      customersTrend: '+5%',
      isCustomersTrendPositive: true,
      completedOrders: 856,
      ordersTrend: '-2%',
      isOrdersTrendPositive: false,
      barData: [
        {'day': 'الجمعة', 'value': 0.5, 'isHighlight': false},
        {'day': 'الخميس', 'value': 0.85, 'isHighlight': true},
        {'day': 'الأربعاء', 'value': 0.7, 'isHighlight': false},
        {'day': 'الثلاثاء', 'value': 0.6, 'isHighlight': false},
        {'day': 'الاثنين', 'value': 0.4, 'isHighlight': false},
        {'day': 'الأحد', 'value': 0.55, 'isHighlight': false},
        {'day': 'السبت', 'value': 0.35, 'isHighlight': false},
      ],
      readyForShippingPercentage: 0.68,
      cottonOrders: 450,
      silkOrders: 210,
      syntheticOrders: 196,
    );
  }
}

@riverpod
DashboardRepository dashboardRepository(DashboardRepositoryRef ref) {
  return DashboardRepositoryImpl();
}
