import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/analytics_data.dart';
import '../../data/repositories/dashboard_repository_impl.dart';

part 'analytics_controller.g.dart';

@riverpod
class AnalyticsController extends _$AnalyticsController {
  @override
  FutureOr<AnalyticsData> build() async {
    final repo = ref.watch(dashboardRepositoryProvider);
    return repo.getAnalyticsData();
  }

  Future<void> refreshAnalytics() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(dashboardRepositoryProvider);
      return repo.getAnalyticsData();
    });
  }
}


