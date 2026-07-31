import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/entities/supplier_header_model.dart';
import '../../domain/entities/task_item_model.dart';
import '../../domain/entities/active_order_model.dart';
import '../../domain/entities/rfq_item_model.dart';
import '../../domain/entities/finance_overview_model.dart';
import '../../domain/entities/subscription_overview_model.dart';
import '../../domain/entities/notification_item_model.dart';
import '../../domain/usecases/get_task_dashboard_data_usecases.dart';

// Repository Provider
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl();
});

// Use Cases Providers
final getSupplierHeaderUseCaseProvider = Provider<GetSupplierHeaderUseCase>((ref) {
  final repo = ref.watch(dashboardRepositoryProvider);
  return GetSupplierHeaderUseCase(repo);
});

final getTodayTasksUseCaseProvider = Provider<GetTodayTasksUseCase>((ref) {
  final repo = ref.watch(dashboardRepositoryProvider);
  return GetTodayTasksUseCase(repo);
});

final getActiveOrdersUseCaseProvider = Provider<GetActiveOrdersUseCase>((ref) {
  final repo = ref.watch(dashboardRepositoryProvider);
  return GetActiveOrdersUseCase(repo);
});

final getRecentRfqsUseCaseProvider = Provider<GetRecentRfqsUseCase>((ref) {
  final repo = ref.watch(dashboardRepositoryProvider);
  return GetRecentRfqsUseCase(repo);
});

final getFinanceSummaryUseCaseProvider = Provider<GetFinanceSummaryUseCase>((ref) {
  final repo = ref.watch(dashboardRepositoryProvider);
  return GetFinanceSummaryUseCase(repo);
});

final getSubscriptionOverviewUseCaseProvider = Provider<GetSubscriptionOverviewUseCase>((ref) {
  final repo = ref.watch(dashboardRepositoryProvider);
  return GetSubscriptionOverviewUseCase(repo);
});

final getRecentNotificationsUseCaseProvider = Provider<GetRecentNotificationsUseCase>((ref) {
  final repo = ref.watch(dashboardRepositoryProvider);
  return GetRecentNotificationsUseCase(repo);
});

// Explicit Task-Driven Riverpod Providers (Exact Names Requested)

/// 1. Supplier Header Provider
final supplierHeaderProvider = FutureProvider.autoDispose<SupplierHeaderModel>((ref) async {
  final useCase = ref.watch(getSupplierHeaderUseCaseProvider);
  return useCase();
});

/// 2. Today's Tasks Provider (Sorted by Priority: Urgent -> Today -> Waiting -> Informational)
final todayTasksProvider = FutureProvider.autoDispose<List<TaskItemModel>>((ref) async {
  final useCase = ref.watch(getTodayTasksUseCaseProvider);
  return useCase();
});

/// 3. Active Orders Provider
final ordersProvider = FutureProvider.autoDispose<List<ActiveOrderModel>>((ref) async {
  final useCase = ref.watch(getActiveOrdersUseCaseProvider);
  return useCase();
});

/// 4. RFQs Provider
final rfqsProvider = FutureProvider.autoDispose<List<RfqItemModel>>((ref) async {
  final useCase = ref.watch(getRecentRfqsUseCaseProvider);
  return useCase();
});

/// 5. Finance Provider
final financeProvider = FutureProvider.autoDispose<FinanceOverviewModel>((ref) async {
  final useCase = ref.watch(getFinanceSummaryUseCaseProvider);
  return useCase();
});

/// 6. Subscription Provider
final subscriptionProvider = FutureProvider.autoDispose<SubscriptionOverviewModel>((ref) async {
  final useCase = ref.watch(getSubscriptionOverviewUseCaseProvider);
  return useCase();
});

/// 7. Notifications Provider (Latest 3 notifications)
final notificationsProvider = FutureProvider.autoDispose<List<NotificationItemModel>>((ref) async {
  final useCase = ref.watch(getRecentNotificationsUseCaseProvider);
  return useCase();
});


