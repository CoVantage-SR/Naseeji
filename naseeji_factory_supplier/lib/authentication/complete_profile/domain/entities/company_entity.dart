import 'package:equatable/equatable.dart';
import '../../../../shared/enums/user_role.dart';
import 'address_entity.dart';

class CompanyEntity extends Equatable {
  final String id;
  final String name;
  final UserRole role;
  final String category;
  final AddressEntity address;
  final String commercialRegister;
  final String? taxNumber;
  final String? website;
  final String? logoUrl;

  const CompanyEntity({
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

  @override
  List<Object?> get props => [
        id,
        name,
        role,
        category,
        address,
        commercialRegister,
        taxNumber,
        website,
        logoUrl,
      ];
}
