import 'package:flutter/material.dart';
import 'light_theme.dart';
import 'dark_theme.dart';

export 'theme_colors.dart';
export 'theme_spacing.dart';
export 'theme_radius.dart';
export 'theme_typography.dart';
export 'theme_elevation.dart';
export 'theme_animation.dart';
export 'theme_extensions.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => buildLightTheme();
  static ThemeData get darkTheme => buildDarkTheme();
}
