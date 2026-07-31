import '../repositories/otp_repository.dart';

class ResendOtpUseCase {
  final OtpRepository repository;

  const ResendOtpUseCase(this.repository);

  Future<bool> execute({required String phone}) async {
    return await repository.resendOtp(phone: phone);
  }
}
