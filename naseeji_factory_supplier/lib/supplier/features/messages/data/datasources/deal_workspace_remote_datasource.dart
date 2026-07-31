import 'package:naseeji_supplier/core/mock/mock_data.dart';
import 'package:naseeji_supplier/features/messages/domain/entities/deal_workspace_model.dart';
import 'package:naseeji_supplier/features/messages/domain/entities/deal_status_enum.dart';
import 'package:naseeji_supplier/features/messages/domain/entities/business_message.dart';

abstract class DealWorkspaceRemoteDatasource {
  Future<DealWorkspaceModel> fetchDealWorkspace(String dealId);
  Future<BusinessMessage> sendMessage({required String dealId, required String text, String? attachmentUrl});
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
  });
  Future<bool> acceptCounterOffer(String dealId);
  Future<bool> rejectCounterOffer(String dealId);
  Future<bool> sendFactoryCounterOffer({
    required String dealId,
    required double unitPrice,
    required int quantity,
    required String productionLeadTime,
    required String paymentTerms,
    required String deliveryTerms,
    String? notes,
  });
  Future<bool> updateDealStatus(String dealId, DealStatus newStatus);
  Future<bool> acceptQuotation(String dealId);
  Future<bool> rejectQuotation(String dealId);
}

class DealWorkspaceRemoteDatasourceImpl implements DealWorkspaceRemoteDatasource {
  @override
  Future<DealWorkspaceModel> fetchDealWorkspace(String dealId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return MockDatabase.getDealWorkspace(dealId);
  }

  @override
  Future<BusinessMessage> sendMessage({
    required String dealId,
    required String text,
    String? attachmentUrl,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    MockDatabase.addMessage(
      dealId: dealId,
      text: text,
      senderId: 'supplier-1',
      senderName: MockDatabase.supplier.name,
      isMe: true,
    );

    final ws = MockDatabase.getDealWorkspace(dealId);
    return ws.messages.last;
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
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));
    MockDatabase.submitNewOfferVersion(
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
    return true;
  }

  @override
  Future<bool> acceptCounterOffer(String dealId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    MockDatabase.supplierAcceptCounterOffer(dealId);
    return true;
  }

  @override
  Future<bool> rejectCounterOffer(String dealId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    MockDatabase.supplierRejectCounterOffer(dealId);
    return true;
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
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));
    MockDatabase.submitFactoryCounterOffer(
      dealId: dealId,
      unitPrice: unitPrice,
      quantity: quantity,
      productionLeadTime: productionLeadTime,
      paymentTerms: paymentTerms,
      deliveryTerms: deliveryTerms,
      notes: notes,
    );
    return true;
  }

  @override
  Future<bool> acceptQuotation(String dealId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    MockDatabase.acceptQuotation(dealId);
    return true;
  }

  @override
  Future<bool> rejectQuotation(String dealId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return true;
  }

  @override
  Future<bool> updateDealStatus(String dealId, DealStatus newStatus) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return true;
  }
}
