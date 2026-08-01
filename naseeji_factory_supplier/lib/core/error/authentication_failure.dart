import 'failure.dart';

class AuthenticationFailure extends Failure {
  const AuthenticationFailure({
    super.message = 'فشل في عملية المصادقة أو انتهت الجلسة',
    super.code = 'AUTH_ERROR',
  });
}
