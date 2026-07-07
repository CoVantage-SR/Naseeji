import '../entities/agreement_model.dart';

abstract class AgreementsRepository {
  Future<List<B2BAgreement>> getAgreements();
  Future<B2BAgreement?> getAgreementDetails(String id);
  Future<void> approveAgreement(String id);
  Future<void> rejectAgreement(String id, String reason);
  Future<void> requestModification(String id, String notes);
  Future<void> uploadContractDocument(String id, String type, String name, String url);
}
