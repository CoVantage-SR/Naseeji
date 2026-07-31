import '../entities/account_entities.dart';

abstract class AccountRepository {
  Future<FactoryProfileEntity> getFactoryProfile();
  Future<void> updateFactoryProfile(FactoryProfileEntity profile);
  Future<WalletEntity> getWallet();
  Future<void> withdrawMoney(double amount, String bankId);
  Future<void> depositMoney(double amount);
  Future<RewardStateEntity> getRewards();
  Future<void> redeemReward(RewardItemEntity reward);
  Future<List<EmployeeEntity>> getEmployees();
  Future<void> addEmployee(EmployeeEntity employee);
  Future<void> updateEmployee(EmployeeEntity employee);
  Future<void> removeEmployee(String employeeId);
  Future<List<NotificationItemEntity>> getNotifications();
  Future<void> markNotificationRead(String notificationId);
  Future<void> markAllNotificationsRead();
  Future<void> deleteNotification(String notificationId);
  Future<void> renewSubscription(String planName);
  Future<List<SupportTicketEntity>> getSupportTickets();
  Future<void> createSupportTicket(String subject, String category, String details);
  Future<List<LoginSessionEntity>> getLoginSessions();
  Future<void> logoutAllSessions();
}


