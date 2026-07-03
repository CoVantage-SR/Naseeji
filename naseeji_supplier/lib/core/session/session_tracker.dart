import 'dart:developer' as developer;
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
    return null; // No active session initially
  }

  void startSession(String userId) {
    final sessionId = 'sess_${DateTime.now().millisecondsSinceEpoch}';
    _currentSession = UserSession(
      sessionId: sessionId,
      userId: userId,
      startTime: DateTime.now(),
    );
    state = _currentSession;

    logAction('SESSION_START', metadata: {
      'userId': userId,
      'startTime': _currentSession!.startTime.toIso8601String(),
    });
  }

  void endSession() {
    if (_currentSession == null) return;

    logAction('SESSION_END', metadata: {
      'userId': _currentSession!.userId,
      'durationSeconds': DateTime.now().difference(_currentSession!.startTime).inSeconds,
    });

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

    // Print to developer log (which can be streamed or integrated with crashlytics/mixpanel later)
    developer.log(
      'NaseejiSessionTracker: $logPayload',
      name: 'naseeji.session',
      time: DateTime.now(),
    );
  }
}
