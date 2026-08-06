enum UserRole { factory, supplier, admin, support, auditor }
enum UserStatus { active, pending, deactivated, deleted, suspended }

class UserModel {
  final String id;
  final String phone;
  final String email;
  final UserRole role;
  final UserStatus status;
  final bool isEmailVerified;
  final bool isPhoneVerified;

  UserModel({
    required this.id,
    required this.phone,
    required this.email,
    required this.role,
    required this.status,
    required this.isEmailVerified,
    required this.isPhoneVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['_id'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      role: _parseRole(json['role'] ?? 'factory'),
      status: _parseStatus(json['status'] ?? 'pending'),
      isEmailVerified: json['isEmailVerified'] ?? false,
      isPhoneVerified: json['isPhoneVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'email': email,
      'role': role.name,
      'status': status.name,
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
    };
  }

  static UserRole _parseRole(String roleStr) {
    switch (roleStr.toLowerCase()) {
      case 'supplier': return UserRole.supplier;
      case 'admin': return UserRole.admin;
      case 'support': return UserRole.support;
      case 'auditor': return UserRole.auditor;
      default: return UserRole.factory;
    }
  }

  static UserStatus _parseStatus(String statusStr) {
    switch (statusStr.toLowerCase()) {
      case 'active': return UserStatus.active;
      case 'deactivated': return UserStatus.deactivated;
      case 'deleted': return UserStatus.deleted;
      case 'suspended': return UserStatus.suspended;
      default: return UserStatus.pending;
    }
  }
}
