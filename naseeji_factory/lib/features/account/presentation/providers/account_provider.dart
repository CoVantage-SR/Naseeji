import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/account_mock_database.dart';
import '../../domain/entities/account_entities.dart';

part 'account_provider.g.dart';

// ─── Enums ─────────────────────────────────────────────────────────────────

enum EmployeeRole {
  owner,
  admin,
  purchasingManager,
  warehouseManager,
  qualityInspector,
  accountant,
  viewer,
}

extension EmployeeRoleLabel on EmployeeRole {
  String get label {
    switch (this) {
      case EmployeeRole.owner:
        return 'المالك';
      case EmployeeRole.admin:
        return 'مدير';
      case EmployeeRole.purchasingManager:
        return 'مدير المشتريات';
      case EmployeeRole.warehouseManager:
        return 'مدير المخزن';
      case EmployeeRole.qualityInspector:
        return 'مفتش الجودة';
      case EmployeeRole.accountant:
        return 'محاسب';
      case EmployeeRole.viewer:
        return 'مشاهد فقط';
    }
  }
}

enum EmployeeStatus { active, inactive, pending }

extension EmployeeStatusLabel on EmployeeStatus {
  String get label {
    switch (this) {
      case EmployeeStatus.active:
        return 'نشط';
      case EmployeeStatus.inactive:
        return 'غير نشط';
      case EmployeeStatus.pending:
        return 'في الانتظار';
    }
  }
}

enum AppThemeMode { light, dark, system, amoled }

extension AppThemeModeLabel on AppThemeMode {
  String get label {
    switch (this) {
      case AppThemeMode.light:
        return 'فاتح';
      case AppThemeMode.dark:
        return 'داكن';
      case AppThemeMode.system:
        return 'متابعة الجهاز';
      case AppThemeMode.amoled:
        return 'AMOLED داكن';
    }
  }
}

// ─── Models & Adapter Wrappers ──────────────────────────────────────────────

typedef FactoryProfileModel = FactoryProfileEntity;

class SubscriptionModel {
  final String planName;
  final String status;
  final String expiryDate;
  final String startDate;
  final int remainingDays;
  final int productsPurchased;
  final int productsLimit;

  const SubscriptionModel({
    required this.planName,
    required this.status,
    required this.expiryDate,
    required this.startDate,
    required this.remainingDays,
    required this.productsPurchased,
    required this.productsLimit,
  });
}

typedef WalletModel = WalletEntity;

class EmployeesSummaryModel {
  final int totalEmployees;
  final int activeEmployees;
  final int pendingInvitations;

  const EmployeesSummaryModel({
    required this.totalEmployees,
    required this.activeEmployees,
    required this.pendingInvitations,
  });
}

typedef RewardPointsModel = RewardStateEntity;

class SecurityModel {
  final bool biometricEnabled;
  final bool twoFactorEnabled;
  final int trustedDevicesCount;
  final String lastPasswordChange;

  const SecurityModel({
    required this.biometricEnabled,
    required this.twoFactorEnabled,
    required this.trustedDevicesCount,
    required this.lastPasswordChange,
  });

  SecurityModel copyWith({
    bool? biometricEnabled,
    bool? twoFactorEnabled,
    int? trustedDevicesCount,
    String? lastPasswordChange,
  }) {
    return SecurityModel(
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      trustedDevicesCount: trustedDevicesCount ?? this.trustedDevicesCount,
      lastPasswordChange: lastPasswordChange ?? this.lastPasswordChange,
    );
  }
}

class NotificationSettingsModel {
  final bool pushNotifications;
  final bool emailNotifications;
  final bool dealNotifications;
  final bool rfqNotifications;

  const NotificationSettingsModel({
    required this.pushNotifications,
    required this.emailNotifications,
    required this.dealNotifications,
    required this.rfqNotifications,
  });

  NotificationSettingsModel copyWith({
    bool? pushNotifications,
    bool? emailNotifications,
    bool? dealNotifications,
    bool? rfqNotifications,
  }) {
    return NotificationSettingsModel(
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      dealNotifications: dealNotifications ?? this.dealNotifications,
      rfqNotifications: rfqNotifications ?? this.rfqNotifications,
    );
  }
}

typedef EmployeeModel = EmployeeEntity;

class AppSettingsModel {
  final AppThemeMode themeMode;
  final String language;
  final String currency;
  final String timeZone;
  final String dateFormat;
  final Map<String, Map<String, bool>> notificationSettings;

  const AppSettingsModel({
    required this.themeMode,
    required this.language,
    required this.currency,
    required this.timeZone,
    required this.dateFormat,
    required this.notificationSettings,
  });

  AppSettingsModel copyWith({
    AppThemeMode? themeMode,
    String? language,
    String? currency,
    String? timeZone,
    String? dateFormat,
    Map<String, Map<String, bool>>? notificationSettings,
  }) {
    return AppSettingsModel(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      currency: currency ?? this.currency,
      timeZone: timeZone ?? this.timeZone,
      dateFormat: dateFormat ?? this.dateFormat,
      notificationSettings: notificationSettings ?? this.notificationSettings,
    );
  }
}

// ─── State Definition ───────────────────────────────────────────────────────

class AccountState {
  final FactoryProfileEntity profile;
  final List<EmployeeEntity> employees;
  final WalletEntity wallet;
  final RewardStateEntity rewards;
  final List<NotificationItemEntity> notifications;
  final List<SupportTicketEntity> supportTickets;

  const AccountState({
    required this.profile,
    required this.employees,
    required this.wallet,
    required this.rewards,
    required this.notifications,
    required this.supportTickets,
  });

  AccountState copyWith({
    FactoryProfileEntity? profile,
    List<EmployeeEntity>? employees,
    WalletEntity? wallet,
    RewardStateEntity? rewards,
    List<NotificationItemEntity>? notifications,
    List<SupportTicketEntity>? supportTickets,
  }) {
    return AccountState(
      profile: profile ?? this.profile,
      employees: employees ?? this.employees,
      wallet: wallet ?? this.wallet,
      rewards: rewards ?? this.rewards,
      notifications: notifications ?? this.notifications,
      supportTickets: supportTickets ?? this.supportTickets,
    );
  }
}

// ─── Account Notifier ───────────────────────────────────────────────────────

@riverpod
class AccountNotifier extends _$AccountNotifier {
  @override
  AccountState build() {
    final db = AccountMockDatabase.instance;
    return AccountState(
      profile: db.factoryProfile,
      employees: db.employees,
      wallet: db.wallet,
      rewards: db.rewards,
      notifications: db.notifications,
      supportTickets: db.supportTickets,
    );
  }

  void updateProfile(FactoryProfileEntity updated) {
    AccountMockDatabase.instance.updateFactoryProfile(updated);
    state = state.copyWith(
      profile: AccountMockDatabase.instance.factoryProfile,
      employees: AccountMockDatabase.instance.employees,
    );
  }

  void withdrawMoney(double amount, String bankId) {
    AccountMockDatabase.instance.withdrawMoney(amount, bankId);
    state = state.copyWith(wallet: AccountMockDatabase.instance.wallet);
  }

  void depositMoney(double amount) {
    AccountMockDatabase.instance.depositMoney(amount);
    state = state.copyWith(wallet: AccountMockDatabase.instance.wallet);
  }

  void redeemReward(RewardItemEntity reward) {
    AccountMockDatabase.instance.redeemReward(reward);
    state = state.copyWith(rewards: AccountMockDatabase.instance.rewards);
  }

  void addEmployee(EmployeeEntity emp) {
    AccountMockDatabase.instance.addEmployee(emp);
    state = state.copyWith(
      employees: AccountMockDatabase.instance.employees,
      profile: AccountMockDatabase.instance.factoryProfile,
    );
  }

  void updateEmployee(EmployeeEntity updated) {
    AccountMockDatabase.instance.updateEmployee(updated);
    state = state.copyWith(employees: AccountMockDatabase.instance.employees);
  }

  void removeEmployee(String id) {
    AccountMockDatabase.instance.removeEmployee(id);
    state = state.copyWith(employees: AccountMockDatabase.instance.employees);
  }

  void toggleEmployeeStatus(String id) {
    final emp = state.employees.firstWhere((e) => e.id == id);
    final newStatus = emp.status == 'active' ? 'inactive' : 'active';
    final updated = EmployeeEntity(
      id: emp.id,
      name: emp.name,
      jobTitle: emp.jobTitle,
      phone: emp.phone,
      email: emp.email,
      photoUrl: emp.photoUrl,
      role: emp.role,
      status: newStatus,
      department: emp.department,
      lastLogin: emp.lastLogin,
      permissions: emp.permissions,
    );
    AccountMockDatabase.instance.updateEmployee(updated);
    state = state.copyWith(employees: AccountMockDatabase.instance.employees);
  }

  void markNotificationRead(String id) {
    AccountMockDatabase.instance.markNotificationRead(id);
    state = state.copyWith(notifications: AccountMockDatabase.instance.notifications);
  }

  void markAllNotificationsRead() {
    AccountMockDatabase.instance.markAllNotificationsRead();
    state = state.copyWith(notifications: AccountMockDatabase.instance.notifications);
  }

  void deleteNotification(String id) {
    AccountMockDatabase.instance.deleteNotification(id);
    state = state.copyWith(notifications: AccountMockDatabase.instance.notifications);
  }

  void renewSubscription(String planName) {
    AccountMockDatabase.instance.renewSubscription(planName);
    state = state.copyWith(profile: AccountMockDatabase.instance.factoryProfile);
  }

  void createSupportTicket(String subject, String category, String details) {
    AccountMockDatabase.instance.createSupportTicket(subject, category, details);
    state = state.copyWith(supportTickets: AccountMockDatabase.instance.supportTickets);
  }

  List<EmployeeEntity> searchEmployees(String query) {
    if (query.isEmpty) return state.employees;
    final q = query.toLowerCase();
    return state.employees
        .where((e) =>
            e.name.toLowerCase().contains(q) ||
            e.jobTitle.toLowerCase().contains(q) ||
            e.email.toLowerCase().contains(q))
        .toList();
  }
}

// ─── Individual Reactive Providers ──────────────────────────────────────────

@riverpod
FactoryProfileEntity factory(FactoryRef ref) {
  return ref.watch(accountNotifierProvider).profile;
}

@riverpod
SubscriptionModel subscription(SubscriptionRef ref) {
  final profile = ref.watch(factoryProvider);
  return SubscriptionModel(
    planName: profile.subscriptionPlan,
    status: profile.subscriptionStatus,
    expiryDate: profile.subscriptionExpiry,
    startDate: profile.subscriptionStartDate,
    remainingDays: 326,
    productsPurchased: profile.productsPurchased,
    productsLimit: profile.productsLimit,
  );
}

@riverpod
WalletEntity wallet(WalletRef ref) {
  return ref.watch(accountNotifierProvider).wallet;
}

@riverpod
EmployeesSummaryModel employees(EmployeesRef ref) {
  final list = ref.watch(accountNotifierProvider).employees;
  final active = list.where((e) => e.status == 'active').length;
  final pending = list.where((e) => e.status == 'pending').length;
  return EmployeesSummaryModel(
    totalEmployees: list.length,
    activeEmployees: active,
    pendingInvitations: pending,
  );
}

@riverpod
RewardStateEntity rewardPoints(RewardPointsRef ref) {
  return ref.watch(accountNotifierProvider).rewards;
}

@riverpod
List<NotificationItemEntity> notifications(NotificationsRef ref) {
  return ref.watch(accountNotifierProvider).notifications;
}

@riverpod
List<SupportTicketEntity> supportTickets(SupportTicketsRef ref) {
  return ref.watch(accountNotifierProvider).supportTickets;
}

@riverpod
class SecurityNotifier extends _$SecurityNotifier {
  @override
  SecurityModel build() {
    return const SecurityModel(
      biometricEnabled: true,
      twoFactorEnabled: true,
      trustedDevicesCount: 2,
      lastPasswordChange: 'منذ ٣٠ يوماً',
    );
  }

  void toggleBiometric(bool val) {
    state = state.copyWith(biometricEnabled: val);
  }

  void toggleTwoFactor(bool val) {
    state = state.copyWith(twoFactorEnabled: val);
  }
}

@riverpod
class NotificationSettingsNotifier extends _$NotificationSettingsNotifier {
  @override
  NotificationSettingsModel build() {
    return const NotificationSettingsModel(
      pushNotifications: true,
      emailNotifications: true,
      dealNotifications: true,
      rfqNotifications: true,
    );
  }

  void togglePush(bool val) => state = state.copyWith(pushNotifications: val);
  void toggleEmail(bool val) => state = state.copyWith(emailNotifications: val);
  void toggleDeal(bool val) => state = state.copyWith(dealNotifications: val);
  void toggleRfq(bool val) => state = state.copyWith(rfqNotifications: val);
}

@riverpod
class PaymentNotifier extends _$PaymentNotifier {
  @override
  List<Map<String, String>> build() {
    return [
      {
        'id': 'PM-1',
        'type': 'بنكي',
        'title': 'الحساب البنكي (CIB)',
        'subtitle': '**** **** 8821',
        'isDefault': 'true',
      },
      {
        'id': 'PM-2',
        'type': 'بطاقة',
        'title': 'بطاقة ميزا التجاري',
        'subtitle': '**** **** 4490',
        'isDefault': 'false',
      },
    ];
  }
}

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  AppSettingsModel build() {
    return AppSettingsModel(
      themeMode: AppThemeMode.system,
      language: 'العربية',
      currency: 'جنيه مصري (EGP)',
      timeZone: 'القاهرة (UTC+3)',
      dateFormat: 'YYYY/MM/DD',
      notificationSettings: _defaultNotifications(),
    );
  }

  void setThemeMode(AppThemeMode mode) {
    state = state.copyWith(themeMode: mode);
  }

  void setLanguage(String lang) {
    state = state.copyWith(language: lang);
  }

  void setCurrency(String val) {
    state = state.copyWith(currency: val);
  }

  void setTimeZone(String val) {
    state = state.copyWith(timeZone: val);
  }

  void setDateFormat(String val) {
    state = state.copyWith(dateFormat: val);
  }

  void setNotification(String category, String type, bool value) {
    final updated = Map<String, Map<String, bool>>.from(state.notificationSettings);
    final cat = Map<String, bool>.from(updated[category] ?? {});
    cat[type] = value;
    updated[category] = cat;
    state = state.copyWith(notificationSettings: updated);
  }

  bool getNotification(String category, String type) {
    return state.notificationSettings[category]?[type] ?? false;
  }
}

Map<String, Map<String, bool>> _defaultNotifications() {
  const categories = [
    'الصفقات', 'عروض الأسعار', 'السوق والمنتجات', 'الرسائل والمحادثات',
    'المدفوعات والمحفظة', 'الاشتراكات والخدمات', 'النظام والأمان',
  ];
  final result = <String, Map<String, bool>>{};
  for (final c in categories) {
    result[c] = {'push': true, 'email': true, 'sms': false, 'whatsapp': false};
  }
  return result;
}
