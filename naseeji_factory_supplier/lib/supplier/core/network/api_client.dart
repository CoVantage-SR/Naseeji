import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_client.g.dart';

class TlsOnlyInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.uri.scheme == 'http') {
      return handler.reject(
        DioException(
          requestOptions: options,
          error: 'Security Error: Plaintext HTTP is blocked. Only secure HTTPS is allowed.',
          type: DioExceptionType.connectionError,
        ),
      );
    }
    super.onRequest(options, handler);
  }
}

@riverpod
Dio dio(DioRef ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.naseeji.com/v1/', // Placeholder Base URL
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(TlsOnlyInterceptor());

  // Only log sensitive requests/responses in Debug Mode
  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
  }

  return dio;
}



