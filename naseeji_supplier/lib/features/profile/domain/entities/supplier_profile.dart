class CompanyCertificate {
  final String name;
  final String date;
  final bool verified;

  const CompanyCertificate({
    required this.name,
    required this.date,
    required this.verified,
  });
}

class SupplierProfile {
  final String companyName;
  final String managerName;
  final String email;
  final String phone;
  final String city;
  final double rating;
  final double completionRate;
  final String logoUrl;
  final String bannerUrl;
  final int productsCount;
  final int ordersCount;
  final List<CompanyCertificate> certificates;
  final bool isVip;

  // New B2B corporate profile fields
  final String tradeName;
  final String businessType;
  final String description;
  final String establishedYear;
  final int employeesCount;
  final String monthlyCapacity;
  final String warehouseCapacity;
  final List<String> categories;
  final String contactPerson;
  final String whatsappNumber;
  final String website;
  final String businessHours;
  final String country;
  final String fullAddress;
  final String postalCode;
  final String commercialRegister;
  final String taxRegistration;
  final String businessLicense;
  final int yearsOfExperience;
  final int moq;
  final String averageProductionTime;
  final String facebookUrl;
  final String instagramUrl;
  final String linkedinUrl;
  final String xUrl;
  final String youtubeUrl;

  const SupplierProfile({
    required this.companyName,
    required this.managerName,
    required this.email,
    required this.phone,
    required this.city,
    required this.rating,
    required this.completionRate,
    required this.logoUrl,
    required this.bannerUrl,
    required this.productsCount,
    required this.ordersCount,
    required this.certificates,
    this.isVip = false,
    this.tradeName = 'شركة نسيج الشرق التجارية',
    this.businessType = 'مصنع / منتج',
    this.description = 'نعمل بأحدث التقنيات الألمانية في غزل ونسيج القطنيات الفاخرة والمخلوطة، ونوفر لشركائنا خامات معتمدة ومطابقة لأعلى مقاييس الجودة العالمية.',
    this.establishedYear = '2016',
    this.employeesCount = 120,
    this.monthlyCapacity = '50,000 متر',
    this.warehouseCapacity = '10,000 م²',
    this.categories = const ['Cotton Supplier', 'Fabric Supplier', 'Yarn Supplier'],
    this.contactPerson = 'أحمد محمد',
    this.whatsappNumber = '+20 1012345678',
    this.website = 'https://naseejisharq.com',
    this.businessHours = '8:00 AM - 5:00 PM',
    this.country = 'مصر',
    this.fullAddress = 'المحلة الكبرى، المنطقة الصناعية، بلوك 12',
    this.postalCode = '31951',
    this.commercialRegister = '1010895641',
    this.taxRegistration = '3000548123',
    this.businessLicense = 'LIC-908231',
    this.yearsOfExperience = 10,
    this.moq = 500,
    this.averageProductionTime = '15 يوم',
    this.facebookUrl = 'https://facebook.com/naseejisharq',
    this.instagramUrl = 'https://instagram.com/naseejisharq',
    this.linkedinUrl = 'https://linkedin.com/company/naseejisharq',
    this.xUrl = 'https://x.com/naseejisharq',
    this.youtubeUrl = 'https://youtube.com/naseejisharq',
  });

  SupplierProfile copyWith({
    String? companyName,
    String? managerName,
    String? email,
    String? phone,
    String? city,
    double? rating,
    double? completionRate,
    String? logoUrl,
    String? bannerUrl,
    int? productsCount,
    int? ordersCount,
    List<CompanyCertificate>? certificates,
    bool? isVip,
    String? tradeName,
    String? businessType,
    String? description,
    String? establishedYear,
    int? employeesCount,
    String? monthlyCapacity,
    String? warehouseCapacity,
    List<String>? categories,
    String? contactPerson,
    String? whatsappNumber,
    String? website,
    String? businessHours,
    String? country,
    String? fullAddress,
    String? postalCode,
    String? commercialRegister,
    String? taxRegistration,
    String? businessLicense,
    int? yearsOfExperience,
    int? moq,
    String? averageProductionTime,
    String? facebookUrl,
    String? instagramUrl,
    String? linkedinUrl,
    String? xUrl,
    String? youtubeUrl,
  }) {
    return SupplierProfile(
      companyName: companyName ?? this.companyName,
      managerName: managerName ?? this.managerName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      rating: rating ?? this.rating,
      completionRate: completionRate ?? this.completionRate,
      logoUrl: logoUrl ?? this.logoUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      productsCount: productsCount ?? this.productsCount,
      ordersCount: ordersCount ?? this.ordersCount,
      certificates: certificates ?? this.certificates,
      isVip: isVip ?? this.isVip,
      tradeName: tradeName ?? this.tradeName,
      businessType: businessType ?? this.businessType,
      description: description ?? this.description,
      establishedYear: establishedYear ?? this.establishedYear,
      employeesCount: employeesCount ?? this.employeesCount,
      monthlyCapacity: monthlyCapacity ?? this.monthlyCapacity,
      warehouseCapacity: warehouseCapacity ?? this.warehouseCapacity,
      categories: categories ?? this.categories,
      contactPerson: contactPerson ?? this.contactPerson,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      website: website ?? this.website,
      businessHours: businessHours ?? this.businessHours,
      country: country ?? this.country,
      fullAddress: fullAddress ?? this.fullAddress,
      postalCode: postalCode ?? this.postalCode,
      commercialRegister: commercialRegister ?? this.commercialRegister,
      taxRegistration: taxRegistration ?? this.taxRegistration,
      businessLicense: businessLicense ?? this.businessLicense,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      moq: moq ?? this.moq,
      averageProductionTime: averageProductionTime ?? this.averageProductionTime,
      facebookUrl: facebookUrl ?? this.facebookUrl,
      instagramUrl: instagramUrl ?? this.instagramUrl,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      xUrl: xUrl ?? this.xUrl,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
    );
  }
}
