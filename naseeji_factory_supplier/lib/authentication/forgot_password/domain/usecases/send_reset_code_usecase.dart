import '../repositories/forgot_password_repository.dart';

class SendResetCodeUseCase {
  final ForgotPasswordRepository repository;

  const SendResetCodeUseCase(this.repository);

  Future<bool> execute(String phoneOrEmail) async {
    return await repository.sendResetCode(phoneOrEmail);
  }
}
