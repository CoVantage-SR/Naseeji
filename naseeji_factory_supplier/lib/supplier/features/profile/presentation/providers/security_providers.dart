import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/mock/mock_data.dart';
import '../../domain/entities/security_models.dart';

class SecurityState {
  final SecuritySettingsModel settings;
  final List<DeviceSessionModel> sessions;
  final List<SecurityActivityModel> activities;

  const SecurityState({
    required this.settings,
    required this.sessions,
    required this.activities,
  });

  SecurityState copyWith({
    SecuritySettingsModel? settings,
    List<DeviceSessionModel>? sessions,
    List<SecurityActivityModel>? activities,
  }) {
    return SecurityState(
      settings: settings ?? this.settings,
      sessions: sessions ?? this.sessions,
      activities: activities ?? this.activities,
    );
  }
}

class SecurityNotifier extends StateNotifier<SecurityState> {
  SecurityNotifier()
      : super(
          SecurityState(
            settings: MockDatabase.securitySettings,
            sessions: List.from(MockDatabase.deviceSessions),
            activities: List.from(MockDatabase.securityActivities),
          ),
        );

  void loadSecurity() {
    state = SecurityState(
      settings: MockDatabase.securitySettings,
      sessions: List.from(MockDatabase.deviceSessions),
      activities: List.from(MockDatabase.securityActivities),
    );
  }

  void toggleTwoFactor(bool value) {
    final newSettings = state.settings.copyWith(
      twoFactorEnabled: value,
      updatedAt: DateTime.now(),
    );
    MockDatabase.securitySettings = newSettings;

    // Add security activity
    final newActivity = SecurityActivityModel(
      activityId: 'ACT-${DateTime.now().millisecondsSinceEpoch}',
      type: '2fa_toggle',
      title: value ? 'تم تفعيل التحقق بخطوتين' : 'تم تعطيل التحقق بخطوتين',
      description: value ? 'تم تفعيل حماية الدخول المزدوج' : 'تم إيقاف حماية الدخول المزدوج',
      createdAt: DateTime.now(),
      deviceId: state.settings.currentDeviceId,
    );
    MockDatabase.securityActivities.insert(0, newActivity);

    state = state.copyWith(
      settings: newSettings,
      activities: List.from(MockDatabase.securityActivities),
    );
  }

  void toggleFingerprint(bool value) {
    final newSettings = state.settings.copyWith(
      fingerprintEnabled: value,
      updatedAt: DateTime.now(),
    );
    MockDatabase.securitySettings = newSettings;

    final newActivity = SecurityActivityModel(
      activityId: 'ACT-${DateTime.now().millisecondsSinceEpoch}',
      type: 'fingerprint_toggle',
      title: value ? 'تم تفعيل تسجيل الدخول بالبصمة' : 'تم تعطيل البصمة',
      description: 'تم تحديث خيارات الأمان البيومترية',
      createdAt: DateTime.now(),
      deviceId: state.settings.currentDeviceId,
    );
    MockDatabase.securityActivities.insert(0, newActivity);

    state = state.copyWith(
      settings: newSettings,
      activities: List.from(MockDatabase.securityActivities),
    );
  }

  void toggleFaceId(bool value) {
    final newSettings = state.settings.copyWith(
      faceIdEnabled: value,
      updatedAt: DateTime.now(),
    );
    MockDatabase.securitySettings = newSettings;

    state = state.copyWith(settings: newSettings);
  }

  void changePassword() {
    final newSettings = state.settings.copyWith(
      lastPasswordChange: 'الآن',
      updatedAt: DateTime.now(),
    );
    MockDatabase.securitySettings = newSettings;

    final newActivity = SecurityActivityModel(
      activityId: 'ACT-${DateTime.now().millisecondsSinceEpoch}',
      type: 'password_change',
      title: 'تغيير كلمة المرور',
      description: 'تم تغيير كلمة المرور بنجاح',
      createdAt: DateTime.now(),
      deviceId: state.settings.currentDeviceId,
    );
    MockDatabase.securityActivities.insert(0, newActivity);

    state = state.copyWith(
      settings: newSettings,
      activities: List.from(MockDatabase.securityActivities),
    );
  }

  void logoutDevice(String deviceId) {
    MockDatabase.deviceSessions.removeWhere((s) => s.deviceId == deviceId);

    final newActivity = SecurityActivityModel(
      activityId: 'ACT-${DateTime.now().millisecondsSinceEpoch}',
      type: 'logout',
      title: 'تسجيل خروج جهاز',
      description: 'تم إنهاء الجلسة النشطة للجهاز بنجاح',
      createdAt: DateTime.now(),
      deviceId: deviceId,
    );
    MockDatabase.securityActivities.insert(0, newActivity);

    state = state.copyWith(
      sessions: List.from(MockDatabase.deviceSessions),
      activities: List.from(MockDatabase.securityActivities),
    );
  }

  void refreshSessions() {
    state = state.copyWith(
      sessions: List.from(MockDatabase.deviceSessions),
      activities: List.from(MockDatabase.securityActivities),
    );
  }
}

final securityProvider = StateNotifierProvider<SecurityNotifier, SecurityState>((ref) {
  return SecurityNotifier();
});
