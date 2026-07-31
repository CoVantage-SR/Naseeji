import 'error_handler.dart';

abstract class BaseRepository {
  Future<T> safeCall<T>(Future<T> Function() call) async {
    try {
      return await call();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}


