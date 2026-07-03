import '../entities/sales_stats.dart';

abstract class DashboardRepository {
  Future<SalesStats> getSalesStats();
}
