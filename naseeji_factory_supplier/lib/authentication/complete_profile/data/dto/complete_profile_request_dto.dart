import '../models/address_model.dart';

class CompleteProfileRequestDto {
  final String companyName;
  final String role;
  final String category;
  final AddressModel address;
  final String commercialRegister;
  final String? taxNumber;
  final String? website;
  final String? logoUrl;

  const CompleteProfileRequestDto({
    required this.companyName,
    required this.role,
    required this.category,
    required this.address,
    required this.commercialRegister,
    this.taxNumber,
    this.website,
    this.logoUrl,
  });

  Map<String, dynamic> toJson() => {
        'company_name': companyName,
        'role': role,
        'category': category,
        'address': address.toJson(),
        'commercial_register': commercialRegister,
        'tax_number': taxNumber,
        'website': website,
        'logo_url': logoUrl,
      };
}
