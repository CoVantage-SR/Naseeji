import '../../data/repositories/deals_repository_impl.dart';
import '../entities/deal_model.dart';

class PaymentService {
  final DealsRepository _repository;

  PaymentService(this._repository);

  Future<bool> releasePayment(String dealId) async {
    return _repository.updateDealStatus(dealId, DealStatus.completed);
  }
}


