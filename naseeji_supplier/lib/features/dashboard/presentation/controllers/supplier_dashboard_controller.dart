import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dashboard_providers.dart';

class SupplierDashboardState {
  final bool isRefreshing;
  final String? errorMessage;
  final DateTime lastRefreshedAt;

  SupplierDashboardState({
    this.isRefreshing = false,
    this.errorMessage,
    DateTime? lastRefreshedAt,
  }) : lastRefreshedAt = lastRefreshedAt ?? DateTime.now();

  SupplierDashboardState copyWith({
    bool? isRefreshing,
    String? errorMessage,
    DateTime? lastRefreshedAt,
  }) {
    return SupplierDashboardState(
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: errorMessage,
      lastRefreshedAt: lastRefreshedAt ?? this.lastRefreshedAt,
    );
  }
}

class SupplierDashboardController extends StateNotifier<SupplierDashboardState> {
  final Ref _ref;

  SupplierDashboardController(this._ref) : super(SupplierDashboardState());

  /// Refreshes all dashboard providers concurrently
  Future<void> refreshAll() async {
    state = state.copyWith(isRefreshing: true, errorMessage: null);

    try {
      _ref.invalidate(supplierHeaderProvider);
      _ref.invalidate(dashboardStatsProvider);
      _ref.invalidate(subscriptionProvider);
      _ref.invalidate(rfqOverviewProvider);
      _ref.invalidate(ordersOverviewProvider);
      _ref.invalidate(financeProvider);
      _ref.invalidate(performanceProvider);
      _ref.invalidate(notificationsProvider);
      _ref.invalidate(quickActionsProvider);

      // Wait for primary providers to resolve
      await Future.wait([
        _ref.read(supplierHeaderProvider.future),
        _ref.read(dashboardStatsProvider.future),
        _ref.read(subscriptionProvider.future),
        _ref.read(rfqOverviewProvider.future),
        _ref.read(ordersOverviewProvider.future),
        _ref.read(financeProvider.future),
        _ref.read(performanceProvider.future),
        _ref.read(notificationsProvider.future),
        _ref.read(quickActionsProvider.future),
      ]);

      state = state.copyWith(
        isRefreshing: false,
        lastRefreshedAt: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        isRefreshing: false,
        errorMessage: 'فشل في تحديث بيانات لوحة التحكم: $e',
      );
    }
  }
}

final supplierDashboardControllerProvider =
    StateNotifierProvider.autoDispose<SupplierDashboardController, SupplierDashboardState>((ref) {
  return SupplierDashboardController(ref);
});
