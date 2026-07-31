import '../../domain/entities/user_entity.dart';

class RegisterState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final UserEntity? registeredUser;
  final Map<String, String> validationErrors;

  const RegisterState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.registeredUser,
    this.validationErrors = const {},
  });

  RegisterState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    UserEntity? registeredUser,
    Map<String, String>? validationErrors,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      registeredUser: registeredUser ?? this.registeredUser,
      validationErrors: validationErrors ?? this.validationErrors,
    );
  }
}
