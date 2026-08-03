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
    );
  }

  int get completionPercentage {
    int percentage = 0;
    if (companyName.trim().isNotEmpty) percentage += 20;
    if (selectedCategory != null && selectedCategory!.isNotEmpty) percentage += 20;
    if (selectedGovernorate != null && selectedGovernorate!.isNotEmpty) percentage += 15;
    if (selectedCity != null && selectedCity!.isNotEmpty) percentage += 15;
    if (address.trim().isNotEmpty) percentage += 10;
    if (selectedLogo != null || (logoUrl != null && logoUrl!.isNotEmpty)) percentage += 10;
    if (commercialRegister.trim().isNotEmpty) percentage += 5;
    if (taxNumber != null && taxNumber!.trim().isNotEmpty) percentage += 5;
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
      ];
}
