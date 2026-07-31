class ForgotPasswordRequestModel {
  final String phoneOrEmail;

  const ForgotPasswordRequestModel({
    required this.phoneOrEmail,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone_or_email': phoneOrEmail,
    };
  }

  factory ForgotPasswordRequestModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordRequestModel(
      phoneOrEmail: json['phone_or_email'] as String? ?? '',
    );
  }
}
