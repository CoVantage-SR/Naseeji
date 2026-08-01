import '../../presentation/validators/company_validator.dart';

class ValidateProfileUseCase {
  const ValidateProfileUseCase();

  Map<String, String> execute({
    required String name,
    required String category,
    required String governorate,
    required String city,
    required String address,
    required String commercialRegister,
    String? taxNumber,
    String? website,
  }) {
    final errors = <String, String>{};

    final nameErr = CompanyValidator.validateName(name);
    if (nameErr != null) errors['name'] = nameErr;

    final categoryErr = CompanyValidator.validateCategory(category);
    if (categoryErr != null) errors['category'] = categoryErr;

    final governorateErr = CompanyValidator.validateGovernorate(governorate);
    if (governorateErr != null) errors['governorate'] = governorateErr;

    final cityErr = CompanyValidator.validateCity(city);
    if (cityErr != null) errors['city'] = cityErr;

    final addressErr = CompanyValidator.validateAddress(address);
    if (addressErr != null) errors['address'] = addressErr;

    final crErr = CompanyValidator.validateCommercialRegister(commercialRegister);
    if (crErr != null) errors['commercialRegister'] = crErr;

    final taxErr = CompanyValidator.validateTaxNumber(taxNumber);
    if (taxErr != null) errors['taxNumber'] = taxErr;

    final webErr = CompanyValidator.validateWebsite(website);
    if (webErr != null) errors['website'] = webErr;

    return errors;
  }
}
