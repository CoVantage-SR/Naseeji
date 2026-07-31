class OtpState {
  final bool isLoading;
  final bool isVerified;
  final String? errorMessage;
  final String code;
  final int resendCountdown;
  final bool canResend;

  const OtpState({
    this.isLoading = false,
    this.isVerified = false,
    this.errorMessage,
    this.code = '',
    this.resendCountdown = 60,
    this.canResend = false,
  });

  OtpState copyWith({
    bool? isLoading,
    bool? isVerified,
    String? errorMessage,
    String? code,
    int? resendCountdown,
    bool? canResend,
  }) {
    return OtpState(
      isLoading: isLoading ?? this.isLoading,
      isVerified: isVerified ?? this.isVerified,
      errorMessage: errorMessage,
      code: code ?? this.code,
      resendCountdown: resendCountdown ?? this.resendCountdown,
      canResend: canResend ?? this.canResend,
    );
  }
}
