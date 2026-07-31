import '../entities/product_performance_model.dart';
import '../../data/repositories/products_repository_impl.dart';

class AnalyticsService {
  final ProductsRepositoryImpl _repository;

  AnalyticsService(this._repository);

  Future<ProductPerformanceModel> getProductAnalytics(String productId) async {
    final product = await _repository.getProductDetails(productId);
    return product.performance;
  }
}


