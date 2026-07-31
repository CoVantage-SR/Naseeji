import '../../../shared/enums/user_role.dart';

class RegisterRequestModel {
  final String name;
  final String email;
  final String phone;
  final String password;
  final UserRole role;

  const RegisterRequestModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    this.role = UserRole.factory,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'role': role.name,
    };
  }

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    return RegisterRequestModel(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      password: json['password'] as String? ?? '',
      role: json['role'] == 'supplier' ? UserRole.supplier : UserRole.factory,
    );
  }
}
