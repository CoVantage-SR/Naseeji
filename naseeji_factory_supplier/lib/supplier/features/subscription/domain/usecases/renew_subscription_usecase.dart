import '../repositories/subscription_repository.dart';

class RenewSubscriptionUseCase {
  final SubscriptionRepository repository;

  RenewSubscriptionUseCase(this.repository);

  Future<bool> execute() {
    return repository.renewSubscription();
  }
}

