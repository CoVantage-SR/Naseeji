import '../entities/sales_stats.dart';
import '../entities/analytics_data.dart';

abstract class DashboardRepository {
  Future<SalesStats> getSalesStats();
  Future<AnalyticsData> getAnalyticsData();
}
