import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naseeji_factory/authentication/presentation/login/login_screen.dart';
import 'package:naseeji_factory/authentication/presentation/login/widgets/demo_explore_banner.dart';
import 'package:naseeji_factory/authentication/presentation/login/widgets/google_sign_in_button.dart';
import 'package:naseeji_factory/authentication/presentation/login/widgets/login_form.dart';
import 'package:naseeji_factory/core/session/session_provider.dart';
import 'package:naseeji_factory/core/theme/app_theme.dart';
import 'package:naseeji_factory/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget buildTestableWidget({
  required SharedPreferences prefs,
  Locale locale = const Locale('ar'),
}) {
  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
    child: MaterialApp(
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
      home: const LoginScreen(),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SharedPreferences mockPrefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    mockPrefs = await SharedPreferences.getInstance();
  });

  group('LoginScreen Widget Tests', () {
    testWidgets('renders all core login components properly', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(prefs: mockPrefs));
      await tester.pumpAndSettle();

      expect(find.byType(LoginForm), findsOneWidget);
      expect(find.byType(GoogleSignInButton), findsOneWidget);
    });

    testWidgets('validates empty inputs and shows error messages', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(prefs: mockPrefs));
      await tester.pumpAndSettle();

      final loginBtn = find.widgetWithText(ElevatedButton, 'تسجيل الدخول');
      expect(loginBtn, findsOneWidget);
      await tester.tap(loginBtn);
      await tester.pumpAndSettle();

      expect(find.text('أدخل بريدك الإلكتروني أو رقم هاتفك'), findsNWidgets(2));
      expect(find.text('يرجى إدخال كلمة المرور'), findsOneWidget);
    });

    testWidgets('toggles remember me checkbox state', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(prefs: mockPrefs));
      await tester.pumpAndSettle();

      final checkbox = find.byType(Checkbox);
      expect(checkbox, findsOneWidget);

      await tester.tap(checkbox);
      await tester.pumpAndSettle();
    });

    testWidgets('toggles password visibility icon', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(prefs: mockPrefs));
      await tester.pumpAndSettle();

      final toggleIcon = find.byIcon(Icons.visibility_off_outlined);
      expect(toggleIcon, findsOneWidget);

      await tester.tap(toggleIcon);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });

    testWidgets('renders in English locale when selected', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(prefs: mockPrefs, locale: const Locale('en')));
      await tester.pumpAndSettle();

      expect(find.text('Sign In'), findsWidgets);
      expect(find.text('Sign in with Google'), findsOneWidget);
    });

    testWidgets('opens guest mode options popup menu', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(prefs: mockPrefs));
      await tester.pumpAndSettle();

      final bannerFinder = find.byType(DemoExploreBanner);
      await tester.ensureVisible(bannerFinder);
      await tester.pumpAndSettle();

      await tester.tap(bannerFinder);
      await tester.pumpAndSettle();

      expect(find.text('تجربة المنصة كمصنع'), findsOneWidget);
      expect(find.text('تجربة المنصة كمورد'), findsOneWidget);
    });
  });
}
