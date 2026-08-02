import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ar, this message translates to:
  /// **'منصة نسيجي الصناعية'**
  String get appTitle;

  /// No description provided for @loginTitle.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بعودتك! سجّل دخولك للوصول إلى حسابك'**
  String get loginSubtitle;

  /// No description provided for @emailOrPhoneLabel.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني أو رقم الهاتف'**
  String get emailOrPhoneLabel;

  /// No description provided for @emailOrPhoneHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل بريدك الإلكتروني أو رقم هاتفك'**
  String get emailOrPhoneHint;

  /// No description provided for @passwordLabel.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل كلمة المرور'**
  String get passwordHint;

  /// No description provided for @rememberMe.
  ///
  /// In ar, this message translates to:
  /// **'تذكرني'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In ar, this message translates to:
  /// **'نسيت كلمة المرور؟'**
  String get forgotPassword;

  /// No description provided for @loginButton.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get loginButton;

  /// No description provided for @orDivider.
  ///
  /// In ar, this message translates to:
  /// **'أو'**
  String get orDivider;

  /// No description provided for @googleSignIn.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول بجوجل'**
  String get googleSignIn;

  /// No description provided for @noAccountTitle.
  ///
  /// In ar, this message translates to:
  /// **'ليس لديك حساب؟'**
  String get noAccountTitle;

  /// No description provided for @noAccountSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اختر نوع الحساب الذي يناسبك للانضمام إلى نسيجي'**
  String get noAccountSubtitle;

  /// No description provided for @supplierRoleTitle.
  ///
  /// In ar, this message translates to:
  /// **'مورد'**
  String get supplierRoleTitle;

  /// No description provided for @supplierRoleSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أبيع منتجاتي وأستقبل طلبات المصانع وتفاوض على الأسعار'**
  String get supplierRoleSubtitle;

  /// No description provided for @supplierRegisterButton.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب كمورد'**
  String get supplierRegisterButton;

  /// No description provided for @factoryRoleTitle.
  ///
  /// In ar, this message translates to:
  /// **'مصنع'**
  String get factoryRoleTitle;

  /// No description provided for @factoryRoleSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أشتري الخامات والمنتجات وأرسل طلبات الشراء'**
  String get factoryRoleSubtitle;

  /// No description provided for @factoryRegisterButton.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب كمصنع'**
  String get factoryRegisterButton;

  /// No description provided for @exploreDemoText.
  ///
  /// In ar, this message translates to:
  /// **'استكشف المنصة كتجربة دون تسجيل'**
  String get exploreDemoText;

  /// No description provided for @exploreDemoButton.
  ///
  /// In ar, this message translates to:
  /// **'تجربة المنصة'**
  String get exploreDemoButton;

  /// No description provided for @demoAsFactory.
  ///
  /// In ar, this message translates to:
  /// **'تجربة المنصة كمصنع'**
  String get demoAsFactory;

  /// No description provided for @demoAsSupplier.
  ///
  /// In ar, this message translates to:
  /// **'تجربة المنصة كمورد'**
  String get demoAsSupplier;

  /// No description provided for @languageArabic.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @languageEnglish.
  ///
  /// In ar, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @brandTagline.
  ///
  /// In ar, this message translates to:
  /// **'منصة النسيج الرقمي للمصانع والموردين'**
  String get brandTagline;

  /// No description provided for @valRequired.
  ///
  /// In ar, this message translates to:
  /// **'هذا الحقل مطلوب'**
  String get valRequired;

  /// No description provided for @valInvalidEmail.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال بريد إلكتروني صحيح'**
  String get valInvalidEmail;

  /// No description provided for @valInvalidPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف يجب أن يتكون من 10 أرقام على الأقل'**
  String get valInvalidPhone;

  /// No description provided for @valInvalidEmailOrPhone.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال بريد إلكتروني أو رقم هاتف صحيح'**
  String get valInvalidEmailOrPhone;

  /// No description provided for @valPasswordLength.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور يجب أن لا تقل عن 6 أحرف'**
  String get valPasswordLength;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
