import 'failure.dart';

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'فشل في قراءة البيانات المحلية',
    super.code = 'CACHE_ERROR',
  });
}
