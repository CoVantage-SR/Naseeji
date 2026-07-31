import 'error_handler.dart';

abstract class BaseRepository {
  const BaseRepository();

  /// Wraps an API call with error handling, ensuring that all exceptions are mapped to [Failure] models.
  Future<T> safeApiCall<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}



