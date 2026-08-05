import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_factory/core/session/session_provider.dart';
import 'package:naseeji_factory/core/theme/app_theme.dart';
import 'package:naseeji_factory/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'localization_helper.dart';

/// Wraps test target widgets with ProviderScope, MaterialApp, Theme, and Localizations.
Widget buildTestApp({
  required Widget child,
  required SharedPreferences prefs,
  Locale locale = const Locale('ar'),
  ThemeMode themeMode = ThemeMode.light,
  List<Override> overrides = const [],
}) {
  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      ...overrides,
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: LocalizationHelper.delegates,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: child,
    ),
  );
}
