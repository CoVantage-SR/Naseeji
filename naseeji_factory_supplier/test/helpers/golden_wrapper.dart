import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'test_app.dart';

/// Enterprise custom Golden comparator with pixel difference tolerance for CI environments (Linux/Windows/macOS).
class TolerantGoldenComparator extends LocalFileComparator {
  final double tolerance;

  TolerantGoldenComparator(super.testFile, {this.tolerance = 0.08});

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );

    if (!result.passed && result.diffPercent <= tolerance) {
      debugPrint(
        'Golden visual check: ${golden.path} pixel diff is ${(result.diffPercent * 100).toStringAsFixed(2)}% (within tolerance ${tolerance * 100}%). Test passed.',
      );
      return true;
    }

    if (!result.passed) {
      await generateFailureOutput(result, golden, basedir);
    }
    return result.passed;
  }
}

/// Initializes tolerant golden comparator for cross-platform CI runner compatibility.
void setupGoldenComparator(String testFilePath) {
  goldenFileComparator = TolerantGoldenComparator(Uri.parse(testFilePath), tolerance: 0.08);
}

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
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
