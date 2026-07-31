import '../entities/product_model.dart';
import '../../data/repositories/products_repository_impl.dart';

class ProductService {
  final ProductsRepositoryImpl _repository;

  ProductService(this._repository);

  Future<List<ProductModel>> getProducts({
    String? statusFilter,
    String? categoryFilter,
    String? searchQuery,
    String? sortBy,
  }) async {
    final products = await _repository.getProducts(
      statusFilter: statusFilter,
      categoryFilter: categoryFilter,
      searchQuery: searchQuery,
    );

    if (sortBy == 'views') {
      products.sort((a, b) => b.viewsCount.compareTo(a.viewsCount));
    } else if (sortBy == 'updated') {
      products.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    } else if (sortBy == 'stock') {
      products.sort((a, b) => b.availableStock.compareTo(a.availableStock));
    }

    return products;
  }

  Future<ProductModel?> getProductById(String id) async {
    return _repository.getProductDetails(id);
  }

  Future<bool> updateStatus(String productId, ProductStatus newStatus) async {
    return _repository.updateProductStatus(productId, newStatus);
  }

  Future<bool> updateStock(String productId, int newStock) async {
    final product = await _repository.getProductDetails(productId);
    final status = newStock <= 0 ? ProductStatus.outOfStock : (product.status == ProductStatus.outOfStock ? ProductStatus.published : product.status);
    product.copyWith(availableStock: newStock, status: status, updatedAt: DateTime.now());
    return true;
  }

  Future<ProductModel> duplicate(String productId) async {
    return _repository.duplicateProduct(productId);
  }

  Future<bool> archive(String productId) async {
    return _repository.updateProductStatus(productId, ProductStatus.archived);
  }
}
