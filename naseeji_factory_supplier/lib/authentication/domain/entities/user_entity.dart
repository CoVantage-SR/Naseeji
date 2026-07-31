import '../../../shared/enums/account_mode.dart';
import '../../../shared/enums/user_role.dart';

class UserEntity {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final AccountMode mode;
  final String? avatarUrl;
  final bool isVerified;
  final bool hasCompletedRegistration;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.mode = AccountMode.real,
    this.avatarUrl,
    this.isVerified = false,
    this.hasCompletedRegistration = false,
  });

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    AccountMode? mode,
    String? avatarUrl,
    bool? isVerified,
    bool? hasCompletedRegistration,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      mode: mode ?? this.mode,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isVerified: isVerified ?? this.isVerified,
      hasCompletedRegistration: hasCompletedRegistration ?? this.hasCompletedRegistration,
    );
  }

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      role: json['role'] == 'supplier' ? UserRole.supplier : UserRole.factory,
      mode: json['mode'] == 'demo' ? AccountMode.demo : AccountMode.real,
      avatarUrl: json['avatarUrl'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      hasCompletedRegistration: json['hasCompletedRegistration'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.name,
      'mode': mode.name,
      'avatarUrl': avatarUrl,
      'isVerified': isVerified,
      'hasCompletedRegistration': hasCompletedRegistration,
    };
  }
}
