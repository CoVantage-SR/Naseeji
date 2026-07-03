import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/sales_stats.dart';
import '../../data/repositories/dashboard_repository_impl.dart';

part 'dashboard_controller.g.dart';

@riverpod
class DashboardController extends _$DashboardController {
  @override
  FutureOr<SalesStats> build() async {
    final repo = ref.watch(dashboardRepositoryProvider);
    return repo.getSalesStats();
  }

  Future<void> refreshStats() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(dashboardRepositoryProvider);
      return repo.getSalesStats();
    });
  }
}
