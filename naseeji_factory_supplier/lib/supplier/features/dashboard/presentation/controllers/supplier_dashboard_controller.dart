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

  /// Refreshes all task-driven dashboard providers concurrently
  Future<void> refreshAll() async {
    state = state.copyWith(isRefreshing: true, errorMessage: null);

    try {
      _ref.invalidate(supplierHeaderProvider);
      _ref.invalidate(todayTasksProvider);
      _ref.invalidate(ordersProvider);
      _ref.invalidate(rfqsProvider);
      _ref.invalidate(financeProvider);
      _ref.invalidate(subscriptionProvider);
      _ref.invalidate(notificationsProvider);

      await Future.wait([
        _ref.read(supplierHeaderProvider.future),
        _ref.read(todayTasksProvider.future),
        _ref.read(ordersProvider.future),
        _ref.read(rfqsProvider.future),
        _ref.read(financeProvider.future),
        _ref.read(subscriptionProvider.future),
        _ref.read(notificationsProvider.future),
      ]);

      state = state.copyWith(
        isRefreshing: false,
        lastRefreshedAt: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        isRefreshing: false,
        errorMessage: 'فشل في تحديث مهام اللوحة: $e',
      );
    }
  }
}

final supplierDashboardControllerProvider =
    StateNotifierProvider.autoDispose<SupplierDashboardController, SupplierDashboardState>((ref) {
  return SupplierDashboardController(ref);
});
