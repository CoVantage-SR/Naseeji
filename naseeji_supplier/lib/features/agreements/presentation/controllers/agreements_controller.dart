import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/agreement_model.dart';
import '../../data/repositories/agreements_repository_impl.dart';

part 'agreements_controller.g.dart';

@riverpod
class AgreementsController extends _$AgreementsController {
  @override
  FutureOr<List<B2BAgreement>> build() async {
    final repo = ref.watch(agreementsRepositoryProvider);
    return repo.getAgreements();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(agreementsRepositoryProvider);
      return repo.getAgreements();
    });
  }

  Future<void> approve(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(agreementsRepositoryProvider);
      await repo.approveAgreement(id);
      return repo.getAgreements();
    });
  }

  Future<void> reject(String id, String reason) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(agreementsRepositoryProvider);
      await repo.rejectAgreement(id, reason);
      return repo.getAgreements();
    });
  }

  Future<void> modify(String id, String notes) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(agreementsRepositoryProvider);
      await repo.requestModification(id, notes);
      return repo.getAgreements();
    });
  }

  Future<void> uploadDoc(String id, String type, String name, String url) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(agreementsRepositoryProvider);
      await repo.uploadContractDocument(id, type, name, url);
      return repo.getAgreements();
    });
  }
}
