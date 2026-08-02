// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Naseeji Industrial Platform';

  @override
  String get loginTitle => 'Sign In';

  @override
  String get loginSubtitle => 'Welcome back! Sign in to access your account';

  @override
  String get emailOrPhoneLabel => 'Email or Phone Number';

  @override
  String get emailOrPhoneHint => 'Enter your email or phone number';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get loginButton => 'Sign In';

  @override
  String get orDivider => 'OR';

  @override
  String get googleSignIn => 'Sign in with Google';

  @override
  String get noAccountTitle => 'Don\'t have an account?';

  @override
  String get noAccountSubtitle => 'Select your account type to join Naseeji';

  @override
  String get supplierRoleTitle => 'Supplier';

  @override
  String get supplierRoleSubtitle =>
      'Sell products, receive factory orders, and negotiate prices';

  @override
  String get supplierRegisterButton => 'Register as Supplier';

  @override
  String get factoryRoleTitle => 'Factory';

  @override
  String get factoryRoleSubtitle =>
      'Buy materials, raw products, and submit purchase orders';

  @override
  String get factoryRegisterButton => 'Register as Factory';

  @override
  String get exploreDemoText =>
      'Explore the platform as a demo without registration';

  @override
  String get exploreDemoButton => 'Try Demo';

  @override
  String get demoAsFactory => 'Try platform as Factory';

  @override
  String get demoAsSupplier => 'Try platform as Supplier';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get brandTagline =>
      'Digital Textile Platform for Factories & Suppliers';

  @override
  String get valRequired => 'This field is required';

  @override
  String get valInvalidEmail => 'Please enter a valid email address';

  @override
  String get valInvalidPhone => 'Phone number must be at least 10 digits';

  @override
  String get valInvalidEmailOrPhone =>
      'Please enter a valid email address or phone number';

  @override
  String get valPasswordLength => 'Password must be at least 6 characters';
}
