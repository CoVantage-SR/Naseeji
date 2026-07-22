import '../../data/repositories/deals_repository_impl.dart';
import '../entities/deal_model.dart';

class DealService {
  final DealsRepository _repository;

  DealService(this._repository);

  Future<List<DealModel>> getDeals({
    DealStatus? statusFilter,
    String? searchQuery,
    bool onlyActionRequired = false,
  }) async {
    return _repository.getDeals(
      statusFilter: statusFilter,
      searchQuery: searchQuery,
      onlyActionRequired: onlyActionRequired,
    );
  }

  Future<DealModel> getDealById(String dealId) async {
    return _repository.getDealById(dealId);
  }

  Future<bool> updateStatus(String dealId, DealStatus newStatus) async {
    return _repository.updateDealStatus(dealId, newStatus);
  }
}
