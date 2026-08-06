import 'package:dio/dio.dart';
import '../models/auth_tokens_model.dart';
import '../models/user_model.dart';
import '../models/factory_profile_model.dart';
import '../models/supplier_profile_model.dart';
import '../models/wallet_model.dart';
import 'token_storage_service.dart';

class AuthRemoteDataSource {
  final Dio _dio;
  final TokenStorageService _tokenStorage;
  final String _baseUrl;

  AuthRemoteDataSource({
    Dio? dio,
    required TokenStorageService tokenStorage,
    String baseUrl = 'http://localhost:5000/api/v1',
  })  : _tokenStorage = tokenStorage,
        _baseUrl = baseUrl,
        _dio = dio ?? Dio() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await _tokenStorage.getAccessToken();
          if (accessToken != null && accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            // Attempt auto refresh token
            final refreshToken = await _tokenStorage.getRefreshToken();
            if (refreshToken != null) {
              try {
                final refreshResponse = await _dio.post(
                  '/auth/refresh',
                  data: {'refreshToken': refreshToken},
                );
                if (refreshResponse.statusCode == 200 &&
                    refreshResponse.data['success'] == true) {
                  final newAccessToken =
                      refreshResponse.data['data']['accessToken'];
                  final newRefreshToken =
                      refreshResponse.data['data']['refreshToken'];
                  await _tokenStorage.saveTokens(
                    accessToken: newAccessToken,
                    refreshToken: newRefreshToken,
                  );

                  // Retry failed request
                  error.requestOptions.headers['Authorization'] =
                      'Bearer $newAccessToken';
                  final retryResponse = await _dio.fetch(error.requestOptions);
                  return handler.resolve(retryResponse);
                }
              } catch (_) {
                await _tokenStorage.clearAll();
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
    bool rememberMe = true,
  }) async {
    final response = await _dio.post('/auth/login', data: {
      'identifier': identifier,
      'password': password,
      'rememberMe': rememberMe,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> registerFactory(Map<String, dynamic> data) async {
    final response = await _dio.post('/auth/register/factory', data: data);
    return response.data;
  }

  Future<Map<String, dynamic>> registerSupplier(Map<String, dynamic> data) async {
    final response = await _dio.post('/auth/register/supplier', data: data);
    return response.data;
  }

  Future<Map<String, dynamic>> getMe() async {
    final response = await _dio.get('/auth/me');
    return response.data;
  }

  Future<void> logout() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    try {
      await _dio.post('/auth/logout', data: {'refreshToken': refreshToken});
    } finally {
      await _tokenStorage.clearAll();
    }
  }
}
