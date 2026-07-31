import '../entities/quotation_model.dart';

abstract class QuotationsRepository {
  Future<List<QuotationModel>> getQuotations();
  Future<QuotationModel?> getQuotationDetails(String id);
  Future<void> saveQuotation(QuotationModel quotation);
  Future<void> deleteQuotation(String id);
  Future<void> sendQuotation(String id);
  Future<void> withdrawQuotation(String id);
  Future<void> acceptQuotation(String id);
  Future<void> rejectQuotation(String id, String reason);
  Future<void> updateQuotationStatus(String id, QuotationStatus status);
}


