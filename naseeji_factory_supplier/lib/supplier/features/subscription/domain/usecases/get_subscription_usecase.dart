import 'package:naseeji_factory/supplier/core/mock/subscription_mock.dart';
import '../repositories/subscription_repository.dart';

class GetSubscriptionUseCase {
  final SubscriptionRepository repository;

  GetSubscriptionUseCase(this.repository);

  Future<SubscriptionModel> execute() {
    return repository.getSubscription();
  }
}

