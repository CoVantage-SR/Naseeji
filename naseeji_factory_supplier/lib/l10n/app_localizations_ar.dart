// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'منصة نسيجي الصناعية';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get loginSubtitle => 'مرحباً بعودتك! سجّل دخولك للوصول إلى حسابك';

  @override
  String get emailOrPhoneLabel => 'البريد الإلكتروني أو رقم الهاتف';

  @override
  String get emailOrPhoneHint => 'أدخل بريدك الإلكتروني أو رقم هاتفك';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get passwordHint => 'أدخل كلمة المرور';

  @override
  String get rememberMe => 'تذكرني';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get orDivider => 'أو';

  @override
  String get googleSignIn => 'تسجيل الدخول بجوجل';

  @override
  String get noAccountTitle => 'ليس لديك حساب؟';

  @override
  String get noAccountSubtitle =>
      'اختر نوع الحساب الذي يناسبك للانضمام إلى نسيجي';

  @override
  String get supplierRoleTitle => 'مورد';

  @override
  String get supplierRoleSubtitle =>
      'أبيع منتجاتي وأستقبل طلبات المصانع وتفاوض على الأسعار';

  @override
  String get supplierRegisterButton => 'إنشاء حساب كمورد';

  @override
  String get factoryRoleTitle => 'مصنع';

  @override
  String get factoryRoleSubtitle =>
      'أشتري الخامات والمنتجات وأرسل طلبات الشراء';

  @override
  String get factoryRegisterButton => 'إنشاء حساب كمصنع';

  @override
  String get exploreDemoText => 'استكشف المنصة كتجربة دون تسجيل';

  @override
  String get exploreDemoButton => 'تجربة المنصة';

  @override
  String get demoAsFactory => 'تجربة المنصة كمصنع';

  @override
  String get demoAsSupplier => 'تجربة المنصة كمورد';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get brandTagline => 'منصة النسيج الرقمي للمصانع والموردين';

  @override
  String get valRequired => 'هذا الحقل مطلوب';

  @override
  String get valInvalidEmail => 'يرجى إدخال بريد إلكتروني صحيح';

  @override
  String get valInvalidPhone => 'رقم الهاتف يجب أن يتكون من 10 أرقام على الأقل';

  @override
  String get valInvalidEmailOrPhone =>
      'يرجى إدخال بريد إلكتروني أو رقم هاتف صحيح';

  @override
  String get valPasswordLength => 'كلمة المرور يجب أن لا تقل عن 6 أحرف';
}
