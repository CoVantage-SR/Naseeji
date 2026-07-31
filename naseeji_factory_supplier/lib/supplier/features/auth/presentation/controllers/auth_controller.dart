import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/user_model.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../../../core/security/secure_storage_service.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<UserModel?> build() {
    return _loadPersistedUser();
  }

  Future<UserModel?> _loadPersistedUser() async {
    final userId = await SecureStorageService.read(key: 'session_user_id');
    if (userId != null) {
      return UserModel(
        id: userId,
        name: 'Naseeji Supplier',
        email: 'verified@naseeji.com',
      );
    }
    return null;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      return await repository.login(email, password);
    });
  }

  void logout() {
    state = const AsyncValue.data(null);
    SecureStorageService.clearAll();
  }
}


