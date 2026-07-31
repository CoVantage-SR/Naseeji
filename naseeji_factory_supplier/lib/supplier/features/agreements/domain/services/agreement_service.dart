import '../entities/agreement_model.dart';
import '../repositories/agreements_repository.dart';
import 'agreement_workflow_service.dart';

class AgreementService {
  final AgreementsRepository _repository;

  AgreementService(this._repository);

  Future<List<B2BAgreement>> getAgreements({AgreementStatus? statusFilter, String? searchQuery}) async {
    final list = await _repository.getAgreements();
    return list.where((a) {
      if (statusFilter != null && a.status != statusFilter) {
        return false;
      }
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.trim().toLowerCase();
        final matchId = a.id.toLowerCase().contains(q);
        final matchRfq = a.rfqNumber.toLowerCase().contains(q);
        final matchSupplier = a.supplierInfo.companyName.toLowerCase().contains(q);
        final matchFactory = a.factoryInfo.factoryName.toLowerCase().contains(q);
        final matchProduct = a.product.name.toLowerCase().contains(q);
        return matchId || matchRfq || matchSupplier || matchFactory || matchProduct;
      }
      return true;
    }).toList();
  }

  Future<B2BAgreement?> getAgreementById(String id) async {
    return _repository.getAgreementDetails(id);
  }

  Future<B2BAgreement> signAgreementBySupplier(
    String agreementId, {
    required String supplierUserId,
    required String supplierUserName,
  }) async {
    final agreement = await _repository.getAgreementDetails(agreementId);
    if (agreement == null) {
      throw Exception('الاتفاقية غير موجودة برقم $agreementId');
    }

    final workflowResult = AgreementWorkflowService.processSupplierSignature(
      agreement: agreement,
      supplierUserId: supplierUserId,
      supplierUserName: supplierUserName,
    );

    await _repository.updateAgreement(workflowResult.agreement);
    return workflowResult.agreement;
  }

  Future<B2BAgreement> signAgreementByFactory(
    String agreementId, {
    required String factoryUserId,
    required String factoryUserName,
  }) async {
    final agreement = await _repository.getAgreementDetails(agreementId);
    if (agreement == null) {
      throw Exception('الاتفاقية غير موجودة برقم $agreementId');
    }

    final workflowResult = AgreementWorkflowService.processFactorySignature(
      agreement: agreement,
      factoryUserId: factoryUserId,
      factoryUserName: factoryUserName,
    );

    await _repository.updateAgreement(workflowResult.agreement);
    return workflowResult.agreement;
  }

  Future<B2BAgreement> startProduction(String agreementId) async {
    final agreement = await _repository.getAgreementDetails(agreementId);
    if (agreement == null) {
      throw Exception('الاتفاقية غير موجودة برقم $agreementId');
    }

    final workflowResult = AgreementWorkflowService.moveToProduction(agreement);
    await _repository.updateAgreement(workflowResult.agreement);
    return workflowResult.agreement;
  }

  Future<B2BAgreement> cancelAgreement(String agreementId, String reason) async {
    await _repository.rejectAgreement(agreementId, reason);
    final updated = await _repository.getAgreementDetails(agreementId);
    return updated!;
  }
}



