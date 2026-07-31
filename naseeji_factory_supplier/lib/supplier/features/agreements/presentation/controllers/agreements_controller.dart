import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/agreement_model.dart';
import '../../domain/services/agreement_service.dart';
import '../../data/repositories/agreements_repository_impl.dart';

final agreementServiceProvider = Provider<AgreementService>((ref) {
  final repo = ref.watch(agreementsRepositoryProvider);
  return AgreementService(repo);
});

class AgreementsControllerNotifier extends StateNotifier<AsyncValue<List<B2BAgreement>>> {
  final AgreementService _service;

  AgreementsControllerNotifier(this._service) : super(const AsyncValue.loading()) {
    loadAgreements();
  }

  Future<void> loadAgreements() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _service.getAgreements());
  }

  Future<void> refresh() async {
    await loadAgreements();
  }

  Future<void> filterByStatus(AgreementStatus? status) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _service.getAgreements(statusFilter: status));
  }

  Future<void> search(String query) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _service.getAgreements(searchQuery: query));
  }

  Future<void> uploadDoc(String id, String type, String name, String url) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _service.getAgreements();
      return _service.getAgreements();
    });
  }
}

final agreementsControllerProvider =
    StateNotifierProvider<AgreementsControllerNotifier, AsyncValue<List<B2BAgreement>>>((ref) {
  final service = ref.watch(agreementServiceProvider);
  return AgreementsControllerNotifier(service);
});

final agreementDetailsProvider = FutureProvider.family<B2BAgreement?, String>((ref, id) async {
  final service = ref.watch(agreementServiceProvider);
  return service.getAgreementById(id);
});

class AgreementSignatureNotifier extends StateNotifier<bool> {
  final Ref _ref;
  final String _agreementId;

  AgreementSignatureNotifier(this._ref, this._agreementId) : super(false);

  void toggleAgreementConsent(bool? value) {
    state = value ?? false;
  }

  Future<bool> signAgreement({
    required String supplierUserId,
    required String supplierUserName,
  }) async {
    if (!state) return false;
    final service = _ref.read(agreementServiceProvider);
    await service.signAgreementBySupplier(
      _agreementId,
      supplierUserId: supplierUserId,
      supplierUserName: supplierUserName,
    );
    _ref.invalidate(agreementsControllerProvider);
    _ref.invalidate(agreementDetailsProvider(_agreementId));
    return true;
  }
}

final agreementSignatureControllerProvider =
    StateNotifierProvider.family<AgreementSignatureNotifier, bool, String>((ref, id) {
  return AgreementSignatureNotifier(ref, id);
});

final agreementTimelineProvider = FutureProvider.family<List<AgreementTimelineStep>, String>((ref, id) async {
  final service = ref.watch(agreementServiceProvider);
  final agreement = await service.getAgreementById(id);
  return agreement?.timeline ?? [];
});


