import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/deal_model.dart';
import '../../domain/services/deal_service.dart';
import '../../domain/services/quotation_service.dart';
import '../../domain/services/negotiation_service.dart';
import '../../domain/services/agreement_service.dart';
import '../../domain/services/production_service.dart';
import '../../domain/services/delivery_service.dart';
import '../../domain/services/quality_service.dart';
import '../../domain/services/payment_service.dart';
import '../../domain/services/deal_workflow_service.dart';
import '../providers/deals_providers.dart';

final dealsControllerProvider = StateNotifierProvider<DealsController, AsyncValue<void>>((ref) {
  return DealsController(ref);
});

class DealsController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  DealsController(this._ref) : super(const AsyncValue.data(null));

  DealService get _dealService => _ref.read(dealServiceProvider);
  QuotationService get _quotationService => _ref.read(quotationServiceProvider);
  NegotiationService get _negotiationService => _ref.read(negotiationServiceProvider);
  AgreementService get _agreementService => _ref.read(agreementServiceProvider);
  ProductionService get _productionService => _ref.read(productionServiceProvider);
  DeliveryService get _deliveryService => _ref.read(deliveryServiceProvider);
  QualityService get _qualityService => _ref.read(qualityServiceProvider);
  PaymentService get _paymentService => _ref.read(paymentServiceProvider);

  void _refresh(String? dealId) {
    _ref.invalidate(dealsProvider);
    if (dealId != null) {
      _ref.invalidate(dealDetailsProvider(dealId));
    }
  }

  Future<bool> sendQuotation({
    required String dealId,
    required double unitPrice,
    required int quantity,
    required int productionDays,
    required String paymentTerms,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    try {
      if (notes != null) {
        final contactError = DealWorkflowService.validateNoExternalContact(notes);
        if (contactError != null) {
          throw Exception(contactError);
        }
      }

      final success = await _quotationService.sendQuotation(
        dealId: dealId,
        unitPrice: unitPrice,
        quantity: quantity,
        productionDays: productionDays,
        paymentTerms: paymentTerms,
        notes: notes,
      );
      _refresh(dealId);
      state = const AsyncValue.data(null);
      return success;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> submitCounterOffer({
    required String dealId,
    required double proposedUnitPrice,
    required int proposedQuantity,
    required int proposedProductionDays,
    required String proposedPaymentTerms,
    required String proposedDeliveryDate,
    required String statusText,
  }) async {
    state = const AsyncValue.loading();
    try {
      final contactError = DealWorkflowService.validateNoExternalContact(statusText);
      if (contactError != null) {
        throw Exception(contactError);
      }

      final success = await _negotiationService.submitCounterOffer(
        dealId: dealId,
        proposedUnitPrice: proposedUnitPrice,
        proposedQuantity: proposedQuantity,
        proposedProductionDays: proposedProductionDays,
        proposedPaymentTerms: proposedPaymentTerms,
        proposedDeliveryDate: proposedDeliveryDate,
        statusText: statusText,
      );
      _refresh(dealId);
      state = const AsyncValue.data(null);
      return success;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> acceptNegotiation(String dealId) async {
    state = const AsyncValue.loading();
    try {
      final success = await _negotiationService.acceptNegotiation(dealId);
      _refresh(dealId);
      state = const AsyncValue.data(null);
      return success;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> signAgreement(String dealId) async {
    state = const AsyncValue.loading();
    try {
      final success = await _agreementService.supplierSignAgreement(dealId);
      _refresh(dealId);
      state = const AsyncValue.data(null);
      return success;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> updateProduction({
    required String dealId,
    required double progressPercent,
    required List<String> photoUrls,
    required List<String> videoUrls,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    try {
      if (notes != null) {
        final contactError = DealWorkflowService.validateNoExternalContact(notes);
        if (contactError != null) {
          throw Exception(contactError);
        }
      }

      final success = await _productionService.updateProgress(
        dealId: dealId,
        progressPercent: progressPercent,
        photoUrls: photoUrls,
        videoUrls: videoUrls,
        notes: notes,
      );
      _refresh(dealId);
      state = const AsyncValue.data(null);
      return success;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> setDeliveryDetails({
    required String dealId,
    required DeliveryMethod method,
    required DateTime estimatedDeliveryDate,
    required String responsiblePersonName,
    required String responsiblePersonPhone,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    try {
      final contactError = DealWorkflowService.validateNoExternalContact('$responsiblePersonName $notes');
      if (contactError != null) {
        throw Exception(contactError);
      }

      final success = await _deliveryService.setDeliveryDetails(
        dealId: dealId,
        method: method,
        estimatedDeliveryDate: estimatedDeliveryDate,
        responsiblePersonName: responsiblePersonName,
        responsiblePersonPhone: responsiblePersonPhone,
        notes: notes,
      );
      _refresh(dealId);
      state = const AsyncValue.data(null);
      return success;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> updateQuality({
    required String dealId,
    required bool isAccepted,
    required List<String> inspectionPhotoUrls,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    try {
      if (notes != null) {
        final contactError = DealWorkflowService.validateNoExternalContact(notes);
        if (contactError != null) {
          throw Exception(contactError);
        }
      }

      final success = await _qualityService.recordQualityInspection(
        dealId: dealId,
        isAccepted: isAccepted,
        inspectionPhotoUrls: inspectionPhotoUrls,
        notes: notes,
      );
      _refresh(dealId);
      state = const AsyncValue.data(null);
      return success;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> releasePayment(String dealId) async {
    state = const AsyncValue.loading();
    try {
      final success = await _paymentService.releasePayment(dealId);
      _refresh(dealId);
      state = const AsyncValue.data(null);
      return success;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> updateDealStatus(String dealId, DealStatus newStatus) async {
    state = const AsyncValue.loading();
    try {
      final success = await _dealService.updateStatus(dealId, newStatus);
      _refresh(dealId);
      state = const AsyncValue.data(null);
      return success;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

