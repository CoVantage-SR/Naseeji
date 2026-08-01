import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/database/isar_service.dart';
import 'bootstrap_dependencies.dart';
import 'bootstrap_exception_handler.dart';
import 'bootstrap_logger.dart';

class BootstrapInitializer {
  static Future<BootstrapDependencies> initialize() async {
    BootstrapLogger.info('Initializing Flutter Widgets Binding...');
    WidgetsFlutterBinding.ensureInitialized();

    BootstrapLogger.info('Registering Global Exception Handlers...');
    BootstrapExceptionHandler.initialize();

    BootstrapLogger.info('Initializing Storage Services (SharedPreferences & Isar)...');
    final results = await Future.wait([
      SharedPreferences.getInstance(),
      IsarService.init(),
    ]);

    final prefs = results[0] as SharedPreferences;
    final isar = results[1] as IsarService;

    BootstrapLogger.info('Bootstrap Services Initialized Successfully!');

    return BootstrapDependencies(
      sharedPreferences: prefs,
      isarService: isar,
    );
  }
}
