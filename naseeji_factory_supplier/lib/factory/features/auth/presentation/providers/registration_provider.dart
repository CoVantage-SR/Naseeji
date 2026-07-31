import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'registration_provider.freezed.dart';
part 'registration_provider.g.dart';

@freezed
class RegistrationFormState with _$RegistrationFormState {
  const factory RegistrationFormState({
    @Default('') String selectedFactoryType,
    @Default(<String>[]) List<String> selectedBusinessCategories,
    @Default('') String factoryName,
    @Default('') String ownerName,
    @Default('') String phone,
    @Default('') String email,
    @Default('') String governorate,
    @Default('') String city,
    @Default('') String employeesRange,
    @Default('') String description,
    @Default(false) bool isLoading,
    @Default('') String errorMessage,
  }) = _RegistrationFormState;
}

@riverpod
class Registration extends _$Registration {
  @override
  RegistrationFormState build() {
    return const RegistrationFormState();
  }

  void updateFactoryType(String type) {
    state = state.copyWith(selectedFactoryType: type);
  }

  void updateBusinessCategories(List<String> categories) {
    state = state.copyWith(selectedBusinessCategories: categories);
  }

  void updateBasicInfo({
    required String factoryName,
    required String ownerName,
    required String phone,
    required String email,
    required String governorate,
    required String city,
    required String employeesRange,
    required String description,
  }) {
    state = state.copyWith(
      factoryName: factoryName,
      ownerName: ownerName,
      phone: phone,
      email: email,
      governorate: governorate,
      city: city,
      employeesRange: employeesRange,
      description: description,
    );
  }

  Future<void> submitRegistration() async {
    state = state.copyWith(isLoading: true, errorMessage: '');
    await Future.delayed(const Duration(milliseconds: 1500)); // Mock network delay
    state = state.copyWith(isLoading: false);
  }
}

