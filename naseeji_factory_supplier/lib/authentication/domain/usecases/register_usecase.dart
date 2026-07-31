import '../entities/user_entity.dart';
import '../repositories/authentication_repository.dart';

class RegisterUseCase {
  final AuthenticationRepository repository;

  const RegisterUseCase(this.repository);

  Future<UserEntity> execute({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    return await repository.register(
      name: name,
      phone: phone,
      email: email,
      password: password,
    );
  }
}
