import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'test_app.dart';

/// Enterprise golden test wrapper that freezes screen dimensions, device pixel ratio,
/// text scale factor, locale, and theme mode for deterministic cross-platform golden renders.
Widget buildGoldenWrapper({
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

/// Helper method to configure Tester view constraints deterministically.
void configureGoldenDeviceView(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  tester.view.textScaleFactor = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
    tester.view.resetTextScaleFactor();
  });
}
