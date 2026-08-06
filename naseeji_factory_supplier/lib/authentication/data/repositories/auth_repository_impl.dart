import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/token_storage_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenStorageService tokenStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenStorage,
  });

  @override
  Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
    bool rememberMe = true,
  }) async {
    final response = await remoteDataSource.login(
      identifier: identifier,
      password: password,
      rememberMe: rememberMe,
    );

    if (response['success'] == true) {
      final tokens = response['data']['tokens'];
      final user = response['data']['user'];
      await tokenStorage.saveTokens(
        accessToken: tokens['accessToken'],
        refreshToken: tokens['refreshToken'],
        role: user['role'],
        userId: user['id'],
      );
    }
    return response;
  }

  @override
  Future<Map<String, dynamic>> loginGoogle({
    required String idToken,
    String accountType = 'factory',
  }) async {
    final response = await remoteDataSource.loginGoogle(
      idToken: idToken,
      accountType: accountType,
    );

    if (response['success'] == true) {
      final tokens = response['data']['tokens'];
      final user = response['data']['user'];
      await tokenStorage.saveTokens(
        accessToken: tokens['accessToken'],
        refreshToken: tokens['refreshToken'],
        role: user['role'],
        userId: user['id'],
      );
    }
    return response;
  }

  @override
  Future<Map<String, dynamic>> sendWhatsAppOtp({
    required String phone,
    String type = 'phone_verification',
  }) async {
    return await remoteDataSource.sendWhatsAppOtp(phone: phone, type: type);
  }

  @override
  Future<Map<String, dynamic>> verifyWhatsAppOtp({
    required String phone,
    required String otpCode,
    String type = 'phone_verification',
  }) async {
    return await remoteDataSource.verifyWhatsAppOtp(
      phone: phone,
      otpCode: otpCode,
      type: type,
    );
  }

  @override
  Future<Map<String, dynamic>> registerFactory(Map<String, dynamic> data) async {
    return await remoteDataSource.registerFactory(data);
  }

  @override
  Future<Map<String, dynamic>> registerSupplier(Map<String, dynamic> data) async {
    return await remoteDataSource.registerSupplier(data);
  }

  @override
  Future<Map<String, dynamic>> getCurrentUser() async {
    return await remoteDataSource.getMe();
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
  }

  @override
  Future<void> logoutAll() async {
    await remoteDataSource.logoutAll();
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await tokenStorage.getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
