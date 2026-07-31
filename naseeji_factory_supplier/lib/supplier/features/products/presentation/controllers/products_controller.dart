import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product_model.dart';
import '../../domain/services/product_service.dart';
import '../../domain/services/product_validation_service.dart';
import '../providers/products_providers.dart';

class ProductsController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  ProductsController(this._ref) : super(const AsyncValue.data(null));

  ProductService get _service => _ref.read(productServiceProvider);

  Future<void> updateStatus(String productId, ProductStatus newStatus) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _service.updateStatus(productId, newStatus);
      _ref.invalidate(productsProvider);
      _ref.invalidate(productDetailsProvider(productId));
    });
  }

  Future<void> updateStock(String productId, int newStock) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _service.updateStock(productId, newStock);
      _ref.invalidate(productsProvider);
      _ref.invalidate(productDetailsProvider(productId));
    });
  }

  Future<void> duplicateProduct(String productId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _service.duplicate(productId);
      _ref.invalidate(productsProvider);
    });
  }

  Future<void> archiveProduct(String productId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _service.archive(productId);
      _ref.invalidate(productsProvider);
    });
  }

  Future<ValidationResult> validateAddProduct() async {
    final limits = await _ref.read(subscriptionLimitsProvider.future);
    final validator = _ref.read(productValidationServiceProvider);
    return validator.validateAddProduct(limits);
  }
}

final productsControllerProvider = StateNotifierProvider<ProductsController, AsyncValue<void>>((ref) {
  return ProductsController(ref);
});


