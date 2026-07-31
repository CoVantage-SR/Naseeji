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

  // New Fields for Step 4 & Step 5
  final String governorate;
  final String city;
  final String factoryType;
  final String employeeCount;
  final String productionCapacity;
  final String productTypes;
  final String companyBio;
  final String establishedYear;
  final String minOrderValue;
  final String supplyCountries;
  final String website;

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
    this.governorate = '',
    this.city = '',
    this.factoryType = '',
    this.employeeCount = '',
    this.productionCapacity = '',
    this.productTypes = '',
    this.companyBio = '',
    this.establishedYear = '',
    this.minOrderValue = '',
    this.supplyCountries = '',
    this.website = '',
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
    String? governorate,
    String? city,
    String? factoryType,
    String? employeeCount,
    String? productionCapacity,
    String? productTypes,
    String? companyBio,
    String? establishedYear,
    String? minOrderValue,
    String? supplyCountries,
    String? website,
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
      governorate: governorate ?? this.governorate,
      city: city ?? this.city,
      factoryType: factoryType ?? this.factoryType,
      employeeCount: employeeCount ?? this.employeeCount,
      productionCapacity: productionCapacity ?? this.productionCapacity,
      productTypes: productTypes ?? this.productTypes,
      companyBio: companyBio ?? this.companyBio,
      establishedYear: establishedYear ?? this.establishedYear,
      minOrderValue: minOrderValue ?? this.minOrderValue,
      supplyCountries: supplyCountries ?? this.supplyCountries,
      website: website ?? this.website,
    );
  }
}

