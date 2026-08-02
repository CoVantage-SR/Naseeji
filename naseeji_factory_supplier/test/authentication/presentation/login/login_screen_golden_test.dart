import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naseeji_factory/authentication/presentation/login/login_screen.dart';
import 'package:naseeji_factory/core/theme/app_theme.dart';
import 'package:naseeji_factory/l10n/app_localizations.dart';

Widget buildGoldenWidget({
  required ThemeMode themeMode,
  required Locale locale,
  required Size size,
}) {
  return ProviderScope(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: MediaQuery(
        data: MediaQueryData(size: size),
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: const LoginScreen(),
        ),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LoginScreen Golden Visual Tests', () {
    testWidgets('Golden Test - Light Theme Arabic (360dp Mobile)', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildGoldenWidget(
        themeMode: ThemeMode.light,
        locale: const Locale('ar'),
        size: const Size(360, 800),
      ));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(LoginScreen),
        matchesGoldenFile('goldens/login_light_ar_360.png'),
      );
    });

    testWidgets('Golden Test - Dark Theme English (480dp Tablet/Desktop)', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(480, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildGoldenWidget(
        themeMode: ThemeMode.dark,
        locale: const Locale('en'),
        size: const Size(480, 900),
      ));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(LoginScreen),
        matchesGoldenFile('goldens/login_dark_en_480.png'),
      );
    });

    testWidgets('Golden Test - Small Phone (320dp)', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildGoldenWidget(
        themeMode: ThemeMode.light,
        locale: const Locale('ar'),
        size: const Size(320, 640),
      ));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(LoginScreen),
        matchesGoldenFile('goldens/login_ar_320.png'),
      );
    });

    testWidgets('Golden Test - Landscape Mode (800x400)', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildGoldenWidget(
        themeMode: ThemeMode.light,
        locale: const Locale('ar'),
        size: const Size(800, 400),
      ));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(LoginScreen),
        matchesGoldenFile('goldens/login_landscape.png'),
      );
    });
  });
}
