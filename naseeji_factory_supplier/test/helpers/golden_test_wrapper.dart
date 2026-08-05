import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'test_app.dart';

/// Wraps widgets for deterministic Golden visual testing across device viewports,
/// locales (RTL/LTR), and theme modes (Light/Dark).
Widget buildGoldenTestWrapper({
  required Widget child,
  required SharedPreferences prefs,
  required Size size,
  Locale locale = const Locale('ar'),
  ThemeMode themeMode = ThemeMode.light,
}) {
  return MediaQuery(
    data: MediaQueryData(
      size: size,
      devicePixelRatio: 1.0,
      textScaler: TextScaler.noScaling,
      platformBrightness: themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light,
    ),
    child: SizedBox(
      width: size.width,
      height: size.height,
      child: buildTestApp(
        prefs: prefs,
        locale: locale,
        themeMode: themeMode,
        child: child,
      ),
    ),
  );
}

/// Sets up Tester physical view bounds deterministically for device profiles.
void setupGoldenDeviceView(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
