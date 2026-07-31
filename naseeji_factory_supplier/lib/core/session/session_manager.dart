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
  }) async {
    await _prefs.setString(_kAccessToken, accessToken);
    if (refreshToken != null) await _prefs.setString(_kRefreshToken, refreshToken);
    await _prefs.setString(_kUserRole, role.name);
    await _prefs.setString(_kAccountMode, mode.name);
    if (profileId != null) await _prefs.setString(_kProfileId, profileId);
    if (factoryId != null) await _prefs.setString(_kFactoryId, factoryId);
    if (supplierId != null) await _prefs.setString(_kSupplierId, supplierId);
    await _prefs.setBool(_kIsLoggedIn, true);

    _currentSession = _currentSession.copyWith(
      accessToken: accessToken,
      refreshToken: refreshToken,
      role: role,
      mode: mode,
      profileId: profileId,
      factoryId: factoryId,
      supplierId: supplierId,
      isLoggedIn: true,
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

    _currentSession = const SessionData();
  }
}


