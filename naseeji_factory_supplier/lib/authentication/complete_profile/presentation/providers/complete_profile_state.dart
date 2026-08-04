import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../shared/enums/user_role.dart';

class CompleteProfileState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final Map<String, String> validationErrors;
  final UserRole selectedRole;
  final String companyName;
  final String? selectedCategory;
  final String? selectedGovernorate;
  final String? selectedCity;
  final String address;
  final String commercialRegister;
  final String? taxNumber;
  final String? website;
  final XFile? selectedLogo;
  final String? logoUrl;

  // New Verification & Identity fields
  final String verificationMethod; // 'company' | 'identity'
  final XFile? crDocumentFile;
  final XFile? taxDocumentFile;
  final XFile? idFrontFile;
  final XFile? idBackFile;
  final XFile? selfieFile;
  final String businessName;
  final String? businessType;
  final String businessAddress;
  final String? bankAccount;

  const CompleteProfileState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.validationErrors = const {},
    this.selectedRole = UserRole.factory,
    this.companyName = '',
    this.selectedCategory,
    this.selectedGovernorate,
    this.selectedCity,
    this.address = '',
    this.commercialRegister = '',
    this.taxNumber,
    this.website,
    this.selectedLogo,
    this.logoUrl,
    this.verificationMethod = 'company',
    this.crDocumentFile,
    this.taxDocumentFile,
    this.idFrontFile,
    this.idBackFile,
    this.selfieFile,
    this.businessName = '',
    this.businessType,
    this.businessAddress = '',
    this.bankAccount,
  });

  CompleteProfileState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    Map<String, String>? validationErrors,
    UserRole? selectedRole,
    String? companyName,
    String? selectedCategory,
    String? selectedGovernorate,
    String? selectedCity,
    String? address,
    String? commercialRegister,
    String? taxNumber,
    String? website,
    XFile? selectedLogo,
    bool clearLogo = false,
    String? logoUrl,
    String? verificationMethod,
    XFile? crDocumentFile,
    bool clearCrDocument = false,
    XFile? taxDocumentFile,
    bool clearTaxDocument = false,
    XFile? idFrontFile,
    bool clearIdFront = false,
    XFile? idBackFile,
    bool clearIdBack = false,
    XFile? selfieFile,
    bool clearSelfie = false,
    String? businessName,
    String? businessType,
    String? businessAddress,
    String? bankAccount,
  }) {
    return CompleteProfileState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      validationErrors: validationErrors ?? this.validationErrors,
      selectedRole: selectedRole ?? this.selectedRole,
      companyName: companyName ?? this.companyName,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedGovernorate: selectedGovernorate ?? this.selectedGovernorate,
      selectedCity: selectedCity ?? this.selectedCity,
      address: address ?? this.address,
      commercialRegister: commercialRegister ?? this.commercialRegister,
      taxNumber: taxNumber ?? this.taxNumber,
      website: website ?? this.website,
      selectedLogo: clearLogo ? null : (selectedLogo ?? this.selectedLogo),
      logoUrl: logoUrl ?? this.logoUrl,
      verificationMethod: verificationMethod ?? this.verificationMethod,
      crDocumentFile: clearCrDocument ? null : (crDocumentFile ?? this.crDocumentFile),
      taxDocumentFile: clearTaxDocument ? null : (taxDocumentFile ?? this.taxDocumentFile),
      idFrontFile: clearIdFront ? null : (idFrontFile ?? this.idFrontFile),
      idBackFile: clearIdBack ? null : (idBackFile ?? this.idBackFile),
      selfieFile: clearSelfie ? null : (selfieFile ?? this.selfieFile),
      businessName: businessName ?? this.businessName,
      businessType: businessType ?? this.businessType,
      businessAddress: businessAddress ?? this.businessAddress,
      bankAccount: bankAccount ?? this.bankAccount,
    );
  }

  /// Modular completion system as requested:
  /// Basic Information: 20%
  /// Phone Verified: 10%
  /// Logo: 5%
  /// Address: 10%
  /// Business Category: 10%
  /// Verification Documents: 25%
  /// Bank Information: 10%
  /// Website: 5%
  /// Profile Photo: 5%
  /// Total: 100%
  int get completionPercentage {
    int percentage = 0;

    // Basic Info (Company Name or Business Name): 20%
    if (companyName.trim().isNotEmpty || businessName.trim().isNotEmpty) {
      percentage += 20;
    }

    // Phone Verified (always 10% for authenticated users)
    percentage += 10;

    // Logo: 5%
    if (selectedLogo != null || (logoUrl != null && logoUrl!.isNotEmpty)) {
      percentage += 5;
    }

    // Address (Address or Business Address): 10%
    if (address.trim().isNotEmpty || businessAddress.trim().isNotEmpty) {
      percentage += 10;
    }

    // Business Category: 10%
    if ((selectedCategory != null && selectedCategory!.isNotEmpty) || (businessType != null && businessType!.isNotEmpty)) {
      percentage += 10;
    }

    // Verification Documents: 25%
    if (verificationMethod == 'company') {
      if (crDocumentFile != null && taxDocumentFile != null) {
        percentage += 25;
      } else if (crDocumentFile != null || taxDocumentFile != null || commercialRegister.trim().isNotEmpty) {
        percentage += 12;
      }
    } else {
      if (idFrontFile != null && idBackFile != null && selfieFile != null) {
        percentage += 25;
      } else if (idFrontFile != null || idBackFile != null || selfieFile != null) {
        percentage += 12;
      }
    }

    // Bank Information: 10%
    if (bankAccount != null && bankAccount!.trim().isNotEmpty) {
      percentage += 10;
    }

    // Website: 5%
    if (website != null && website!.trim().isNotEmpty) {
      percentage += 5;
    }

    // Profile Photo: 5%
    if (selectedLogo != null || (logoUrl != null && logoUrl!.isNotEmpty)) {
      percentage += 5;
    }

    return percentage > 100 ? 100 : percentage;
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSuccess,
        errorMessage,
        validationErrors,
        selectedRole,
        companyName,
        selectedCategory,
        selectedGovernorate,
        selectedCity,
        address,
        commercialRegister,
        taxNumber,
        website,
        selectedLogo,
        logoUrl,
        verificationMethod,
        crDocumentFile,
        taxDocumentFile,
        idFrontFile,
        idBackFile,
        selfieFile,
        businessName,
        businessType,
        businessAddress,
        bankAccount,
      ];
}
