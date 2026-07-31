enum UserRole {
  factory,
  supplier;

  String get labelAr {
    switch (this) {
      case UserRole.factory:
        return 'مصنع';
      case UserRole.supplier:
        return 'مورد';
    }
  }
}
