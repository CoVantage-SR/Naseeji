import 'dart:developer' as developer;
import 'bootstrap_environment.dart';

class BootstrapLogger {
  static void info(String message, {String tag = 'BOOTSTRAP'}) {
    if (BootstrapEnvironment.config.enableLogging) {
      developer.log('ℹ️ [$tag] $message');
    }
  }

  static void error(String message, {Object? error, StackTrace? stackTrace, String tag = 'BOOTSTRAP'}) {
    developer.log(
      '❌ [$tag] $message',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
