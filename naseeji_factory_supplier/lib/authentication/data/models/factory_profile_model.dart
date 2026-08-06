class FactoryProfileModel {
  final String id;
  final String companyName;
  final String factoryType;
  final String governorate;
  final String city;
  final String address;
  final String commercialRegistration;
  final String taxNumber;
  final String? logoUrl;
  final String verificationStatus;

  FactoryProfileModel({
    required this.id,
    required this.companyName,
    required this.factoryType,
    required this.governorate,
    required this.city,
    required this.address,
    required this.commercialRegistration,
    required this.taxNumber,
    this.logoUrl,
    required this.verificationStatus,
  });

  factory FactoryProfileModel.fromJson(Map<String, dynamic> json) {
    return FactoryProfileModel(
      id: json['id'] ?? json['_id'] ?? '',
      companyName: json['companyName'] ?? '',
      factoryType: json['factoryType'] ?? '',
      governorate: json['governorate'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      commercialRegistration: json['commercialRegistration'] ?? '',
      taxNumber: json['taxNumber'] ?? '',
      logoUrl: json['logoUrl'],
      verificationStatus: json['verificationStatus'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
      'factoryType': factoryType,
      'governorate': governorate,
      'city': city,
      'address': address,
      'commercialRegistration': commercialRegistration,
      'taxNumber': taxNumber,
      'logoUrl': logoUrl,
      'verificationStatus': verificationStatus,
    };
  }
}
