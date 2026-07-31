import '../../data/repositories/deals_repository_impl.dart';
import '../entities/deal_model.dart';

class QuotationService {
  final DealsRepository _repository;

  QuotationService(this._repository);

  Future<bool> sendQuotation({
    required String dealId,
    required double unitPrice,
    required int quantity,
    required int productionDays,
    required String paymentTerms,
    String? notes,
  }) async {
    final quotation = QuotationData(
      quoteId: 'Q-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      unitPrice: unitPrice,
      quantity: quantity,
      totalPrice: unitPrice * quantity,
      productionDays: productionDays,
      paymentTerms: paymentTerms,
      validUntil: DateTime.now().add(const Duration(days: 14)),
      notes: notes,
    );

    return _repository.updateQuotation(dealId, quotation);
  }
}
