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
  }) async {
    await _manager.saveSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      role: role,
      mode: mode,
      profileId: profileId,
      factoryId: factoryId,
      supplierId: supplierId,
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


