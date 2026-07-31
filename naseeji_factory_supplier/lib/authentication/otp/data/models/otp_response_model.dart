class OtpResponseModel {
  final bool success;
  final String message;

  const OtpResponseModel({
    required this.success,
    required this.message,
  });

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpResponseModel(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String? ?? 'تم التحقق من الكود بنجاح',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}
