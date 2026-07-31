import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'storage/shared_preferences_service.dart';

part 'theme_service.g.dart';

@riverpod
class ThemeService extends _$ThemeService {
  static const String _themeModeKey = 'app_theme_mode';

  @override
  ThemeMode build() {
    final prefs = ref.watch(sharedPreferencesServiceProvider);
    final savedMode = prefs.getString(_themeModeKey);

    if (savedMode == 'light') return ThemeMode.light;
    if (savedMode == 'dark') return ThemeMode.dark;
    return ThemeMode.system; // Default is system theme
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = ref.read(sharedPreferencesServiceProvider);
    await prefs.setString(_themeModeKey, mode.name);
  }
}


