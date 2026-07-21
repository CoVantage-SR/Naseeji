import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/entities/supplier_header_model.dart';
import '../../domain/entities/dashboard_stats_model.dart';
import '../../domain/entities/subscription_overview_model.dart';
import '../../domain/entities/rfq_item_model.dart';
import '../../domain/entities/orders_overview_model.dart';
import '../../domain/entities/finance_overview_model.dart';
import '../../domain/entities/performance_overview_model.dart';
import '../../domain/entities/notification_item_model.dart';
import '../../domain/entities/quick_action_item_model.dart';
import '../../domain/usecases/get_supplier_dashboard_data_usecase.dart';

// Repository Provider
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl();
});

// Use Cases Providers
final getSupplierHeaderUseCaseProvider = Provider<GetSupplierHeaderUseCase>((ref) {
  final repo = ref.watch(dashboardRepositoryProvider);
  return GetSupplierHeaderUseCase(repo);
});

final getDashboardStatsUseCaseProvider = Provider<GetDashboardStatsUseCase>((ref) {
  final repo = ref.watch(dashboardRepositoryProvider);
  return GetDashboardStatsUseCase(repo);
});

final getSubscriptionOverviewUseCaseProvider = Provider<GetSubscriptionOverviewUseCase>((ref) {
  final repo = ref.watch(dashboardRepositoryProvider);
  return GetSubscriptionOverviewUseCase(repo);
});

final getRecentRfqsUseCaseProvider = Provider<GetRecentRfqsUseCase>((ref) {
  final repo = ref.watch(dashboardRepositoryProvider);
  return GetRecentRfqsUseCase(repo);
});

final getOrdersOverviewUseCaseProvider = Provider<GetOrdersOverviewUseCase>((ref) {
  final repo = ref.watch(dashboardRepositoryProvider);
  return GetOrdersOverviewUseCase(repo);
});

final getFinanceOverviewUseCaseProvider = Provider<GetFinanceOverviewUseCase>((ref) {
  final repo = ref.watch(dashboardRepositoryProvider);
  return GetFinanceOverviewUseCase(repo);
});

final getPerformanceOverviewUseCaseProvider = Provider<GetPerformanceOverviewUseCase>((ref) {
  final repo = ref.watch(dashboardRepositoryProvider);
  return GetPerformanceOverviewUseCase(repo);
});

final getRecentNotificationsUseCaseProvider = Provider<GetRecentNotificationsUseCase>((ref) {
  final repo = ref.watch(dashboardRepositoryProvider);
  return GetRecentNotificationsUseCase(repo);
});

final getQuickActionsUseCaseProvider = Provider<GetQuickActionsUseCase>((ref) {
  final repo = ref.watch(dashboardRepositoryProvider);
  return GetQuickActionsUseCase(repo);
});

// Explicit Feature Riverpod Providers (as requested)

/// 1. Supplier Header Provider
final supplierHeaderProvider = FutureProvider.autoDispose<SupplierHeaderModel>((ref) async {
  final useCase = ref.watch(getSupplierHeaderUseCaseProvider);
  return useCase();
});

/// 2. Dashboard Stats Provider (Business Overview Cards)
final dashboardStatsProvider = FutureProvider.autoDispose<DashboardStatsModel>((ref) async {
  final useCase = ref.watch(getDashboardStatsUseCaseProvider);
  return useCase();
});

/// 3. Subscription Status Provider
final subscriptionProvider = FutureProvider.autoDispose<SubscriptionOverviewModel>((ref) async {
  final useCase = ref.watch(getSubscriptionOverviewUseCaseProvider);
  return useCase();
});

/// 4. RFQ Activity Provider
final rfqOverviewProvider = FutureProvider.autoDispose<List<RfqItemModel>>((ref) async {
  final useCase = ref.watch(getRecentRfqsUseCaseProvider);
  return useCase();
});

/// 5. Orders Overview Provider
final ordersOverviewProvider = FutureProvider.autoDispose<OrdersOverviewModel>((ref) async {
  final useCase = ref.watch(getOrdersOverviewUseCaseProvider);
  return useCase();
});

/// 6. Financial Summary Provider
final financeProvider = FutureProvider.autoDispose<FinanceOverviewModel>((ref) async {
  final useCase = ref.watch(getFinanceOverviewUseCaseProvider);
  return useCase();
});

/// 7. Supplier Performance Provider
final performanceProvider = FutureProvider.autoDispose<PerformanceOverviewModel>((ref) async {
  final useCase = ref.watch(getPerformanceOverviewUseCaseProvider);
  return useCase();
});

/// 8. Notifications Provider
final notificationsProvider = FutureProvider.autoDispose<List<NotificationItemModel>>((ref) async {
  final useCase = ref.watch(getRecentNotificationsUseCaseProvider);
  return useCase();
});

/// 9. Quick Actions Provider
final quickActionsProvider = FutureProvider.autoDispose<List<QuickActionItemModel>>((ref) async {
  final useCase = ref.watch(getQuickActionsUseCaseProvider);
  return useCase();
});
