import '../../data/repositories/deals_repository_impl.dart';

class AgreementService {
  final DealsRepository _repository;

  AgreementService(this._repository);

  Future<bool> supplierSignAgreement(String dealId) async {
    return _repository.signAgreement(dealId, true);
  }

  Future<bool> factorySignAgreement(String dealId) async {
    return _repository.signAgreement(dealId, false);
  }
}
