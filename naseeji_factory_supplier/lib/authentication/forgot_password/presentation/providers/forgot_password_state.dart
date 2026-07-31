class ForgotPasswordState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final String? phoneOrEmail;

  const ForgotPasswordState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.phoneOrEmail,
  });

  ForgotPasswordState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    String? phoneOrEmail,
  }) {
    return ForgotPasswordState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      phoneOrEmail: phoneOrEmail ?? this.phoneOrEmail,
    );
  }
}
