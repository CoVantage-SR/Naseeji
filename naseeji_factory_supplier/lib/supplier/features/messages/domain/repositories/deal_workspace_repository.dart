import 'package:naseeji_factory/supplier/features/messages/domain/entities/deal_workspace_model.dart';
import 'package:naseeji_factory/supplier/features/messages/domain/entities/business_message.dart';
import 'package:naseeji_factory/supplier/features/messages/domain/entities/deal_status_enum.dart';

abstract class DealWorkspaceRepository {
  Future<DealWorkspaceModel> getDealWorkspace(String dealId);

  Future<BusinessMessage> sendMessage({
    required String dealId,
    required String text,
    String? attachmentUrl,
  });

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

