import '../entities/supplier_header_model.dart';
import '../entities/dashboard_stats_model.dart';
import '../entities/subscription_overview_model.dart';
import '../entities/rfq_item_model.dart';
import '../entities/orders_overview_model.dart';
import '../entities/finance_overview_model.dart';
import '../entities/performance_overview_model.dart';
import '../entities/notification_item_model.dart';
import '../entities/quick_action_item_model.dart';
import '../repositories/dashboard_repository.dart';

class GetSupplierHeaderUseCase {
  final DashboardRepository _repository;
  const GetSupplierHeaderUseCase(this._repository);

  Future<SupplierHeaderModel> call() => _repository.getSupplierHeader();
}

class GetDashboardStatsUseCase {
  final DashboardRepository _repository;
  const GetDashboardStatsUseCase(this._repository);

  Future<DashboardStatsModel> call() => _repository.getDashboardStats();
}

class GetSubscriptionOverviewUseCase {
  final DashboardRepository _repository;
  const GetSubscriptionOverviewUseCase(this._repository);

  Future<SubscriptionOverviewModel> call() => _repository.getSubscriptionOverview();
}

class GetRecentRfqsUseCase {
  final DashboardRepository _repository;
  const GetRecentRfqsUseCase(this._repository);

  Future<List<RfqItemModel>> call() => _repository.getRecentRfqs();
}

class GetOrdersOverviewUseCase {
  final DashboardRepository _repository;
  const GetOrdersOverviewUseCase(this._repository);

  Future<OrdersOverviewModel> call() => _repository.getOrdersOverview();
}

class GetFinanceOverviewUseCase {
  final DashboardRepository _repository;
  const GetFinanceOverviewUseCase(this._repository);

  Future<FinanceOverviewModel> call() => _repository.getFinanceOverview();
}

class GetPerformanceOverviewUseCase {
  final DashboardRepository _repository;
  const GetPerformanceOverviewUseCase(this._repository);

  Future<PerformanceOverviewModel> call() => _repository.getPerformanceOverview();
}

class GetRecentNotificationsUseCase {
  final DashboardRepository _repository;
  const GetRecentNotificationsUseCase(this._repository);

  Future<List<NotificationItemModel>> call() => _repository.getRecentNotifications();
}

class GetQuickActionsUseCase {
  final DashboardRepository _repository;
  const GetQuickActionsUseCase(this._repository);

  Future<List<QuickActionItemModel>> call() => _repository.getQuickActions();
}
