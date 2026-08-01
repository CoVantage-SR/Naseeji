import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../shared/enums/user_role.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/entities/company_entity.dart';
import '../../domain/usecases/complete_profile_usecase.dart';
import '../../domain/usecases/upload_logo_usecase.dart';
import '../../domain/usecases/validate_profile_usecase.dart';
import '../providers/complete_profile_state.dart';

class CompleteProfileController extends StateNotifier<CompleteProfileState> {
  final CompleteProfileUseCase completeProfileUseCase;
  final UploadLogoUseCase uploadLogoUseCase;
  final ValidateProfileUseCase validateProfileUseCase;
  final ImagePicker _picker = ImagePicker();

  CompleteProfileController({
    required this.completeProfileUseCase,
    required this.uploadLogoUseCase,
    required this.validateProfileUseCase,
    UserRole initialRole = UserRole.factory,
  }) : super(CompleteProfileState(selectedRole: initialRole));

  void setRole(UserRole role) {
    if (state.selectedRole != role) {
      state = state.copyWith(
        selectedRole: role,
        selectedCategory: null, // Reset category when role changes
      );
    }
  }

  void setCompanyName(String name) {
    final errors = Map<String, String>.from(state.validationErrors);
    errors.remove('name');
    state = state.copyWith(companyName: name, validationErrors: errors);
  }

  void setCategory(String category) {
    final errors = Map<String, String>.from(state.validationErrors);
    errors.remove('category');
    state = state.copyWith(selectedCategory: category, validationErrors: errors);
  }

  void setGovernorate(String governorate) {
    final errors = Map<String, String>.from(state.validationErrors);
    errors.remove('governorate');
    errors.remove('city');
    state = state.copyWith(
      selectedGovernorate: governorate,
      selectedCity: null, // Reset city when governorate changes
      validationErrors: errors,
    );
  }

  void setCity(String city) {
    final errors = Map<String, String>.from(state.validationErrors);
    errors.remove('city');
    state = state.copyWith(selectedCity: city, validationErrors: errors);
  }

  void setAddress(String address) {
    final errors = Map<String, String>.from(state.validationErrors);
    errors.remove('address');
    state = state.copyWith(address: address, validationErrors: errors);
  }

  void setCommercialRegister(String cr) {
    final errors = Map<String, String>.from(state.validationErrors);
    errors.remove('commercialRegister');
    state = state.copyWith(commercialRegister: cr, validationErrors: errors);
  }

  void setTaxNumber(String? tax) {
    final errors = Map<String, String>.from(state.validationErrors);
    errors.remove('taxNumber');
    state = state.copyWith(taxNumber: tax, validationErrors: errors);
  }

  void setWebsite(String? website) {
    final errors = Map<String, String>.from(state.validationErrors);
    errors.remove('website');
    state = state.copyWith(website: website, validationErrors: errors);
  }

  Future<void> pickLogo(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        state = state.copyWith(selectedLogo: pickedFile);
      }
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'فشل في اختيار الصورة: ${e.toString()}',
      );
    }
  }

  void deleteLogo() {
    state = state.copyWith(clearLogo: true, logoUrl: null);
  }

  Future<bool> submitProfile() async {
    final errors = validateProfileUseCase.execute(
      name: state.companyName,
      category: state.selectedCategory ?? '',
      governorate: state.selectedGovernorate ?? '',
      city: state.selectedCity ?? '',
      address: state.address,
      commercialRegister: state.commercialRegister,
      taxNumber: state.taxNumber,
      website: state.website,
    );

    if (errors.isNotEmpty) {
      state = state.copyWith(
        validationErrors: errors,
        errorMessage: 'يرجى مراجعة البيانات المدخلة وتصحيح الأخطاء',
      );
      return false;
    }

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      validationErrors: const {},
    );

    try {
      String? uploadedUrl = state.logoUrl;
      if (state.selectedLogo != null) {
        uploadedUrl = await uploadLogoUseCase.execute(
          File(state.selectedLogo!.path),
        );
      }

      final company = CompanyEntity(
        id: '',
        name: state.companyName,
        role: state.selectedRole,
        category: state.selectedCategory!,
        address: AddressEntity(
          governorate: state.selectedGovernorate!,
          city: state.selectedCity!,
          streetAddress: state.address,
        ),
        commercialRegister: state.commercialRegister,
        taxNumber: state.taxNumber,
        website: state.website,
        logoUrl: uploadedUrl,
      );

      await completeProfileUseCase.execute(company);

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        logoUrl: uploadedUrl,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }
}
