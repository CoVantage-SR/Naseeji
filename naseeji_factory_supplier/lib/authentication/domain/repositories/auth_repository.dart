abstract class AuthRepository {
  Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
    bool rememberMe = true,
  });

  Future<Map<String, dynamic>> loginGoogle({
    required String idToken,
    String accountType = 'factory',
  });

  Future<Map<String, dynamic>> sendWhatsAppOtp({
    required String phone,
    String type = 'phone_verification',
  });

  Future<Map<String, dynamic>> verifyWhatsAppOtp({
    required String phone,
    required String otpCode,
    String type = 'phone_verification',
  });

  Future<Map<String, dynamic>> registerFactory(Map<String, dynamic> data);

  Future<Map<String, dynamic>> registerSupplier(Map<String, dynamic> data);

  Future<Map<String, dynamic>> getCurrentUser();

  Future<void> logout();

  Future<void> logoutAll();

  Future<bool> isAuthenticated();
}
