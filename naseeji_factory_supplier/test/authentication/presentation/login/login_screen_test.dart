import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naseeji_factory/authentication/presentation/login/login_screen.dart';
import 'package:naseeji_factory/authentication/presentation/login/widgets/demo_explore_banner.dart';
import 'package:naseeji_factory/authentication/presentation/login/widgets/google_sign_in_button.dart';
import 'package:naseeji_factory/authentication/presentation/login/widgets/login_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/fake_services.dart';
import '../../../helpers/pump_helpers.dart';
import '../../../helpers/test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SharedPreferences mockPrefs;

  setUp(() async {
    mockPrefs = await createMockSharedPreferences();
  });

  group('LoginScreen Widget Tests', () {
    testWidgets('renders all core login components properly', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp(child: const LoginScreen(), prefs: mockPrefs));
      await tester.pumpAndSettleClean();

      expect(find.byType(LoginForm), findsOneWidget);
      expect(find.byType(GoogleSignInButton), findsOneWidget);
    });

    testWidgets('validates empty inputs and shows error messages', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp(child: const LoginScreen(), prefs: mockPrefs));
      await tester.pumpAndSettleClean();

      final loginBtn = find.widgetWithText(ElevatedButton, 'تسجيل الدخول');
      expect(loginBtn, findsOneWidget);
      await tester.ensureVisible(loginBtn);
      await tester.pumpAndSettleClean();
      await tester.tap(loginBtn);
      await tester.pumpAndSettleClean();

      expect(find.text('أدخل بريدك الإلكتروني أو رقم هاتفك'), findsWidgets);
      expect(find.text('يرجى إدخال كلمة المرور'), findsOneWidget);
    });

    testWidgets('toggles remember me checkbox state', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp(child: const LoginScreen(), prefs: mockPrefs));
      await tester.pumpAndSettleClean();

      final checkbox = find.byType(Checkbox);
      expect(checkbox, findsOneWidget);

      await tester.tap(checkbox);
      await tester.pumpAndSettleClean();
    });

    testWidgets('toggles password visibility icon', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp(child: const LoginScreen(), prefs: mockPrefs));
      await tester.pumpAndSettleClean();

      final toggleIcon = find.byIcon(Icons.visibility_off_outlined);
      expect(toggleIcon, findsOneWidget);

      await tester.tap(toggleIcon);
      await tester.pumpAndSettleClean();

      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });

    testWidgets('renders in English locale when selected', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp(
        child: const LoginScreen(),
        prefs: mockPrefs,
        locale: const Locale('en'),
      ));
      await tester.pumpAndSettleClean();

      expect(find.text('Sign In'), findsWidgets);
      expect(find.text('Sign in with Google'), findsOneWidget);
    });

    testWidgets('opens guest mode options popup menu', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp(child: const LoginScreen(), prefs: mockPrefs));
      await tester.pumpAndSettleClean();

      final bannerFinder = find.byType(DemoExploreBanner);
      await tester.ensureVisible(bannerFinder);
      await tester.pumpAndSettleClean();

      await tester.tap(bannerFinder);
      await tester.pumpAndSettleClean();

      expect(find.text('تجربة المنصة كمصنع'), findsOneWidget);
      expect(find.text('تجربة المنصة كمورد'), findsOneWidget);
    });
  });
}
