import 'package:naseeji_factory/supplier/features/messages/domain/repositories/deal_workspace_repository.dart';
import 'package:naseeji_factory/supplier/features/messages/domain/entities/deal_workspace_model.dart';
import 'package:naseeji_factory/supplier/features/messages/domain/entities/business_message.dart';
import 'package:naseeji_factory/supplier/features/messages/domain/entities/deal_status_enum.dart';
import 'package:naseeji_factory/supplier/features/messages/data/datasources/deal_workspace_remote_datasource.dart';

class DealWorkspaceRepositoryImpl implements DealWorkspaceRepository {
  final DealWorkspaceRemoteDatasource datasource;

  DealWorkspaceRepositoryImpl({required this.datasource});

  @override
  Future<DealWorkspaceModel> getDealWorkspace(String dealId) {
    return datasource.fetchDealWorkspace(dealId);
  }

  @override
  Future<BusinessMessage> sendMessage({
    required String dealId,
    required String text,
    String? attachmentUrl,
  }) {
    return datasource.sendMessage(dealId: dealId, text: text, attachmentUrl: attachmentUrl);
  }

  @override
  Future<bool> sendNewOfferVersion({
    required String dealId,
    required double unitPrice,
    required int quantity,
    required String productionLeadTime,
    required String validityPeriod,
    required String paymentTerms,
    required String deliveryTerms,
    DateTime? expectedDeliveryDate,
    String? notes,
  }) {
    return datasource.sendNewOfferVersion(
      dealId: dealId,
      unitPrice: unitPrice,
      quantity: quantity,
      productionLeadTime: productionLeadTime,
      validityPeriod: validityPeriod,
      paymentTerms: paymentTerms,
      deliveryTerms: deliveryTerms,
      expectedDeliveryDate: expectedDeliveryDate,
      notes: notes,
    );
  }

  @override
  Future<bool> acceptCounterOffer(String dealId) {
    return datasource.acceptCounterOffer(dealId);
  }

  @override
  Future<bool> rejectCounterOffer(String dealId) {
    return datasource.rejectCounterOffer(dealId);
  }

  @override
  Future<bool> sendFactoryCounterOffer({
    required String dealId,
    required double unitPrice,
    required int quantity,
    required String productionLeadTime,
    required String paymentTerms,
    required String deliveryTerms,
    String? notes,
  }) {
    return datasource.sendFactoryCounterOffer(
      dealId: dealId,
      unitPrice: unitPrice,
      quantity: quantity,
      productionLeadTime: productionLeadTime,
      paymentTerms: paymentTerms,
      deliveryTerms: deliveryTerms,
      notes: notes,
    );
  }

  @override
  Future<bool> acceptQuotation(String dealId) {
    return datasource.acceptQuotation(dealId);
  }

  @override
  Future<bool> rejectQuotation(String dealId) {
    return datasource.rejectQuotation(dealId);
  }

  @override
  Future<bool> updateDealStatus(String dealId, DealStatus newStatus) {
    return datasource.updateDealStatus(dealId, newStatus);
  }
}


