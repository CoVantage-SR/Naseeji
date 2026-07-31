import '../../data/repositories/deals_repository_impl.dart';
import '../entities/deal_model.dart';

class DeliveryService {
  final DealsRepository _repository;

  DeliveryService(this._repository);

  Future<bool> setDeliveryDetails({
    required String dealId,
    required DeliveryMethod method,
    required DateTime estimatedDeliveryDate,
    required String responsiblePersonName,
    required String responsiblePersonPhone,
    String? notes,
  }) async {
    final delivery = DeliveryData(
      method: method,
      estimatedDeliveryDate: estimatedDeliveryDate,
      responsiblePersonName: responsiblePersonName,
      responsiblePersonPhone: responsiblePersonPhone,
      notes: notes,
    );

    return _repository.updateDelivery(dealId, delivery);
  }
}


