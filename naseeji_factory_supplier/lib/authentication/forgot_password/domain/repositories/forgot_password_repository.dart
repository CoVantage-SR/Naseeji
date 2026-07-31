abstract class ForgotPasswordRepository {
  Future<bool> sendResetCode(String phoneOrEmail);
}
