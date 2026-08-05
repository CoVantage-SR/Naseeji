import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../shared/enums/user_role.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/entities/company_entity.dart';
import '../../domain/usecases/complete_profile_usecase.dart';
import '../../domain/usecases/upload_logo_usecase.dart';
import '../../domain/usecases/validate_profile_usecase.dart';
import '../../domain/usecases/verification_validator.dart';
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
        selectedCategory: null,
      );
    }
  }

  void setVerificationMethod(String method) {
    state = state.copyWith(verificationMethod: method);
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
      selectedCity: null,
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

  void setBusinessName(String name) {
    final errors = Map<String, String>.from(state.validationErrors);
    errors.remove('businessName');
    state = state.copyWith(businessName: name, validationErrors: errors);
  }

  void setBusinessType(String type) {
    final errors = Map<String, String>.from(state.validationErrors);
    errors.remove('businessType');
    state = state.copyWith(businessType: type, validationErrors: errors);
  }

  void setBusinessAddress(String address) {
    final errors = Map<String, String>.from(state.validationErrors);
    errors.remove('businessAddress');
    state = state.copyWith(businessAddress: address, validationErrors: errors);
  }

  void setBankAccount(String? bank) {
    state = state.copyWith(bankAccount: bank);
  }

  void setCrDocument(XFile? file) {
    final errors = Map<String, String>.from(state.validationErrors);
    errors.remove('crDocument');
    state = state.copyWith(crDocumentFile: file, validationErrors: errors);
  }

  void setTaxDocument(XFile? file) {
    final errors = Map<String, String>.from(state.validationErrors);
    errors.remove('taxDocument');
    state = state.copyWith(taxDocumentFile: file, validationErrors: errors);
  }

  void setIdFront(XFile? file) {
    final errors = Map<String, String>.from(state.validationErrors);
    errors.remove('idFront');
    state = state.copyWith(idFrontFile: file, validationErrors: errors);
  }

  void setIdBack(XFile? file) {
    final errors = Map<String, String>.from(state.validationErrors);
    errors.remove('idBack');
    state = state.copyWith(idBackFile: file, validationErrors: errors);
  }

  void setSelfie(XFile? file) {
    final errors = Map<String, String>.from(state.validationErrors);
    errors.remove('selfieWithId');
    state = state.copyWith(selfieFile: file, validationErrors: errors);
  }

  void deleteDocument(String key) {
    switch (key) {
      case 'crDocument':
        state = state.copyWith(clearCrDocument: true);
        break;
      case 'taxDocument':
        state = state.copyWith(clearTaxDocument: true);
        break;
      case 'idFront':
        state = state.copyWith(clearIdFront: true);
        break;
      case 'idBack':
        state = state.copyWith(clearIdBack: true);
        break;
      case 'selfieWithId':
        state = state.copyWith(clearSelfie: true);
        break;
    }
  }

  Future<bool> detectLocation() async {
    final errors = Map<String, String>.from(state.validationErrors);
    errors.remove('governorate');
    errors.remove('city');
    errors.remove('address');

    state = state.copyWith(
      isLoading: true,
      selectedGovernorate: 'القاهرة',
      selectedCity: 'مدينة نصر - المنطقة الصناعية',
      address: 'امتداد شارع الطيران - المربع الصناعي',
      validationErrors: errors,
    );
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(isLoading: false);
    return true;
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
    // 1. Validate basic required profile fields (Name, Category, Governorate, City, Address)
    final Map<String, String> errors = validateProfileUseCase.execute(
      name: state.companyName.isNotEmpty ? state.companyName : state.businessName,
      category: state.selectedCategory ?? state.businessType ?? '',
      governorate: state.selectedGovernorate ?? '',
      city: state.selectedCity ?? '',
      address: state.address.isNotEmpty ? state.address : state.businessAddress,
      commercialRegister: state.commercialRegister,
      taxNumber: state.taxNumber,
      website: state.website,
    );

    // 2. Optional document verification validation (checks size/format if uploaded)
    Map<String, String> docErrors = {};
    if (state.verificationMethod == 'company') {
      docErrors = VerificationValidator.validateCompanyVerification(
        commercialRegister: state.commercialRegister,
        taxNumber: state.taxNumber,
        crDocument: state.crDocumentFile != null ? File(state.crDocumentFile!.path) : null,
        taxDocument: state.taxDocumentFile != null ? File(state.taxDocumentFile!.path) : null,
      );
    } else {
      docErrors = VerificationValidator.validateIdentityVerification(
        idFront: state.idFrontFile != null ? File(state.idFrontFile!.path) : null,
        idBack: state.idBackFile != null ? File(state.idBackFile!.path) : null,
        selfieWithId: state.selfieFile != null ? File(state.selfieFile!.path) : null,
        businessName: state.businessName,
        businessType: state.businessType,
        businessAddress: state.businessAddress,
      );
    }

    errors.addAll(docErrors);

    // 3. Minimum 50% Profile Completion requirement to proceed
    const int minRequiredPercentage = 50;
    if (state.completionPercentage < minRequiredPercentage) {
      state = state.copyWith(
        validationErrors: errors,
        errorMessage: 'يجب الوصول إلى $minRequiredPercentage% على الأقل من إكمال الملف للمتابعة (نسبة إكتمال ملفك الحالية: ${state.completionPercentage}%)',
      );
      return false;
    }

    if (errors.isNotEmpty) {
      state = state.copyWith(
        validationErrors: errors,
        errorMessage: 'يرجى استكمال البيانات الأساسية بشكل صحيح للمتابعة',
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
        name: state.companyName.isNotEmpty ? state.companyName : state.businessName,
        role: state.selectedRole,
        category: state.selectedCategory ?? state.businessType ?? 'عام',
        address: AddressEntity(
          governorate: state.selectedGovernorate ?? 'القاهرة',
          city: state.selectedCity ?? 'القاهرة',
          streetAddress: state.address.isNotEmpty ? state.address : state.businessAddress,
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
