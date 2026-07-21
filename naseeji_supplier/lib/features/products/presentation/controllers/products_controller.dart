import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product_model.dart';
import '../providers/products_providers.dart';

class ProductsControllerState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const ProductsControllerState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  ProductsControllerState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return ProductsControllerState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

class ProductsController extends StateNotifier<ProductsControllerState> {
  final Ref _ref;

  ProductsController(this._ref) : super(const ProductsControllerState());

  Future<void> toggleProductStatus(String productId, ProductStatus newStatus) async {
    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
    try {
      final useCase = _ref.read(updateProductStatusUseCaseProvider);
      final success = await useCase(productId, newStatus);
      if (success) {
        _ref.invalidate(productsListProvider);
        _ref.invalidate(productDetailsProvider(productId));
        state = state.copyWith(
          isLoading: false,
          successMessage: 'تم تحديث حالة المنتج بنجاح',
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'تعذر تغيير حالة المنتج',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'خطأ: $e',
      );
    }
  }

  Future<void> duplicateProduct(String productId) async {
    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
    try {
      final useCase = _ref.read(duplicateProductUseCaseProvider);
      final duplicated = await useCase(productId);
      _ref.invalidate(productsListProvider);
      state = state.copyWith(
        isLoading: false,
        successMessage: 'تم نسخ المنتج "${duplicated.name}" كمسودة جديدة',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'خطأ أثناء نسخ المنتج: $e',
      );
    }
  }
}

final productsControllerProvider =
    StateNotifierProvider.autoDispose<ProductsController, ProductsControllerState>((ref) {
  return ProductsController(ref);
});
