import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/agreement_model.dart';
import '../../domain/services/agreement_service.dart';
import '../../data/repositories/agreements_repository_impl.dart';

part 'agreements_controller.g.dart';

@riverpod
AgreementService agreementService(AgreementServiceRef ref) {
  final repo = ref.watch(agreementsRepositoryProvider);
  return AgreementService(repo);
}

/// Provider لإدارة قائمة الاتفاقيات مع الفلترة والبحث
@riverpod
class AgreementsController extends _$AgreementsController {
  @override
  FutureOr<List<B2BAgreement>> build() async {
    final service = ref.watch(agreementServiceProvider);
    return service.getAgreements();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(agreementServiceProvider);
      return service.getAgreements();
    });
  }

  Future<void> filterByStatus(AgreementStatus? status) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(agreementServiceProvider);
      return service.getAgreements(statusFilter: status);
    });
  }

  Future<void> search(String query) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(agreementServiceProvider);
      return service.getAgreements(searchQuery: query);
    });
  }
}

/// Provider لجلب تفاصيل اتفاقية معينة بواسطة الـ ID
@riverpod
FutureOr<B2BAgreement?> agreementDetails(AgreementDetailsRef ref, String agreementId) async {
  final service = ref.watch(agreementServiceProvider);
  return service.getAgreementById(agreementId);
}

/// Provider لإدارة التوقيع والموافقة على البنود
@riverpod
class AgreementSignatureController extends _$AgreementSignatureController {
  @override
  bool build(String agreementId) {
    return false; // حالة الـ Checkbox (غير موافق في البداية)
  }

  void toggleAgreementConsent(bool? value) {
    state = value ?? false;
  }

  Future<bool> signAgreement({
    required String supplierUserId,
    required String supplierUserName,
  }) async {
    if (!state) return false;
    final service = ref.read(agreementServiceProvider);
    await service.signAgreementBySupplier(
      agreementId,
      supplierUserId: supplierUserId,
      supplierUserName: supplierUserName,
    );
    ref.invalidate(agreementsControllerProvider);
    ref.invalidate(agreementDetailsProvider(agreementId));
    return true;
  }
}

/// Provider لإدارة الخط الزمني وسجل الأحداث للاتفاق
@riverpod
FutureOr<List<AgreementTimelineStep>> agreementTimeline(AgreementTimelineRef ref, String agreementId) async {
  final agreement = await ref.watch(agreementDetailsProvider(agreementId).future);
  return agreement?.timeline ?? [];
}
