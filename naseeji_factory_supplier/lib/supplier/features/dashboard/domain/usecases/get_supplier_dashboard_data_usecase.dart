import '../entities/supplier_header_model.dart';
import '../entities/task_item_model.dart';
import '../entities/active_order_model.dart';
import '../entities/rfq_item_model.dart';
import '../entities/finance_overview_model.dart';
import '../entities/subscription_overview_model.dart';
import '../entities/notification_item_model.dart';
import '../repositories/dashboard_repository.dart';

class GetSupplierHeaderUseCase {
  final DashboardRepository _repository;
  const GetSupplierHeaderUseCase(this._repository);

  Future<SupplierHeaderModel> call() => _repository.getSupplierHeader();
}

class GetTodayTasksUseCase {
  final DashboardRepository _repository;
  const GetTodayTasksUseCase(this._repository);

  Future<List<TaskItemModel>> call() async {
    final tasks = await _repository.getTodayTasks();
    tasks.sort((a, b) => a.priority.index.compareTo(b.priority.index));
    return tasks;
  }
}

class GetActiveOrdersUseCase {
  final DashboardRepository _repository;
  const GetActiveOrdersUseCase(this._repository);

  Future<List<ActiveOrderModel>> call() => _repository.getActiveOrders();
}

class GetRecentRfqsUseCase {
  final DashboardRepository _repository;
  const GetRecentRfqsUseCase(this._repository);

  Future<List<RfqItemModel>> call() => _repository.getRecentRfqs();
}

class GetFinanceSummaryUseCase {
  final DashboardRepository _repository;
  const GetFinanceSummaryUseCase(this._repository);

  Future<FinanceOverviewModel> call() => _repository.getFinanceSummary();
}

class GetSubscriptionOverviewUseCase {
  final DashboardRepository _repository;
  const GetSubscriptionOverviewUseCase(this._repository);

  Future<SubscriptionOverviewModel> call() => _repository.getSubscriptionOverview();
}

class GetRecentNotificationsUseCase {
  final DashboardRepository _repository;
  const GetRecentNotificationsUseCase(this._repository);

  Future<List<NotificationItemModel>> call() async {
    final notifs = await _repository.getRecentNotifications();
    return notifs.take(3).toList();
  }
}



