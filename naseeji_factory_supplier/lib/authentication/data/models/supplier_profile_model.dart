class SupplierProfileModel {
  final String id;
  final String companyName;
  final String supplierCategory;
  final String country;
  final String governorate;
  final String address;
  final String commercialRegistration;
  final String taxNumber;
  final String verificationStatus;
  final String subscriptionStatus;

  SupplierProfileModel({
    required this.id,
    required this.companyName,
    required this.supplierCategory,
    required this.country,
    required this.governorate,
    required this.address,
    required this.commercialRegistration,
    required this.taxNumber,
    required this.verificationStatus,
    required this.subscriptionStatus,
  });

  factory SupplierProfileModel.fromJson(Map<String, dynamic> json) {
    return SupplierProfileModel(
      id: json['id'] ?? json['_id'] ?? '',
      companyName: json['companyName'] ?? '',
      supplierCategory: json['supplierCategory'] ?? '',
      country: json['country'] ?? 'Egypt',
      governorate: json['governorate'] ?? '',
      address: json['address'] ?? '',
      commercialRegistration: json['commercialRegistration'] ?? '',
      taxNumber: json['taxNumber'] ?? '',
      verificationStatus: json['verificationStatus'] ?? 'pending',
      subscriptionStatus: json['subscriptionStatus'] ?? 'inactive',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
      'supplierCategory': supplierCategory,
      'country': country,
      'governorate': governorate,
      'address': address,
      'commercialRegistration': commercialRegistration,
      'taxNumber': taxNumber,
      'verificationStatus': verificationStatus,
      'subscriptionStatus': subscriptionStatus,
    };
  }
}
