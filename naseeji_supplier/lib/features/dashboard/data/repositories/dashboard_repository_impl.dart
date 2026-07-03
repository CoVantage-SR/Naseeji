import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/sales_stats.dart';
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
}

@riverpod
DashboardRepository dashboardRepository(DashboardRepositoryRef ref) {
  return DashboardRepositoryImpl();
}
