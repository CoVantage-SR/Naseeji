import '../../data/repositories/deals_repository_impl.dart';
import '../entities/deal_model.dart';

class NegotiationService {
  final DealsRepository _repository;

  NegotiationService(this._repository);

  Future<bool> submitCounterOffer({
    required String dealId,
    required double proposedUnitPrice,
    required int proposedQuantity,
    required int proposedProductionDays,
    required String proposedPaymentTerms,
    required String proposedDeliveryDate,
    required String statusText,
  }) async {
    final negotiation = NegotiationData(
      proposedUnitPrice: proposedUnitPrice,
      proposedQuantity: proposedQuantity,
      proposedProductionDays: proposedProductionDays,
      proposedPaymentTerms: proposedPaymentTerms,
      proposedDeliveryDate: proposedDeliveryDate,
      statusText: statusText,
      isSupplierTurn: false,
    );

    return _repository.updateNegotiation(dealId, negotiation);
  }

  Future<bool> acceptNegotiation(String dealId) async {
    final deal = await _repository.getDealById(dealId);
    if (deal.negotiation != null) {
      final quotation = QuotationData(
        quoteId: 'Q-AGREED-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        unitPrice: deal.negotiation!.proposedUnitPrice,
        quantity: deal.negotiation!.proposedQuantity,
        totalPrice: deal.negotiation!.proposedUnitPrice * deal.negotiation!.proposedQuantity,
        productionDays: deal.negotiation!.proposedProductionDays,
        paymentTerms: deal.negotiation!.proposedPaymentTerms,
        validUntil: DateTime.now().add(const Duration(days: 30)),
        notes: 'تم اعتماد الاتفاق بناء على جولة التفاوض',
      );
      await _repository.updateQuotation(dealId, quotation);
      return _repository.updateDealStatus(dealId, DealStatus.agreementPending);
    }
    return false;
  }
}

