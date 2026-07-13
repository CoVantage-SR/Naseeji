import 'package:dio/dio.dart';

abstract class Failure implements Exception {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة.']);
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure({
    this.statusCode,
    String message = 'حدث خطأ في الخادم. يرجى المحاولة لاحقاً.',
  }) : super(message);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'جلسة العمل انتهت أو غير صالحة. يرجى تسجيل الدخول مرة أخرى.']);
}

class ValidationFailure extends Failure {
  final Map<String, dynamic>? errors;
  const ValidationFailure({
    this.errors,
    String message = 'البيانات المدخلة غير صالحة.',
  }) : super(message);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'حدث خطأ غير متوقع. يرجى المحاولة لاحقاً.']);
}

class ErrorHandler {
  ErrorHandler._();

  static Failure handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionError:
          return const NetworkFailure();
        case DioExceptionType.badResponse:
          final response = error.response;
          final statusCode = response?.statusCode;
          final data = response?.data;

          if (statusCode == 401 || statusCode == 403) {
            return const AuthFailure();
          }

          if (statusCode == 422) {
            Map<String, dynamic>? validationErrors;
            String msg = 'البيانات المدخلة غير صالحة.';
            if (data is Map<String, dynamic>) {
              validationErrors = data['errors'] as Map<String, dynamic>?;
              msg = data['message'] ?? msg;
            }
            return ValidationFailure(errors: validationErrors, message: msg);
          }

          String serverMsg = 'حدث خطأ في الخادم. يرجى المحاولة لاحقاً.';
          if (data is Map<String, dynamic> && data['message'] != null) {
            serverMsg = data['message'];
          }

          return ServerFailure(statusCode: statusCode, message: serverMsg);

        case DioExceptionType.cancel:
          return const UnexpectedFailure('تم إلغاء الطلب.');
        default:
          return const UnexpectedFailure();
      }
    } else if (error is Failure) {
      return error;
    } else {
      return const UnexpectedFailure();
    }
  }
}
