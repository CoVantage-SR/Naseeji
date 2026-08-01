import '../../domain/entities/address_entity.dart';
import '../../domain/entities/company_entity.dart';
import '../models/address_model.dart';
import '../models/company_model.dart';

class CompanyMapper {
  static AddressEntity mapAddressToEntity(AddressModel model) {
    return AddressEntity(
      country: model.country,
      governorate: model.governorate,
      city: model.city,
      streetAddress: model.streetAddress,
    );
  }

  static AddressModel mapAddressToModel(AddressEntity entity) {
    return AddressModel(
      country: entity.country,
      governorate: entity.governorate,
      city: entity.city,
      streetAddress: entity.streetAddress,
    );
  }

  static CompanyEntity mapToEntity(CompanyModel model) {
    return CompanyEntity(
      id: model.id,
      name: model.name,
      role: model.role,
      category: model.category,
      address: mapAddressToEntity(model.address),
      commercialRegister: model.commercialRegister,
      taxNumber: model.taxNumber,
      website: model.website,
      logoUrl: model.logoUrl,
    );
  }

  static CompanyModel mapToModel(CompanyEntity entity) {
    return CompanyModel(
      id: entity.id,
      name: entity.name,
      role: entity.role,
      category: entity.category,
      address: mapAddressToModel(entity.address),
      commercialRegister: entity.commercialRegister,
      taxNumber: entity.taxNumber,
      website: entity.website,
      logoUrl: entity.logoUrl,
    );
  }
}
