enum SupplierType {
  factoryUnit('مصنع'),
  supplier('مورد خامات'),
  customizer('مقدم خدمات تخصيص');

  final String label;
  const SupplierType(this.label);
}

class SupplierRegistrationData {
  final SupplierType? supplierType;
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String companyName;
  final String commercialRegistry;
  final String taxNumber;
  final List<String> categories;
  final String? commercialRegistryFilePath;

  const SupplierRegistrationData({
    this.supplierType,
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.password = '',
    this.companyName = '',
    this.commercialRegistry = '',
    this.taxNumber = '',
    this.categories = const [],
    this.commercialRegistryFilePath,
  });

  SupplierRegistrationData copyWith({
    SupplierType? supplierType,
    String? fullName,
    String? email,
    String? phone,
    String? password,
    String? companyName,
    String? commercialRegistry,
    String? taxNumber,
    List<String>? categories,
    String? commercialRegistryFilePath,
  }) {
    return SupplierRegistrationData(
      supplierType: supplierType ?? this.supplierType,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      companyName: companyName ?? this.companyName,
      commercialRegistry: commercialRegistry ?? this.commercialRegistry,
      taxNumber: taxNumber ?? this.taxNumber,
      categories: categories ?? this.categories,
      commercialRegistryFilePath: commercialRegistryFilePath ?? this.commercialRegistryFilePath,
    );
  }
}
