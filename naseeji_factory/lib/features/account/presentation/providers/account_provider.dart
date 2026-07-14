import 'package:riverpod_annotation/riverpod_annotation.dart';

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

enum AppThemeMode { light, dark, system }

extension AppThemeModeLabel on AppThemeMode {
  String get label {
    switch (this) {
      case AppThemeMode.light:
        return 'فاتح';
      case AppThemeMode.dark:
        return 'داكن';
      case AppThemeMode.system:
        return 'متابعة الجهاز';
    }
  }
}

// ─── Models ────────────────────────────────────────────────────────────────

class FactoryProfileModel {
  final String id;
  final String name;
  final String logoUrl;
  final String coverUrl;
  final String description;
  final String establishedYear;
  final String industry;
  final String factoryType;
  final String productionCapacity;
  final int employeeCount;
  final int minOrderQuantity;
  final List<String> marketsServed;
  final String phone;
  final String email;
  final String website;
  final String country;
  final String city;
  final String address;
  final String commercialRegNo;
  final String taxCardNo;
  final bool isVerified;
  final String subscriptionPlan; // 'free', 'basic', 'pro', 'enterprise'
  final String subscriptionExpiry;
  final bool isAccountActive;

  const FactoryProfileModel({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.coverUrl,
    required this.description,
    required this.establishedYear,
    required this.industry,
    required this.factoryType,
    required this.productionCapacity,
    required this.employeeCount,
    required this.minOrderQuantity,
    required this.marketsServed,
    required this.phone,
    required this.email,
    required this.website,
    required this.country,
    required this.city,
    required this.address,
    required this.commercialRegNo,
    required this.taxCardNo,
    required this.isVerified,
    required this.subscriptionPlan,
    required this.subscriptionExpiry,
    required this.isAccountActive,
  });

  FactoryProfileModel copyWith({
    String? name,
    String? logoUrl,
    String? coverUrl,
    String? description,
    String? establishedYear,
    String? industry,
    String? factoryType,
    String? productionCapacity,
    int? employeeCount,
    int? minOrderQuantity,
    List<String>? marketsServed,
    String? phone,
    String? email,
    String? website,
    String? country,
    String? city,
    String? address,
    String? commercialRegNo,
    String? taxCardNo,
  }) {
    return FactoryProfileModel(
      id: id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      description: description ?? this.description,
      establishedYear: establishedYear ?? this.establishedYear,
      industry: industry ?? this.industry,
      factoryType: factoryType ?? this.factoryType,
      productionCapacity: productionCapacity ?? this.productionCapacity,
      employeeCount: employeeCount ?? this.employeeCount,
      minOrderQuantity: minOrderQuantity ?? this.minOrderQuantity,
      marketsServed: marketsServed ?? this.marketsServed,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      country: country ?? this.country,
      city: city ?? this.city,
      address: address ?? this.address,
      commercialRegNo: commercialRegNo ?? this.commercialRegNo,
      taxCardNo: taxCardNo ?? this.taxCardNo,
      isVerified: isVerified,
      subscriptionPlan: subscriptionPlan,
      subscriptionExpiry: subscriptionExpiry,
      isAccountActive: isAccountActive,
    );
  }
}

class EmployeeModel {
  final String id;
  final String name;
  final String jobTitle;
  final String phone;
  final String email;
  final String photoUrl;
  final EmployeeRole role;
  final EmployeeStatus status;
  final String lastLogin;
  final Map<String, bool> permissions;

  const EmployeeModel({
    required this.id,
    required this.name,
    required this.jobTitle,
    required this.phone,
    required this.email,
    required this.photoUrl,
    required this.role,
    required this.status,
    required this.lastLogin,
    required this.permissions,
  });

  EmployeeModel copyWith({
    EmployeeRole? role,
    EmployeeStatus? status,
    Map<String, bool>? permissions,
    String? jobTitle,
  }) {
    return EmployeeModel(
      id: id,
      name: name,
      jobTitle: jobTitle ?? this.jobTitle,
      phone: phone,
      email: email,
      photoUrl: photoUrl,
      role: role ?? this.role,
      status: status ?? this.status,
      lastLogin: lastLogin,
      permissions: permissions ?? this.permissions,
    );
  }
}

class AppSettingsModel {
  final AppThemeMode themeMode;
  final String currency;
  final String timeZone;
  final String dateFormat;
  final Map<String, Map<String, bool>> notificationSettings;

  const AppSettingsModel({
    required this.themeMode,
    required this.currency,
    required this.timeZone,
    required this.dateFormat,
    required this.notificationSettings,
  });

  AppSettingsModel copyWith({
    AppThemeMode? themeMode,
    String? currency,
    String? timeZone,
    String? dateFormat,
    Map<String, Map<String, bool>>? notificationSettings,
  }) {
    return AppSettingsModel(
      themeMode: themeMode ?? this.themeMode,
      currency: currency ?? this.currency,
      timeZone: timeZone ?? this.timeZone,
      dateFormat: dateFormat ?? this.dateFormat,
      notificationSettings: notificationSettings ?? this.notificationSettings,
    );
  }
}

// ─── Default Permissions ────────────────────────────────────────────────────

Map<String, bool> _permissionsForRole(EmployeeRole role) {
  switch (role) {
    case EmployeeRole.owner:
      return {
        'المنتجات': true, 'عروض الأسعار': true, 'الطلبات': true,
        'المالية': true, 'التقارير': true, 'الموظفون': true, 'الإعدادات': true,
      };
    case EmployeeRole.admin:
      return {
        'المنتجات': true, 'عروض الأسعار': true, 'الطلبات': true,
        'المالية': false, 'التقارير': true, 'الموظفون': true, 'الإعدادات': false,
      };
    case EmployeeRole.purchasingManager:
      return {
        'المنتجات': true, 'عروض الأسعار': true, 'الطلبات': true,
        'المالية': false, 'التقارير': false, 'الموظفون': false, 'الإعدادات': false,
      };
    case EmployeeRole.warehouseManager:
      return {
        'المنتجات': false, 'عروض الأسعار': false, 'الطلبات': true,
        'المالية': false, 'التقارير': false, 'الموظفون': false, 'الإعدادات': false,
      };
    case EmployeeRole.qualityInspector:
      return {
        'المنتجات': false, 'عروض الأسعار': false, 'الطلبات': true,
        'المالية': false, 'التقارير': true, 'الموظفون': false, 'الإعدادات': false,
      };
    case EmployeeRole.accountant:
      return {
        'المنتجات': false, 'عروض الأسعار': false, 'الطلبات': false,
        'المالية': true, 'التقارير': true, 'الموظفون': false, 'الإعدادات': false,
      };
    case EmployeeRole.viewer:
      return {
        'المنتجات': false, 'عروض الأسعار': false, 'الطلبات': false,
        'المالية': false, 'التقارير': false, 'الموظفون': false, 'الإعدادات': false,
      };
  }
}

// ─── Mock Data ──────────────────────────────────────────────────────────────

const FactoryProfileModel _mockProfile = FactoryProfileModel(
  id: 'FAC-001',
  name: 'مصنع نسيجي للصناعات النسيجية',
  logoUrl: 'https://images.unsplash.com/photo-1664575198263-269a022d6e14?w=200',
  coverUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
  description:
      'مصنع متخصص في صناعة الغزل والنسيج والخيوط القطنية عالية الجودة. نمتلك أحدث المعدات ونلتزم بأعلى معايير الجودة في منتجاتنا.',
  establishedYear: '١٩٩٥',
  industry: 'الغزل والنسيج',
  factoryType: 'مصنع متكامل',
  productionCapacity: '٥٠٠ طن / شهرياً',
  employeeCount: 320,
  minOrderQuantity: 500,
  marketsServed: ['مصر', 'السعودية', 'الإمارات', 'الكويت', 'أوروبا'],
  phone: '+20 10 1234 5678',
  email: 'info@naseeji.com',
  website: 'www.naseeji.com',
  country: 'مصر',
  city: 'المحلة الكبرى',
  address: 'المنطقة الصناعية، شارع المصانع، المحلة الكبرى، الغربية',
  commercialRegNo: '٤٨٧٢٦١٩',
  taxCardNo: '٣٢١-٩٨٧-٦٥٤',
  isVerified: true,
  subscriptionPlan: 'pro',
  subscriptionExpiry: '٢٠٢٧/٠١/٠١',
  isAccountActive: true,
);

final List<EmployeeModel> _mockEmployees = [
  EmployeeModel(
    id: 'EMP-001',
    name: 'أحمد محمود السيد',
    jobTitle: 'مالك المصنع',
    phone: '+20 10 1234 5678',
    email: 'ahmed@naseeji.com',
    photoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
    role: EmployeeRole.owner,
    status: EmployeeStatus.active,
    lastLogin: 'منذ ٥ دقائق',
    permissions: _permissionsForRole(EmployeeRole.owner),
  ),
  EmployeeModel(
    id: 'EMP-002',
    name: 'سارة عبدالله خالد',
    jobTitle: 'مدير المشتريات',
    phone: '+20 11 9876 5432',
    email: 'sara@naseeji.com',
    photoUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
    role: EmployeeRole.purchasingManager,
    status: EmployeeStatus.active,
    lastLogin: 'منذ ساعتين',
    permissions: _permissionsForRole(EmployeeRole.purchasingManager),
  ),
  EmployeeModel(
    id: 'EMP-003',
    name: 'محمد عبدالرحمن',
    jobTitle: 'مدير المخزن',
    phone: '+20 12 5555 1234',
    email: 'mohamed@naseeji.com',
    photoUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100',
    role: EmployeeRole.warehouseManager,
    status: EmployeeStatus.active,
    lastLogin: 'منذ يوم',
    permissions: _permissionsForRole(EmployeeRole.warehouseManager),
  ),
  EmployeeModel(
    id: 'EMP-004',
    name: 'فاطمة حسن علي',
    jobTitle: 'مفتشة الجودة',
    phone: '+20 10 4444 8888',
    email: 'fatma@naseeji.com',
    photoUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
    role: EmployeeRole.qualityInspector,
    status: EmployeeStatus.active,
    lastLogin: 'منذ ٣ أيام',
    permissions: _permissionsForRole(EmployeeRole.qualityInspector),
  ),
  EmployeeModel(
    id: 'EMP-005',
    name: 'خالد إبراهيم منصور',
    jobTitle: 'محاسب',
    phone: '+20 11 3333 7777',
    email: 'khaled@naseeji.com',
    photoUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100',
    role: EmployeeRole.accountant,
    status: EmployeeStatus.inactive,
    lastLogin: 'منذ أسبوع',
    permissions: _permissionsForRole(EmployeeRole.accountant),
  ),
];

Map<String, Map<String, bool>> _defaultNotifications() {
  const categories = [
    'عروض الأسعار', 'الطلبات', 'الشحن', 'الرسائل',
    'الفواتير', 'التقييمات', 'الاشتراك', 'النظام',
  ];
  final result = <String, Map<String, bool>>{};
  for (final c in categories) {
    result[c] = {'push': true, 'email': true, 'whatsapp': false};
  }
  return result;
}

// ─── Account State ─────────────────────────────────────────────────────────

class AccountState {
  final FactoryProfileModel profile;
  final List<EmployeeModel> employees;

  const AccountState({required this.profile, required this.employees});

  AccountState copyWith({FactoryProfileModel? profile, List<EmployeeModel>? employees}) {
    return AccountState(
      profile: profile ?? this.profile,
      employees: employees ?? this.employees,
    );
  }
}

@riverpod
class AccountNotifier extends _$AccountNotifier {
  @override
  AccountState build() {
    return AccountState(profile: _mockProfile, employees: _mockEmployees);
  }

  void updateProfile(FactoryProfileModel updated) {
    state = state.copyWith(profile: updated);
  }

  void addEmployee(EmployeeModel emp) {
    state = state.copyWith(employees: [emp, ...state.employees]);
  }

  void updateEmployee(EmployeeModel updated) {
    final list = state.employees.map((e) => e.id == updated.id ? updated : e).toList();
    state = state.copyWith(employees: list);
  }

  void removeEmployee(String id) {
    state = state.copyWith(employees: state.employees.where((e) => e.id != id).toList());
  }

  void toggleEmployeeStatus(String id) {
    final list = state.employees.map((e) {
      if (e.id == id) {
        final newStatus = e.status == EmployeeStatus.active ? EmployeeStatus.inactive : EmployeeStatus.active;
        return e.copyWith(status: newStatus);
      }
      return e;
    }).toList();
    state = state.copyWith(employees: list);
  }

  List<EmployeeModel> searchEmployees(String query) {
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

// ─── Settings State ────────────────────────────────────────────────────────

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  AppSettingsModel build() {
    return AppSettingsModel(
      themeMode: AppThemeMode.system,
      currency: 'جنيه مصري (EGP)',
      timeZone: 'القاهرة (UTC+3)',
      dateFormat: 'YYYY/MM/DD',
      notificationSettings: _defaultNotifications(),
    );
  }

  void setThemeMode(AppThemeMode mode) {
    state = state.copyWith(themeMode: mode);
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
