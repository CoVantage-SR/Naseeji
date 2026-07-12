import 'package:dio/dio.dart';
import '../services/storage/secure_storage_service.dart';

class ApiInterceptor extends Interceptor {
  final SecureStorageService _secureStorageService;

  ApiInterceptor(this._secureStorageService);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add default headers
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept-Language'] = 'ar-EG'; // Force Egyptian Arabic header

    // Read auth token from secure storage
    final token = await _secureStorageService.read('auth_token');
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    return handler.next(err);
  }
}
