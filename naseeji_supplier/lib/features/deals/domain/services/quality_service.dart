import '../../data/repositories/deals_repository_impl.dart';
import '../entities/deal_model.dart';

class QualityService {
  final DealsRepository _repository;

  QualityService(this._repository);

  Future<bool> recordQualityInspection({
    required String dealId,
    required bool isAccepted,
    required List<String> inspectionPhotoUrls,
    String? notes,
  }) async {
    final quality = QualityData(
      statusText: isAccepted ? 'تمت الموافقة وقبول الجودة المعملية' : 'تم رفع ملاحظات جودة غير مطابقة',
      isAccepted: isAccepted,
      inspectionPhotoUrls: inspectionPhotoUrls,
      notes: notes,
    );

    return _repository.updateQuality(dealId, quality);
  }
}
