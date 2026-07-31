import '../../domain/entities/user_entity.dart';

class RegisterResponseModel {
  final bool success;
  final String message;
  final UserEntity? user;
  final String? token;

  const RegisterResponseModel({
    required this.success,
    required this.message,
    this.user,
    this.token,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String? ?? 'تم تسجيل الحساب بنجاح',
      user: json['user'] != null
          ? UserEntity.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'user': user?.toJson(),
      'token': token,
    };
  }
}
