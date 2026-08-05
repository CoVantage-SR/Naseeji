import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naseeji_factory/authentication/presentation/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/fake_services.dart';
import '../../../helpers/fonts_loader.dart';
import '../../../helpers/golden_configuration.dart';
import '../../../helpers/golden_test_wrapper.dart';
import '../../../helpers/pump_helpers.dart';
import '../../../helpers/screen_sizes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SharedPreferences mockPrefs;

  setUpAll(() async {
    await TestFontsLoader.loadTestFonts();
    configureEnterpriseGoldenComparator('test/authentication/presentation/login/login_screen_golden_test.dart');
  });

  setUp(() async {
    mockPrefs = await createMockSharedPreferences();
  });

  group('LoginScreen Enterprise Golden Tests', () {
    testWidgets('Golden Test - Light Theme Arabic (360dp Mobile)', (WidgetTester tester) async {
      setupGoldenDeviceView(tester, ScreenSizes.mobile360);

      await tester.pumpWidget(buildGoldenTestWrapper(
        child: const LoginScreen(),
        prefs: mockPrefs,
        size: ScreenSizes.mobile360,
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
      setupGoldenDeviceView(tester, size);

      await tester.pumpWidget(buildGoldenTestWrapper(
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
      setupGoldenDeviceView(tester, ScreenSizes.smallPhone);

      await tester.pumpWidget(buildGoldenTestWrapper(
        child: const LoginScreen(),
        prefs: mockPrefs,
        size: ScreenSizes.smallPhone,
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
      setupGoldenDeviceView(tester, ScreenSizes.landscape);

      await tester.pumpWidget(buildGoldenTestWrapper(
        child: const LoginScreen(),
        prefs: mockPrefs,
        size: ScreenSizes.landscape,
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
