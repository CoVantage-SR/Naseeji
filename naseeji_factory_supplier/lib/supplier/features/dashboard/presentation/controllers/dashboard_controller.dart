import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/sales_stats.dart';
import '../providers/dashboard_providers.dart';

class DashboardController extends AutoDisposeAsyncNotifier<SalesStats> {
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

final dashboardControllerProvider =
    AsyncNotifierProvider.autoDispose<DashboardController, SalesStats>(
  DashboardController.new,
);



