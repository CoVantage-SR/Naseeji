import '../../../core/storage/secure_storage_service.dart';
import '../../../core/storage/shared_preferences_service.dart';

abstract class AuthLocalDatasource {
  Future<void> saveAuthToken(String token);
  Future<String?> getAuthToken();
  Future<void> clearAuthSession();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final SecureStorageService secureStorage;
  final SharedPreferencesService sharedPreferences;

  AuthLocalDatasourceImpl({
    required this.secureStorage,
    required this.sharedPreferences,
  });

  @override
  Future<void> saveAuthToken(String token) async {
    await secureStorage.write(key: 'access_token', value: token);
  }

  @override
  Future<String?> getAuthToken() async {
    return await secureStorage.read(key: 'access_token');
  }

  @override
  Future<void> clearAuthSession() async {
    await secureStorage.delete(key: 'access_token');
    await sharedPreferences.clear();
  }
}
