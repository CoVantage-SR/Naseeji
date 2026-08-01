import 'package:shared_preferences/shared_preferences.dart';
import '../services/database/isar_service.dart';

class BootstrapDependencies {
  final SharedPreferences sharedPreferences;
  final IsarService isarService;

  const BootstrapDependencies({
    required this.sharedPreferences,
    required this.isarService,
  });
}
