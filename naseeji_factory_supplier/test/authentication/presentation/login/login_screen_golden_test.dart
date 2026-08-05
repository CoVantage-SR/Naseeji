import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naseeji_factory/authentication/presentation/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/fake_services.dart';
import '../../../helpers/golden_wrapper.dart';
import '../../../helpers/pump_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SharedPreferences mockPrefs;

  setUp(() async {
    mockPrefs = await createMockSharedPreferences();
  });

  group('LoginScreen Golden Visual Tests', () {
    testWidgets('Golden Test - Light Theme Arabic (360dp Mobile)', (WidgetTester tester) async {
      const size = Size(360, 800);
      configureGoldenDeviceView(tester, size);

      await tester.pumpWidget(buildGoldenWrapper(
        child: const LoginScreen(),
        prefs: mockPrefs,
        size: size,
        themeMode: ThemeMode.light,
        locale: const Locale('ar'),
      ));
      await tester.pumpAndSettleClean();

      await expectLater(
        find.byType(LoginScreen),
        matchesGoldenFile('goldens/login_light_ar_360.png'),
      );
    });

    testWidgets('Golden Test - Dark Theme English (480dp Tablet/Desktop)', (WidgetTester tester) async {
      const size = Size(480, 900);
      configureGoldenDeviceView(tester, size);

      await tester.pumpWidget(buildGoldenWrapper(
        child: const LoginScreen(),
        prefs: mockPrefs,
        size: size,
        themeMode: ThemeMode.dark,
        locale: const Locale('en'),
      ));
      await tester.pumpAndSettleClean();

      await expectLater(
        find.byType(LoginScreen),
        matchesGoldenFile('goldens/login_dark_en_480.png'),
      );
    });

    testWidgets('Golden Test - Small Phone (320dp)', (WidgetTester tester) async {
      const size = Size(320, 640);
      configureGoldenDeviceView(tester, size);

      await tester.pumpWidget(buildGoldenWrapper(
        child: const LoginScreen(),
        prefs: mockPrefs,
        size: size,
        themeMode: ThemeMode.light,
        locale: const Locale('ar'),
      ));
      await tester.pumpAndSettleClean();

      await expectLater(
        find.byType(LoginScreen),
        matchesGoldenFile('goldens/login_ar_320.png'),
      );
    });

    testWidgets('Golden Test - Landscape Mode (800x400)', (WidgetTester tester) async {
      const size = Size(800, 400);
      configureGoldenDeviceView(tester, size);

      await tester.pumpWidget(buildGoldenWrapper(
        child: const LoginScreen(),
        prefs: mockPrefs,
        size: size,
        themeMode: ThemeMode.light,
        locale: const Locale('ar'),
      ));
      await tester.pumpAndSettleClean();

      await expectLater(
        find.byType(LoginScreen),
        matchesGoldenFile('goldens/login_landscape.png'),
      );
    });
  });
}
