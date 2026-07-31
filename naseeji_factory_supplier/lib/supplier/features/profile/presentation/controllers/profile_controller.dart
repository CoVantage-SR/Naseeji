import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/supplier_profile.dart';
import '../../data/repositories/profile_repository_impl.dart';

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  @override
  FutureOr<SupplierProfile> build() async {
    final repo = ref.watch(profileRepositoryProvider);
    return repo.getProfile();
  }

  Future<void> refreshProfile() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(profileRepositoryProvider);
      return repo.getProfile();
    });
  }

  Future<void> addCertificate(String name, String date) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(profileRepositoryProvider);
      await repo.addCertificate(CompanyCertificate(name: name, date: date, verified: false));
      return repo.getProfile();
    });
  }

  Future<void> updateProfile(SupplierProfile updated) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(profileRepositoryProvider);
      await repo.updateProfile(updated);
      return repo.getProfile();
    });
  }

  Future<void> toggleVipStatus() async {
    final current = state.valueOrNull;
    if (current != null) {
      await updateProfile(current.copyWith(isVip: !current.isVip));
    }
  }
}
