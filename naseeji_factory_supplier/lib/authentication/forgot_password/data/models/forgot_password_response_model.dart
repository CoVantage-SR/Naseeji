class ForgotPasswordResponseModel {
  final bool success;
  final String message;

  const ForgotPasswordResponseModel({
    required this.success,
    required this.message,
  });

  factory ForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponseModel(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String? ?? 'تم إرسال كود الإعادة بنجاح',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}
