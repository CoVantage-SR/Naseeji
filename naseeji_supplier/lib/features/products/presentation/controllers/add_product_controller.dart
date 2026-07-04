import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/product_form_data.dart';

part 'add_product_controller.g.dart';

@riverpod
class AddProductController extends _$AddProductController {
  @override
  ProductFormData build() {
    return const ProductFormData();
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateCategory(String category) {
    state = state.copyWith(category: category);
  }

  void updateDescription(String description) {
    state = state.copyWith(description: description);
  }

  void updateProductNature(String nature) {
    state = state.copyWith(productNature: nature);
  }

  void updateAvailableForDirectOrder(bool value) {
    state = state.copyWith(availableForDirectOrder: value);
  }

  void setStep(int step) {
    state = state.copyWith(currentStep: step);
  }
}
