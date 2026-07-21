import '../entities/product_model.dart';
import '../entities/product_subscription_limit_model.dart';
import '../repositories/products_repository.dart';

class GetProductsUseCase {
  final ProductsRepository _repository;
  const GetProductsUseCase(this._repository);

  Future<List<ProductModel>> call({
    String? statusFilter,
    String? categoryFilter,
    String? searchQuery,
  }) {
    return _repository.getProducts(
      statusFilter: statusFilter,
      categoryFilter: categoryFilter,
      searchQuery: searchQuery,
    );
  }
}

class GetProductDetailsUseCase {
  final ProductsRepository _repository;
  const GetProductDetailsUseCase(this._repository);

  Future<ProductModel> call(String productId) {
    return _repository.getProductDetails(productId);
  }
}

class UpdateProductStatusUseCase {
  final ProductsRepository _repository;
  const UpdateProductStatusUseCase(this._repository);

  Future<bool> call(String productId, ProductStatus newStatus) {
    return _repository.updateProductStatus(productId, newStatus);
  }
}

class DuplicateProductUseCase {
  final ProductsRepository _repository;
  const DuplicateProductUseCase(this._repository);

  Future<ProductModel> call(String productId) {
    return _repository.duplicateProduct(productId);
  }
}

class GetSubscriptionLimitsUseCase {
  final ProductsRepository _repository;
  const GetSubscriptionLimitsUseCase(this._repository);

  Future<ProductSubscriptionLimitModel> call() {
    return _repository.getSubscriptionLimits();
  }
}
