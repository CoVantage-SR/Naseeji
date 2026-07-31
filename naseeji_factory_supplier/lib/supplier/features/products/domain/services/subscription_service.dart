import '../entities/product_subscription_limit_model.dart';
import '../../data/repositories/products_repository_impl.dart';

class SubscriptionService {
  final ProductsRepositoryImpl _repository;

  SubscriptionService(this._repository);

  Future<ProductSubscriptionLimitModel> getLimits() async {
    return _repository.getSubscriptionLimits();
  }
}
