import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/theme_service.dart';

export '../services/theme_service.dart';

final themeControllerProvider = NotifierProvider<ThemeControllerNotifier, ThemeMode>(() {
  return ThemeControllerNotifier();
});

class ThemeControllerNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ThemeMode.system;
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }

  void toggleTheme() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }
}
