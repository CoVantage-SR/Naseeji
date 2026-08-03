import '../../../shared/enums/user_role.dart';

enum AccountType {
  factory,
  supplier;

  String get labelAr {
    switch (this) {
      case AccountType.factory:
        return 'مصنع';
      case AccountType.supplier:
        return 'مورد';
    }
  }

  String get descriptionAr {
    switch (this) {
      case AccountType.factory:
        return 'تصفح وطلب خامات النسيج وإدارة المشتروات';
      case AccountType.supplier:
        return 'عرض الأقمشة والخيوط واستقبال طلبات التسعير';
    }
  }

  UserRole toUserRole() {
    switch (this) {
      case AccountType.factory:
        return UserRole.factory;
      case AccountType.supplier:
        return UserRole.supplier;
    }
  }

  static AccountType fromUserRole(UserRole role) {
    switch (role) {
      case UserRole.factory:
        return AccountType.factory;
      case UserRole.supplier:
        return AccountType.supplier;
    }
  }
}
