import 'package:naseeji_supplier/features/messages/domain/repositories/deal_workspace_repository.dart';
import 'package:naseeji_supplier/features/messages/domain/entities/deal_workspace_model.dart';
import 'package:naseeji_supplier/features/messages/domain/entities/business_message.dart';
import 'package:naseeji_supplier/features/messages/domain/entities/deal_status_enum.dart';
import 'package:naseeji_supplier/features/messages/data/datasources/deal_workspace_remote_datasource.dart';

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
  Future<bool> sendCounterOffer({
    required String dealId,
    required double newUnitPrice,
    required int quantity,
  }) {
    return datasource.sendCounterOffer(dealId: dealId, newUnitPrice: newUnitPrice, quantity: quantity);
  }

  @override
  Future<bool> updateDealStatus(String dealId, DealStatus newStatus) {
    return datasource.updateDealStatus(dealId, newStatus);
  }
}
