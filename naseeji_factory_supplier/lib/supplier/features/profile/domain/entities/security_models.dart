class SecuritySettingsModel {
  final bool changePasswordEnabled;
  final bool twoFactorEnabled;
  final bool fingerprintEnabled;
  final bool faceIdEnabled;
  final bool faceIdSupported;
  final String lastPasswordChange;
  final String currentDeviceId;
  final DateTime updatedAt;

  const SecuritySettingsModel({
    this.changePasswordEnabled = true,
    this.twoFactorEnabled = true,
    this.fingerprintEnabled = true,
    this.faceIdEnabled = false,
    this.faceIdSupported = false,
    this.lastPasswordChange = 'منذ 25 يوم',
    this.currentDeviceId = 'DEV-001',
    required this.updatedAt,
  });

  SecuritySettingsModel copyWith({
    bool? changePasswordEnabled,
    bool? twoFactorEnabled,
    bool? fingerprintEnabled,
    bool? faceIdEnabled,
    bool? faceIdSupported,
    String? lastPasswordChange,
    String? currentDeviceId,
    DateTime? updatedAt,
  }) {
    return SecuritySettingsModel(
      changePasswordEnabled: changePasswordEnabled ?? this.changePasswordEnabled,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      fingerprintEnabled: fingerprintEnabled ?? this.fingerprintEnabled,
      faceIdEnabled: faceIdEnabled ?? this.faceIdEnabled,
      faceIdSupported: faceIdSupported ?? this.faceIdSupported,
      lastPasswordChange: lastPasswordChange ?? this.lastPasswordChange,
      currentDeviceId: currentDeviceId ?? this.currentDeviceId,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static SecuritySettingsModel get defaultSettings => SecuritySettingsModel(
        changePasswordEnabled: true,
        twoFactorEnabled: true,
        fingerprintEnabled: true,
        faceIdEnabled: false,
        faceIdSupported: false,
        lastPasswordChange: 'منذ 25 يوم',
        currentDeviceId: 'DEV-001',
        updatedAt: DateTime.now(),
      );
}

class DeviceSessionModel {
  final String deviceId;
  final String deviceName;
  final String platform;
  final String browser;
  final String city;
  final String country;
  final String ipAddress;
  final bool isCurrent;
  final String lastActive;
  final bool isOnline;

  const DeviceSessionModel({
    required this.deviceId,
    required this.deviceName,
    required this.platform,
    required this.browser,
    required this.city,
    required this.country,
    required this.ipAddress,
    required this.isCurrent,
    required this.lastActive,
    this.isOnline = false,
  });

  static List<DeviceSessionModel> get sampleSessions => [
        const DeviceSessionModel(
          deviceId: 'DEV-001',
          deviceName: 'Windows - Chrome',
          platform: 'Windows 11',
          browser: 'Chrome 125',
          city: 'القاهرة',
          country: 'مصر',
          ipAddress: '197.34.120.45',
          isCurrent: true,
          lastActive: 'الآن',
          isOnline: true,
        ),
        const DeviceSessionModel(
          deviceId: 'DEV-002',
          deviceName: 'تطبيق نسيجي - Android',
          platform: 'Android 14',
          browser: 'Naseeji App v2.4',
          city: 'الإسكندرية',
          country: 'مصر',
          ipAddress: '156.204.88.12',
          isCurrent: false,
          lastActive: 'منذ 2 ساعة',
          isOnline: true,
        ),
        const DeviceSessionModel(
          deviceId: 'DEV-003',
          deviceName: 'iOS - Safari',
          platform: 'iOS 17.4',
          browser: 'Safari 17',
          city: 'الرياض',
          country: 'السعودية',
          ipAddress: '212.118.140.90',
          isCurrent: false,
          lastActive: 'منذ 3 أيام',
          isOnline: false,
        ),
      ];
}

class SecurityActivityModel {
  final String activityId;
  final String type; // password_change, 2fa_toggle, login, fingerprint_toggle
  final String title;
  final String description;
  final DateTime createdAt;
  final String deviceId;

  const SecurityActivityModel({
    required this.activityId,
    required this.type,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.deviceId,
  });

  static List<SecurityActivityModel> get sampleActivities => [
        SecurityActivityModel(
          activityId: 'ACT-001',
          type: 'password_change',
          title: 'تغيير كلمة المرور',
          description: 'تم تغيير كلمة المرور بنجاح من جهاز Windows',
          createdAt: DateTime.now().subtract(const Duration(days: 25)),
          deviceId: 'DEV-001',
        ),
        SecurityActivityModel(
          activityId: 'ACT-002',
          type: '2fa_toggle',
          title: 'تم تفعيل التحقق بخطوتين',
          description: 'تم ربط رقم الجوال والتطبيق بالتحقق المزدوج',
          createdAt: DateTime.now().subtract(const Duration(days: 40)),
          deviceId: 'DEV-001',
        ),
        SecurityActivityModel(
          activityId: 'ACT-003',
          type: 'login',
          title: 'تسجيل دخول جديد من Windows',
          description: 'تسجيل دخول ناجح عبر متصفح Chrome',
          createdAt: DateTime.now().subtract(const Duration(days: 45)),
          deviceId: 'DEV-001',
        ),
      ];
}


