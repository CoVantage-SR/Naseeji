import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naseeji_factory/authentication/presentation/login/login_screen.dart';
import 'package:naseeji_factory/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('E2E Integration Test - Complete Login User Journey Flow', (WidgetTester tester) async {
    // 1. Open App
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          locale: Locale('ar'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: LoginScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 2. Trigger validation on empty inputs
    final loginButton = find.widgetWithText(ElevatedButton, 'تسجيل الدخول');
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // 3. Fill Form Inputs
    final emailPhoneField = find.byType(TextFormField).first;
    final passwordField = find.byType(TextFormField).last;

    await tester.enterText(emailPhoneField, '01011112222');
    await tester.enterText(passwordField, 'Password123');
    await tester.pumpAndSettle();

    // 4. Password visibility toggle
    final toggleIcon = find.byIcon(Icons.visibility_off_outlined);
    await tester.tap(toggleIcon);
    await tester.pumpAndSettle();

    // 5. Remember Me checkbox toggle
    final rememberMeCheckbox = find.byType(Checkbox);
    await tester.tap(rememberMeCheckbox);
    await tester.pumpAndSettle();

    // 6. Tap Google Login Button
    final googleButton = find.text('تسجيل الدخول بجوجل');
    expect(googleButton, findsOneWidget);
    await tester.tap(googleButton);
    await tester.pumpAndSettle();

    // 7. Submit valid Login form
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
  });
}
