import '../entities/account_entities.dart';
import '../repositories/account_repository.dart';

class GetAccountDataUseCase {
  final AccountRepository repository;
  GetAccountDataUseCase(this.repository);

  Future<FactoryProfileEntity> getProfile() => repository.getFactoryProfile();
  Future<WalletEntity> getWallet() => repository.getWallet();
  Future<RewardStateEntity> getRewards() => repository.getRewards();
  Future<List<EmployeeEntity>> getEmployees() => repository.getEmployees();
}

class ManageWalletUseCase {
  final AccountRepository repository;
  ManageWalletUseCase(this.repository);

  Future<void> withdraw(double amount, String bankId) => repository.withdrawMoney(amount, bankId);
  Future<void> deposit(double amount) => repository.depositMoney(amount);
}

class ManageRewardsUseCase {
  final AccountRepository repository;
  ManageRewardsUseCase(this.repository);

  Future<void> redeem(RewardItemEntity reward) => repository.redeemReward(reward);
}

class ManageEmployeesUseCase {
  final AccountRepository repository;
  ManageEmployeesUseCase(this.repository);

  Future<void> add(EmployeeEntity employee) => repository.addEmployee(employee);
  Future<void> update(EmployeeEntity employee) => repository.updateEmployee(employee);
  Future<void> remove(String id) => repository.removeEmployee(id);
}

class ManageNotificationsUseCase {
  final AccountRepository repository;
  ManageNotificationsUseCase(this.repository);

  Future<void> markRead(String id) => repository.markNotificationRead(id);
  Future<void> markAllRead() => repository.markAllNotificationsRead();
  Future<void> delete(String id) => repository.deleteNotification(id);
}
