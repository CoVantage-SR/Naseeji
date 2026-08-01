import '../../../../shared/enums/user_role.dart';
import 'address_model.dart';

class CompanyModel {
  final String id;
  final String name;
  final UserRole role;
  final String category;
  final AddressModel address;
  final String commercialRegister;
  final String? taxNumber;
  final String? website;
  final String? logoUrl;

  const CompanyModel({
    required this.id,
    required this.name,
    required this.role,
    required this.category,
    required this.address,
    required this.commercialRegister,
    this.taxNumber,
    this.website,
    this.logoUrl,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'role': role.name,
        'category': category,
        'address': address.toJson(),
        'commercialRegister': commercialRegister,
        'taxNumber': taxNumber,
        'website': website,
        'logoUrl': logoUrl,
      };

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      role: json['role'] == 'supplier' ? UserRole.supplier : UserRole.factory,
      category: json['category'] as String? ?? '',
      address: AddressModel.fromJson(
        json['address'] as Map<String, dynamic>? ?? {},
      ),
      commercialRegister: json['commercialRegister'] as String? ?? '',
      taxNumber: json['taxNumber'] as String?,
      website: json['website'] as String?,
      logoUrl: json['logoUrl'] as String?,
    );
  }
}
