import 'dart:io';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_controller.g.dart';

@riverpod
class ThemeController extends _$ThemeController {
  File get _settingsFile {
    final tempDir = Directory.systemTemp.path;
    return File('$tempDir/naseeji_theme_settings.txt');
  }

  @override
  ThemeMode build() {
    try {
      final file = _settingsFile;
      if (file.existsSync()) {
        final content = file.readAsStringSync().trim();
        if (content == 'light') return ThemeMode.light;
        if (content == 'dark') return ThemeMode.dark;
        if (content == 'system') return ThemeMode.system;
      }
    } catch (_) {
      // Ignore reading errors, fallback to system
    }
    return ThemeMode.system;
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
    try {
      final file = _settingsFile;
      String val = 'system';
      if (mode == ThemeMode.light) val = 'light';
      if (mode == ThemeMode.dark) val = 'dark';
      file.writeAsStringSync(val);
    } catch (_) {
      // Ignore writing errors
    }
  }
}



