import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/user_model.dart';
import '../../data/repositories/auth_repository_impl.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<UserModel?> build() {
    return null; // Initial state is unauthenticated (null user)
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
  }
}
