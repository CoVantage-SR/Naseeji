abstract class OtpRepository {
  Future<bool> verifyOtp({required String phone, required String code});
  Future<bool> resendOtp({required String phone});
}
