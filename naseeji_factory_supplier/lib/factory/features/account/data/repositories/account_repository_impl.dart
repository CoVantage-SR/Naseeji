import '../datasources/account_mock_database.dart';
import '../../domain/entities/account_entities.dart';
import '../../domain/repositories/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountMockDatabase _db = AccountMockDatabase.instance;

  @override
  Future<FactoryProfileEntity> getFactoryProfile() async {
    return _db.factoryProfile;
  }

  @override
  Future<void> updateFactoryProfile(FactoryProfileEntity profile) async {
    _db.updateFactoryProfile(profile);
  }

  @override
  Future<WalletEntity> getWallet() async {
    return _db.wallet;
  }

  @override
  Future<void> withdrawMoney(double amount, String bankId) async {
    _db.withdrawMoney(amount, bankId);
  }

  @override
  Future<void> depositMoney(double amount) async {
    _db.depositMoney(amount);
  }

  @override
  Future<RewardStateEntity> getRewards() async {
    return _db.rewards;
  }

  @override
  Future<void> redeemReward(RewardItemEntity reward) async {
    _db.redeemReward(reward);
  }

  @override
  Future<List<EmployeeEntity>> getEmployees() async {
    return _db.employees;
  }

  @override
  Future<void> addEmployee(EmployeeEntity employee) async {
    _db.addEmployee(employee);
  }

  @override
  Future<void> updateEmployee(EmployeeEntity employee) async {
    _db.updateEmployee(employee);
  }

  @override
  Future<void> removeEmployee(String employeeId) async {
    _db.removeEmployee(employeeId);
  }

  @override
  Future<List<NotificationItemEntity>> getNotifications() async {
    return _db.notifications;
  }

  @override
  Future<void> markNotificationRead(String notificationId) async {
    _db.markNotificationRead(notificationId);
  }

  @override
  Future<void> markAllNotificationsRead() async {
    _db.markAllNotificationsRead();
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    _db.deleteNotification(notificationId);
  }

  @override
  Future<void> renewSubscription(String planName) async {
    _db.renewSubscription(planName);
  }

  @override
  Future<List<SupportTicketEntity>> getSupportTickets() async {
    return _db.supportTickets;
  }

  @override
  Future<void> createSupportTicket(String subject, String category, String details) async {
    _db.createSupportTicket(subject, category, details);
  }

  @override
  Future<List<LoginSessionEntity>> getLoginSessions() async {
    return _db.loginSessions;
  }

  @override
  Future<void> logoutAllSessions() async {
    _db.logoutAllSessions();
  }
}



