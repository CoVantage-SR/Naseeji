import 'package:flutter/foundation.dart';
import 'bootstrap_logger.dart';

class BootstrapExceptionHandler {
  static void initialize() {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      BootstrapLogger.error(
        'Unhandled Flutter Error: ${details.exceptionAsString()}',
        error: details.exception,
        stackTrace: details.stack,
      );
    };

    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      BootstrapLogger.error(
        'Unhandled Platform Error: $error',
        error: error,
        stackTrace: stack,
      );
      return true;
    };
  }
}
