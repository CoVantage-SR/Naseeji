import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/enums/account_mode.dart';
import '../../shared/enums/user_role.dart';
import 'session_manager.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize sharedPreferencesProvider in main.dart');
});

final sessionManagerProvider = Provider<SessionManager>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SessionManager(prefs);
});

final sessionNotifierProvider = StateNotifierProvider<SessionNotifier, SessionData>((ref) {
  final sessionManager = ref.watch(sessionManagerProvider);
  return SessionNotifier(sessionManager);
});

class SessionNotifier extends StateNotifier<SessionData> {
  final SessionManager _manager;

  SessionNotifier(this._manager) : super(_manager.currentSession);

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
    await _manager.saveSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      role: role,
      mode: mode,
      profileId: profileId,
      factoryId: factoryId,
      supplierId: supplierId,
      basicProfileCompleted: basicProfileCompleted,
      completionPercentage: completionPercentage,
      verificationStatus: verificationStatus,
    );
    state = _manager.currentSession;
  }

  Future<void> enterGuestMode(UserRole role) async {
    await _manager.enterGuestMode(role);
    state = _manager.currentSession;
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
    await _manager.saveBasicProfile(
      entityName: entityName,
      ownerName: ownerName,
      governorate: governorate,
      city: city,
      address: address,
      category: category,
      logoUrl: logoUrl,
      role: role,
    );
    state = _manager.currentSession;
  }

  Future<void> updateCompletionPercentage(int percentage) async {
    await _manager.updateCompletionPercentage(percentage);
    state = _manager.currentSession;
  }

  Future<void> updateVerificationStatus(String status) async {
    await _manager.updateVerificationStatus(status);
    state = _manager.currentSession;
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
    await _manager.updateVerificationDetails(
      status: status,
      level: level,
      method: method,
      businessType: businessType,
      idFrontUrl: idFrontUrl,
      idBackUrl: idBackUrl,
      selfieUrl: selfieUrl,
    );
    state = _manager.currentSession;
  }

  Future<void> switchRole(UserRole role) async {
    await _manager.switchRole(role);
    state = _manager.currentSession;
  }

  Future<void> switchMode(AccountMode mode) async {
    await _manager.switchMode(mode);
    state = _manager.currentSession;
  }

  Future<void> logout() async {
    await _manager.clearSession();
    state = _manager.currentSession;
  }
}


