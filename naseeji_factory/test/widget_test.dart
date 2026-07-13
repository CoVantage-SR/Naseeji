import 'package:flutter_test/flutter_test.dart';
import 'package:naseeji_factory/core/config/env_config.dart';
import 'package:naseeji_factory/core/network/error_handler.dart';

void main() {
  group('Architecture Foundational Tests', () {
    test('EnvConfig dev and prod configurations are correct', () {
      final dev = EnvConfig.dev;
      final prod = EnvConfig.prod;

      expect(dev.environment, AppEnv.development);
      expect(dev.apiBaseUrl, contains('dev-api'));
      
      expect(prod.environment, AppEnv.production);
      expect(prod.apiBaseUrl, isNot(contains('dev-')));
    });

    test('ErrorHandler maps unexpected exceptions to Failure objects', () {
      final failure = ErrorHandler.handle(Exception('Test error'));
      expect(failure, isA<Failure>());
      expect(failure.message, contains('حدث خطأ غير متوقع'));
    });
  });
}
