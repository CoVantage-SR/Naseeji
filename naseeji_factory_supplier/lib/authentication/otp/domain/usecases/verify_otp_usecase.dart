import '../repositories/otp_repository.dart';

class VerifyOtpUseCase {
  final OtpRepository repository;

  const VerifyOtpUseCase(this.repository);

  Future<bool> execute({required String phone, required String code}) async {
    return await repository.verifyOtp(phone: phone, code: code);
  }
}
