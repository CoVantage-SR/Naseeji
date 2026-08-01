import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/database/isar_service.dart';
import '../session/session_provider.dart';
import '../storage/shared_preferences_service.dart';
import 'bootstrap_initializer.dart';

class AppBootstrap {
  static Future<Widget> run(Widget Function(List<Override> overrides) builder) async {
    final deps = await BootstrapInitializer.initialize();

    final overrides = <Override>[
      sharedPreferencesProvider.overrideWithValue(deps.sharedPreferences),
      sharedPreferencesServiceProvider.overrideWithValue(
        SharedPreferencesService(deps.sharedPreferences),
      ),
      isarServiceProvider.overrideWithValue(deps.isarService),
    ];

    return builder(overrides);
  }
}
