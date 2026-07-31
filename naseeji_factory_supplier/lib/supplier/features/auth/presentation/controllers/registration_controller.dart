import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/supplier_registration_data.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/auth_usecases.dart';

part 'registration_controller.g.dart';

class RegistrationState {
  final SupplierRegistrationData data;
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const RegistrationState({
    required this.data,
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  RegistrationState copyWith({
    SupplierRegistrationData? data,
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return RegistrationState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

@riverpod
class RegistrationController extends _$RegistrationController {
  late final SendOtpUseCase _sendOtpUseCase;
  late final VerifyOtpUseCase _verifyOtpUseCase;
  late final RegisterSupplierUseCase _registerSupplierUseCase;

  @override
  RegistrationState build() {
    final repository = ref.watch(authRepositoryProvider);
    _sendOtpUseCase = SendOtpUseCase(repository);
    _verifyOtpUseCase = VerifyOtpUseCase(repository);
    _registerSupplierUseCase = RegisterSupplierUseCase(repository);

    return const RegistrationState(
      data: SupplierRegistrationData(),
    );
  }

  void updateSupplierType(SupplierType type) {
    state = state.copyWith(
      data: state.data.copyWith(supplierType: type),
    );
  }

  void updateBasicAccount({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String governorate,
    required String city,
  }) {
    state = state.copyWith(
      data: state.data.copyWith(
        fullName: name,
        email: email,
        phone: phone,
        password: password,
        governorate: governorate,
        city: city,
      ),
    );
  }

  void updateCompanyDetails({
    required String companyName,
    required String commercialRegistry,
    required String taxNumber,
    required List<String> categories,
  }) {
    state = state.copyWith(
      data: state.data.copyWith(
        companyName: companyName,
        commercialRegistry: commercialRegistry,
        taxNumber: taxNumber,
        categories: categories,
      ),
    );
  }

  void updateBusinessDetails({
    required List<String> specializations,
    required String factoryType,
    required String employeeCount,
    required String productionCapacity,
    required String productTypes,
    required String companyBio,
    required String establishedYear,
    required String minOrderValue,
    required String supplyCountries,
    required String website,
  }) {
    state = state.copyWith(
      data: state.data.copyWith(
        categories: specializations,
        factoryType: factoryType,
        employeeCount: employeeCount,
        productionCapacity: productionCapacity,
        productTypes: productTypes,
        companyBio: companyBio,
        establishedYear: establishedYear,
        minOrderValue: minOrderValue,
        supplyCountries: supplyCountries,
        website: website,
      ),
    );
  }

  void updateDocumentPath(String path) {
    state = state.copyWith(
      data: state.data.copyWith(commercialRegistryFilePath: path),
    );
  }

  Future<bool> sendOtp() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _sendOtpUseCase.execute(state.data.phone);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> verifyOtp(String code) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _verifyOtpUseCase.execute(state.data.phone, code);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> submitSupplierRegistration() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _registerSupplierUseCase.execute(state.data);
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  void resetSuccess() {
    state = state.copyWith(isSuccess: false);
  }
}

