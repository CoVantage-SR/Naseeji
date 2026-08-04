import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/enums/account_mode.dart';
import '../../shared/enums/user_role.dart';

class SessionData {
  final String? accessToken;
  final String? refreshToken;
  final UserRole role;
  final AccountMode mode;
  final String? profileId;
  final String? factoryId;
  final String? supplierId;
  final String language;
  final ThemeMode themeMode;
  final bool isLoggedIn;
  final bool isGuest;
  final bool basicProfileCompleted;
  final int completionPercentage;
  final String verificationStatus; // 'unverified', 'pending', 'verified', 'rejected'
  final String verificationLevel; // 'guest', 'basic', 'phone_verified', 'identity_verified', 'business_verified', 'premium_verified'
  final String verificationMethod; // 'company', 'identity'
  final String? entityName;
  final String? ownerName;
  final String? governorate;
  final String? city;
  final String? address;
  final String? category;
  final String? logoUrl;
  final String? businessType;
  final String? idFrontUrl;
  final String? idBackUrl;
  final String? selfieUrl;

  const SessionData({
    this.accessToken,
    this.refreshToken,
    this.role = UserRole.factory,
    this.mode = AccountMode.real,
    this.profileId,
    this.factoryId,
    this.supplierId,
    this.language = 'ar',
    this.themeMode = ThemeMode.system,
    this.isLoggedIn = false,
    this.isGuest = false,
    this.basicProfileCompleted = false,
    this.completionPercentage = 0,
    this.verificationStatus = 'unverified',
    this.verificationLevel = 'basic',
    this.verificationMethod = 'company',
    this.entityName,
    this.ownerName,
    this.governorate,
    this.city,
    this.address,
    this.category,
    this.logoUrl,
    this.businessType,
    this.idFrontUrl,
    this.idBackUrl,
    this.selfieUrl,
  });

  SessionData copyWith({
    String? accessToken,
    String? refreshToken,
    UserRole? role,
    AccountMode? mode,
    String? profileId,
    String? factoryId,
    String? supplierId,
    String? language,
    ThemeMode? themeMode,
    bool? isLoggedIn,
    bool? isGuest,
    bool? basicProfileCompleted,
    int? completionPercentage,
    String? verificationStatus,
    String? verificationLevel,
    String? verificationMethod,
    String? entityName,
    String? ownerName,
    String? governorate,
    String? city,
    String? address,
    String? category,
    String? logoUrl,
    String? businessType,
    String? idFrontUrl,
    String? idBackUrl,
    String? selfieUrl,
  }) {
    return SessionData(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      role: role ?? this.role,
      mode: mode ?? this.mode,
      profileId: profileId ?? this.profileId,
      factoryId: factoryId ?? this.factoryId,
      supplierId: supplierId ?? this.supplierId,
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isGuest: isGuest ?? this.isGuest,
      basicProfileCompleted: basicProfileCompleted ?? this.basicProfileCompleted,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      verificationLevel: verificationLevel ?? this.verificationLevel,
      verificationMethod: verificationMethod ?? this.verificationMethod,
      entityName: entityName ?? this.entityName,
      ownerName: ownerName ?? this.ownerName,
      governorate: governorate ?? this.governorate,
      city: city ?? this.city,
      address: address ?? this.address,
      category: category ?? this.category,
      logoUrl: logoUrl ?? this.logoUrl,
      businessType: businessType ?? this.businessType,
      idFrontUrl: idFrontUrl ?? this.idFrontUrl,
      idBackUrl: idBackUrl ?? this.idBackUrl,
      selfieUrl: selfieUrl ?? this.selfieUrl,
    );
  }
}

class SessionManager {
  static const _kAccessToken = 'session_access_token';
  static const _kRefreshToken = 'session_refresh_token';
  static const _kUserRole = 'session_user_role';
  static const _kAccountMode = 'session_account_mode';
  static const _kProfileId = 'session_profile_id';
  static const _kFactoryId = 'session_factory_id';
  static const _kSupplierId = 'session_supplier_id';
  static const _kLanguage = 'session_language';
  static const _kThemeMode = 'session_theme_mode';
  static const _kIsLoggedIn = 'session_is_logged_in';
  static const _kIsGuest = 'session_is_guest';
  static const _kBasicProfileCompleted = 'session_basic_profile_completed';
  static const _kCompletionPercentage = 'session_completion_percentage';
  static const _kVerificationStatus = 'session_verification_status';
  static const _kVerificationLevel = 'session_verification_level';
  static const _kVerificationMethod = 'session_verification_method';
  static const _kEntityName = 'session_entity_name';
  static const _kOwnerName = 'session_owner_name';
  static const _kGovernorate = 'session_governorate';
  static const _kCity = 'session_city';
  static const _kAddress = 'session_address';
  static const _kCategory = 'session_category';
  static const _kLogoUrl = 'session_logo_url';
  static const _kBusinessType = 'session_business_type';
  static const _kIdFrontUrl = 'session_id_front_url';
  static const _kIdBackUrl = 'session_id_back_url';
  static const _kSelfieUrl = 'session_selfie_url';

  final SharedPreferences _prefs;
  SessionData _currentSession;

  SessionManager(this._prefs) : _currentSession = const SessionData() {
    _loadFromStorage();
  }

  SessionData get currentSession => _currentSession;

  void _loadFromStorage() {
    final token = _prefs.getString(_kAccessToken);
    final refresh = _prefs.getString(_kRefreshToken);
    final roleStr = _prefs.getString(_kUserRole);
    final modeStr = _prefs.getString(_kAccountMode);
    final profile = _prefs.getString(_kProfileId);
    final factory = _prefs.getString(_kFactoryId);
    final supplier = _prefs.getString(_kSupplierId);
    final lang = _prefs.getString(_kLanguage) ?? 'ar';
    final themeStr = _prefs.getString(_kThemeMode);
    final loggedIn = _prefs.getBool(_kIsLoggedIn) ?? (token != null && token.isNotEmpty);
    final guest = _prefs.getBool(_kIsGuest) ?? false;
    final basicCompleted = _prefs.getBool(_kBasicProfileCompleted) ?? false;
    final completionPct = _prefs.getInt(_kCompletionPercentage) ?? (basicCompleted ? 45 : 0);
    final vStatus = _prefs.getString(_kVerificationStatus) ?? 'unverified';
    final vLevel = _prefs.getString(_kVerificationLevel) ?? (guest ? 'guest' : 'basic');
    final vMethod = _prefs.getString(_kVerificationMethod) ?? 'company';
    final eName = _prefs.getString(_kEntityName);
    final oName = _prefs.getString(_kOwnerName);
    final gov = _prefs.getString(_kGovernorate);
    final cty = _prefs.getString(_kCity);
    final addr = _prefs.getString(_kAddress);
    final cat = _prefs.getString(_kCategory);
    final logo = _prefs.getString(_kLogoUrl);
    final bType = _prefs.getString(_kBusinessType);
    final front = _prefs.getString(_kIdFrontUrl);
    final back = _prefs.getString(_kIdBackUrl);
    final selfie = _prefs.getString(_kSelfieUrl);

    UserRole role = UserRole.factory;
    if (roleStr == 'supplier') role = UserRole.supplier;

    AccountMode mode = AccountMode.real;
    if (modeStr == 'demo') mode = AccountMode.demo;

    ThemeMode themeMode = ThemeMode.system;
    if (themeStr == 'dark') themeMode = ThemeMode.dark;
    if (themeStr == 'light') themeMode = ThemeMode.light;

    _currentSession = SessionData(
      accessToken: token,
      refreshToken: refresh,
      role: role,
      mode: mode,
      profileId: profile,
      factoryId: factory,
      supplierId: supplier,
      language: lang,
      themeMode: themeMode,
      isLoggedIn: loggedIn,
      isGuest: guest,
      basicProfileCompleted: basicCompleted,
      completionPercentage: completionPct,
      verificationStatus: vStatus,
      verificationLevel: vLevel,
      verificationMethod: vMethod,
      entityName: eName,
      ownerName: oName,
      governorate: gov,
      city: cty,
      address: addr,
      category: cat,
      logoUrl: logo,
      businessType: bType,
      idFrontUrl: front,
      idBackUrl: back,
      selfieUrl: selfie,
    );
  }

  Future<void> saveSession({
    required String accessToken,
    String? refreshToken,
    required UserRole role,
    AccountMode mode = AccountMode.real,
    String? profileId,
    String? factoryId,
    String? supplierId,
    bool basicProfileCompleted = true,
    int completionPercentage = 40,
    String verificationStatus = 'unverified',
  }) async {
    await _prefs.setString(_kAccessToken, accessToken);
    if (refreshToken != null) await _prefs.setString(_kRefreshToken, refreshToken);
    await _prefs.setString(_kUserRole, role.name);
    await _prefs.setString(_kAccountMode, mode.name);
    if (profileId != null) await _prefs.setString(_kProfileId, profileId);
    if (factoryId != null) await _prefs.setString(_kFactoryId, factoryId);
    if (supplierId != null) await _prefs.setString(_kSupplierId, supplierId);
    await _prefs.setBool(_kIsLoggedIn, true);
    await _prefs.setBool(_kIsGuest, false);
    await _prefs.setBool(_kBasicProfileCompleted, basicProfileCompleted);
    await _prefs.setInt(_kCompletionPercentage, completionPercentage);
    await _prefs.setString(_kVerificationStatus, verificationStatus);

    _currentSession = _currentSession.copyWith(
      accessToken: accessToken,
      refreshToken: refreshToken,
      role: role,
      mode: mode,
      profileId: profileId,
      factoryId: factoryId,
      supplierId: supplierId,
      isLoggedIn: true,
      isGuest: false,
      basicProfileCompleted: basicProfileCompleted,
      completionPercentage: completionPercentage,
      verificationStatus: verificationStatus,
    );
  }

  Future<void> enterGuestMode(UserRole role) async {
    await _prefs.setString(_kUserRole, role.name);
    await _prefs.setBool(_kIsLoggedIn, false);
    await _prefs.setBool(_kIsGuest, true);

    _currentSession = _currentSession.copyWith(
      role: role,
      isLoggedIn: false,
      isGuest: true,
    );
  }

  Future<void> saveBasicProfile({
    required String entityName,
    required String ownerName,
    required String governorate,
    required String city,
    required String address,
    required String category,
    String? logoUrl,
    required UserRole role,
  }) async {
    await _prefs.setString(_kEntityName, entityName);
    await _prefs.setString(_kOwnerName, ownerName);
    await _prefs.setString(_kGovernorate, governorate);
    await _prefs.setString(_kCity, city);
    await _prefs.setString(_kAddress, address);
    await _prefs.setString(_kCategory, category);
    if (logoUrl != null) await _prefs.setString(_kLogoUrl, logoUrl);
    await _prefs.setBool(_kBasicProfileCompleted, true);
    await _prefs.setInt(_kCompletionPercentage, 40);
    await _prefs.setString(_kUserRole, role.name);
    await _prefs.setBool(_kIsLoggedIn, true);
    await _prefs.setBool(_kIsGuest, false);

    _currentSession = _currentSession.copyWith(
      entityName: entityName,
      ownerName: ownerName,
      governorate: governorate,
      city: city,
      address: address,
      category: category,
      logoUrl: logoUrl,
      role: role,
      basicProfileCompleted: true,
      completionPercentage: 40,
      isLoggedIn: true,
      isGuest: false,
    );
  }

  Future<void> updateCompletionPercentage(int percentage) async {
    await _prefs.setInt(_kCompletionPercentage, percentage);
    _currentSession = _currentSession.copyWith(completionPercentage: percentage);
  }

  Future<void> updateVerificationStatus(String status) async {
    await _prefs.setString(_kVerificationStatus, status);
    _currentSession = _currentSession.copyWith(verificationStatus: status);
  }

  Future<void> updateVerificationDetails({
    required String status,
    required String level,
    required String method,
    String? businessType,
    String? idFrontUrl,
    String? idBackUrl,
    String? selfieUrl,
  }) async {
    await _prefs.setString(_kVerificationStatus, status);
    await _prefs.setString(_kVerificationLevel, level);
    await _prefs.setString(_kVerificationMethod, method);
    if (businessType != null) await _prefs.setString(_kBusinessType, businessType);
    if (idFrontUrl != null) await _prefs.setString(_kIdFrontUrl, idFrontUrl);
    if (idBackUrl != null) await _prefs.setString(_kIdBackUrl, idBackUrl);
    if (selfieUrl != null) await _prefs.setString(_kSelfieUrl, selfieUrl);

    _currentSession = _currentSession.copyWith(
      verificationStatus: status,
      verificationLevel: level,
      verificationMethod: method,
      businessType: businessType,
      idFrontUrl: idFrontUrl,
      idBackUrl: idBackUrl,
      selfieUrl: selfieUrl,
    );
  }

  Future<void> switchRole(UserRole role) async {
    await _prefs.setString(_kUserRole, role.name);
    _currentSession = _currentSession.copyWith(role: role);
  }

  Future<void> switchMode(AccountMode mode) async {
    await _prefs.setString(_kAccountMode, mode.name);
    _currentSession = _currentSession.copyWith(mode: mode);
  }

  Future<void> updateThemeMode(ThemeMode themeMode) async {
    await _prefs.setString(_kThemeMode, themeMode.name);
    _currentSession = _currentSession.copyWith(themeMode: themeMode);
  }

  Future<void> updateLanguage(String language) async {
    await _prefs.setString(_kLanguage, language);
    _currentSession = _currentSession.copyWith(language: language);
  }

  Future<void> clearSession() async {
    await _prefs.remove(_kAccessToken);
    await _prefs.remove(_kRefreshToken);
    await _prefs.remove(_kUserRole);
    await _prefs.remove(_kAccountMode);
    await _prefs.remove(_kProfileId);
    await _prefs.remove(_kFactoryId);
    await _prefs.remove(_kSupplierId);
    await _prefs.setBool(_kIsLoggedIn, false);
    await _prefs.setBool(_kIsGuest, false);
    await _prefs.setBool(_kBasicProfileCompleted, false);
    await _prefs.remove(_kCompletionPercentage);
    await _prefs.remove(_kVerificationStatus);
    await _prefs.remove(_kEntityName);
    await _prefs.remove(_kOwnerName);
    await _prefs.remove(_kGovernorate);
    await _prefs.remove(_kCity);
    await _prefs.remove(_kAddress);
    await _prefs.remove(_kCategory);
    await _prefs.remove(_kLogoUrl);

    _currentSession = const SessionData();
  }
}


