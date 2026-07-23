import '../repositories/subscription_repository.dart';

class ValidateProductLimitsUseCase {
  final SubscriptionRepository repository;

  ValidateProductLimitsUseCase(this.repository);

  Future<String?> executeAddProduct() {
    return repository.validateAddProduct();
  }

  Future<String?> executeMediaUpload({required String type, required int currentCount}) {
    return repository.validateMediaUpload(type: type, currentCount: currentCount);
  }
}
