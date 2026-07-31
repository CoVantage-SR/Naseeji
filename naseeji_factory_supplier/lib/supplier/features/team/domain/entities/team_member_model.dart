import 'package:flutter/material.dart';
import 'team_permissions.dart';

enum MemberStatus {
  active,
  pending,
  inactive,
  suspended;

  String get titleAr {
    switch (this) {
      case MemberStatus.active:
        return 'نشط';
      case MemberStatus.pending:
        return 'بانتظار الدعوة';
      case MemberStatus.inactive:
        return 'غير نشط';
      case MemberStatus.suspended:
        return 'معلق';
    }
  }

  Color get color {
    switch (this) {
      case MemberStatus.active:
        return const Color(0xFF16A34A);
      case MemberStatus.pending:
        return const Color(0xFFEA580C);
      case MemberStatus.inactive:
        return const Color(0xFF6B7280);
      case MemberStatus.suspended:
        return const Color(0xFFEF4444);
    }
  }

  Color get bgColor {
    switch (this) {
      case MemberStatus.active:
        return const Color(0xFFDCFCE7);
      case MemberStatus.pending:
        return const Color(0xFFFFF7ED);
      case MemberStatus.inactive:
        return const Color(0xFFF3F4F6);
      case MemberStatus.suspended:
        return const Color(0xFFFEF2F2);
    }
  }
}

enum MemberRoleCategory {
  owner,
  manager,
  supervisor,
  employee;

  String get titleAr {
    switch (this) {
      case MemberRoleCategory.owner:
        return 'مالك المنشأة';
      case MemberRoleCategory.manager:
        return 'مدير';
      case MemberRoleCategory.supervisor:
        return 'مشرف';
      case MemberRoleCategory.employee:
        return 'موظف';
    }
  }
}

class TeamMemberModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final String roleTitle;
  final MemberRoleCategory roleCategory;
  final String department;
  final MemberStatus status;
  final String lastLoginText;
  final DateTime joinedDate;
  final IconData roleIcon;
  final Color roleIconColor;
  final Color roleBgColor;
  final TeamPermissions permissions;
  final bool isOwner;

  const TeamMemberModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.roleTitle,
    required this.roleCategory,
    required this.department,
    required this.status,
    required this.lastLoginText,
    required this.joinedDate,
    required this.roleIcon,
    required this.roleIconColor,
    required this.roleBgColor,
    required this.permissions,
    this.isOwner = false,
  });

  TeamMemberModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    String? roleTitle,
    MemberRoleCategory? roleCategory,
    String? department,
    MemberStatus? status,
    String? lastLoginText,
    DateTime? joinedDate,
    IconData? roleIcon,
    Color? roleIconColor,
    Color? roleBgColor,
    TeamPermissions? permissions,
  }) {
    return TeamMemberModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      roleTitle: roleTitle ?? this.roleTitle,
      roleCategory: roleCategory ?? this.roleCategory,
      department: department ?? this.department,
      status: status ?? this.status,
      lastLoginText: lastLoginText ?? this.lastLoginText,
      joinedDate: joinedDate ?? this.joinedDate,
      roleIcon: roleIcon ?? this.roleIcon,
      roleIconColor: roleIconColor ?? this.roleIconColor,
      roleBgColor: roleBgColor ?? this.roleBgColor,
      permissions: permissions ?? this.permissions,
      isOwner: isOwner,
    );
  }
}



