import 'package:naseeji_supplier/features/messages/domain/entities/deal_workspace_model.dart';
import 'package:naseeji_supplier/features/messages/domain/entities/business_message.dart';
import 'package:naseeji_supplier/features/messages/domain/entities/deal_status_enum.dart';

abstract class DealWorkspaceRepository {
  Future<DealWorkspaceModel> getDealWorkspace(String dealId);

  Future<BusinessMessage> sendMessage({
    required String dealId,
    required String text,
    String? attachmentUrl,
  });

  Future<bool> sendCounterOffer({
    required String dealId,
    required double newUnitPrice,
    required int quantity,
  });

  Future<bool> updateDealStatus(String dealId, DealStatus newStatus);
}
