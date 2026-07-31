import '../entities/product_model.dart';
import '../entities/product_subscription_limit_model.dart';

abstract class ProductsRepository {
  Future<List<ProductModel>> getProducts({
    String? statusFilter,
    String? categoryFilter,
    String? searchQuery,
  });

  Future<ProductModel> getProductDetails(String productId);

  Future<bool> updateProductStatus(String productId, ProductStatus newStatus);

  Future<ProductModel> duplicateProduct(String productId);

  Future<ProductSubscriptionLimitModel> getSubscriptionLimits();
}

