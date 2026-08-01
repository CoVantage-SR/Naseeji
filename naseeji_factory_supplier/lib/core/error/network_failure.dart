import 'failure.dart';

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'لا يوجد اتصال بالإنترنت، يرجى التحقق من الشبكة',
    super.code = 'NETWORK_ERROR',
  });
}
