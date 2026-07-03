import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_client.g.dart';

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

  // Add interceptors (Logging, Auth token injection, etc.)
  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
    ),
  );

  return dio;
}
