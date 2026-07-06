import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/production_preparation.dart';
import '../../data/repositories/orders_repository_impl.dart';

part 'production_preparation_controller.g.dart';

@riverpod
class ProductionPreparationController extends _$ProductionPreparationController {
  @override
  FutureOr<ProductionPreparation> build(String rfqId) async {
    final repo = ref.watch(ordersRepositoryProvider);
    return repo.getProductionPreparation(rfqId);
  }

  void updateProgress(double value) {
    if (state.valueOrNull != null) {
      final updated = ProductionPreparation(
        rfqId: state.value!.rfqId,
        progressPercent: value,
        currentPhase: _getPhaseFromProgress(value),
        estimatedFinishDate: state.value!.estimatedFinishDate,
        preparationImages: state.value!.preparationImages,
        productVideoUrl: state.value!.productVideoUrl,
        qualityInspectionImages: state.value!.qualityInspectionImages,
        packagingImages: state.value!.packagingImages,
        preparationNotes: state.value!.preparationNotes,
      );
      state = AsyncValue.data(updated);
    }
  }

  String _getPhaseFromProgress(double progress) {
    if (progress < 25.0) return 'Preparing Materials';
    if (progress < 50.0) return 'Manufacturing';
    if (progress < 75.0) return 'Quality Inspection';
    if (progress < 95.0) return 'Packaging';
    return 'Ready To Ship';
  }
}
