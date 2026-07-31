import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/product_model.dart';
import '../../domain/entities/product_subscription_limit_model.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/products_remote_datasource.dart';

part 'products_repository_impl.g.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDatasource _remoteDatasource;

  ProductsRepositoryImpl({ProductsRemoteDatasource? remoteDatasource})
      : _remoteDatasource = remoteDatasource ?? ProductsRemoteDatasourceImpl();

  @override
  Future<List<ProductModel>> getProducts({
    String? statusFilter,
    String? categoryFilter,
    String? searchQuery,
  }) {
    return _remoteDatasource.fetchProducts(
      statusFilter: statusFilter,
      categoryFilter: categoryFilter,
      searchQuery: searchQuery,
    );
  }

  @override
  Future<ProductModel> getProductDetails(String productId) {
    return _remoteDatasource.fetchProductDetails(productId);
  }

  @override
  Future<bool> updateProductStatus(String productId, ProductStatus newStatus) {
    return _remoteDatasource.updateProductStatus(productId, newStatus);
  }

  @override
  Future<ProductModel> duplicateProduct(String productId) {
    return _remoteDatasource.duplicateProduct(productId);
  }

  @override
  Future<ProductSubscriptionLimitModel> getSubscriptionLimits() {
    return _remoteDatasource.fetchSubscriptionLimits();
  }
}

@riverpod
ProductsRepository productsRepository(ProductsRepositoryRef ref) {
  return ProductsRepositoryImpl();
}



