import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/theme/app_theme.dart';

class FakeTheme {
  FakeTheme._();

  static ThemeData get lightTheme => AppTheme.light;
  static ThemeData get darkTheme => AppTheme.dark;
}
