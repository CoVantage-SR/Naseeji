import '../../data/repositories/deals_repository_impl.dart';
import '../entities/deal_model.dart';

class ProductionService {
  final DealsRepository _repository;

  ProductionService(this._repository);

  Future<bool> updateProgress({
    required String dealId,
    required double progressPercent,
    required List<String> photoUrls,
    required List<String> videoUrls,
    String? notes,
  }) async {
    final production = ProductionData(
      progressPercent: progressPercent,
      photoUrls: photoUrls,
      videoUrls: videoUrls,
      notes: notes,
      lastUpdatedAt: DateTime.now(),
    );

    return _repository.updateProduction(dealId, production);
  }
}


