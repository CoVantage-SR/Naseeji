import 'package:naseeji_factory/core/mock/subscription_mock.dart';
import '../repositories/subscription_repository.dart';

class UpgradePlanUseCase {
  final SubscriptionRepository repository;

  UpgradePlanUseCase(this.repository);

  Future<bool> execute(SubscriptionPlanMock plan) {
    return repository.upgradePlan(plan);
  }
}


