import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../security/secure_storage_service.dart';

part 'session_tracker.g.dart';

class UserSession {
  final String sessionId;
  final String userId;
  final DateTime startTime;

  const UserSession({
    required this.sessionId,
    required this.userId,
    required this.startTime,
  });
}

@riverpod
class SessionTracker extends _$SessionTracker {
  UserSession? _currentSession;

  @override
  UserSession? build() {
    _loadPersistedSession();
    return _currentSession;
  }

  void _loadPersistedSession() {
    try {
      final tempDir = Directory.systemTemp.path;
      final file = File('$tempDir/naseeji_secure_session.txt');
      if (file.existsSync()) {
        final Map<String, dynamic> decoded = json.decode(file.readAsStringSync());
        final userId = decoded['session_user_id'];
        if (userId != null) {
          _currentSession = UserSession(
            sessionId: 'sess_restored',
            userId: userId.toString(),
            startTime: DateTime.now(),
          );
          state = _currentSession;
        }
      }
    } catch (_) {}
  }

  void startSession(String userId) {
    final sessionId = 'sess_${DateTime.now().millisecondsSinceEpoch}';
    final deviceModel = '${Platform.operatingSystem} (${Platform.operatingSystemVersion})';

    _currentSession = UserSession(
      sessionId: sessionId,
      userId: userId,
      startTime: DateTime.now(),
    );
    state = _currentSession;

    // Persist login state
    SecureStorageService.write(key: 'session_user_id', value: userId);
    SecureStorageService.write(key: 'device_model', value: deviceModel);

    logAction('SESSION_START', metadata: {
      'userId': userId,
      'deviceModel': deviceModel,
      'startTime': _currentSession!.startTime.toIso8601String(),
    });
  }

  void endSession() {
    if (_currentSession == null) return;

    logAction('SESSION_END', metadata: {
      'userId': _currentSession!.userId,
      'durationSeconds': DateTime.now().difference(_currentSession!.startTime).inSeconds,
    });

    SecureStorageService.clearAll();
    _currentSession = null;
    state = null;
  }

  void logAction(String actionName, {Map<String, dynamic>? metadata}) {
    final timestamp = DateTime.now().toIso8601String();
    final sessId = _currentSession?.sessionId ?? 'no_active_session';
    final usrId = _currentSession?.userId ?? 'anonymous';

    // Structured logging map
    final logPayload = {
      'timestamp': timestamp,
      'sessionId': sessId,
      'userId': usrId,
      'action': actionName,
      if (metadata != null) 'metadata': metadata,
    };

    developer.log(
      'NaseejiSessionTracker: $logPayload',
      name: 'naseeji.session',
      time: DateTime.now(),
    );
  }
}
