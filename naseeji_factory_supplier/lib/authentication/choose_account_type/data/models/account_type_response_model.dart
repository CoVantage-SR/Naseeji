class AccountTypeResponseModel {
  final bool success;
  final String message;

  const AccountTypeResponseModel({
    required this.success,
    required this.message,
  });

  factory AccountTypeResponseModel.fromJson(Map<String, dynamic> json) {
    return AccountTypeResponseModel(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String? ?? 'تم حفظ نوع الحساب بنجاح',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}
