import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../config/env_config.dart';
import '../services/storage/secure_storage_service.dart';
import 'api_interceptor.dart';

part 'api_client.g.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }
}

// We'll define a provider for EnvConfig which can be overridden, defaulting to Dev environment.
@riverpod
EnvConfig envConfig(EnvConfigRef ref) {
  return EnvConfig.dev;
}

@riverpod
ApiClient apiClient(ApiClientRef ref) {
  final config = ref.watch(envConfigProvider);
  final secureStorage = ref.watch(secureStorageServiceProvider);

  final baseOptions = BaseOptions(
    baseUrl: config.apiBaseUrl,
    connectTimeout: Duration(milliseconds: config.connectTimeoutMs),
    receiveTimeout: Duration(milliseconds: config.receiveTimeoutMs),
  );

  final dio = Dio(baseOptions);

  // Add interceptors
  dio.interceptors.add(ApiInterceptor(secureStorage));
  
  // Add pretty logging interceptor in development
  if (config.isDevelopment) {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  return ApiClient(dio);
}



