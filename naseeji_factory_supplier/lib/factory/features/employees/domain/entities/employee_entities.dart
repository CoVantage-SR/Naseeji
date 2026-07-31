import 'package:flutter/foundation.dart';

/// Status of the employee
enum EmployeeStatus {
  active,
  onLeave,
  inactive,
  suspended,
}

extension EmployeeStatusX on EmployeeStatus {
  String get label {
    switch (this) {
      case EmployeeStatus.active:
        return 'نشط';
      case EmployeeStatus.onLeave:
        return 'في إجازة';
      case EmployeeStatus.inactive:
        return 'غير نشط';
      case EmployeeStatus.suspended:
        return 'موقوف';
    }
  }

  String get code {
    switch (this) {
      case EmployeeStatus.active:
        return 'active';
      case EmployeeStatus.onLeave:
        return 'onLeave';
      case EmployeeStatus.inactive:
        return 'inactive';
      case EmployeeStatus.suspended:
        return 'suspended';
    }
  }
}

/// Permission matrix per module
@immutable
class ModulePermission {
  final bool view;
  final bool create;
  final bool edit;
  final bool delete;
  final bool approve;
  final bool export;

  const ModulePermission({
    this.view = false,
    this.create = false,
    this.edit = false,
    this.delete = false,
    this.approve = false,
    this.export = false,
  });

  ModulePermission copyWith({
    bool? view,
    bool? create,
    bool? edit,
    bool? delete,
    bool? approve,
    bool? export,
  }) {
    return ModulePermission(
      view: view ?? this.view,
      create: create ?? this.create,
      edit: edit ?? this.edit,
      delete: delete ?? this.delete,
      approve: approve ?? this.approve,
      export: export ?? this.export,
    );
  }
}

/// Main Employee Entity
@immutable
class EmployeeEntity {
  final String id;
  final String name;
  final String jobTitle;
  final String department;
  final String role;
  final String phone;
  final String email;
  final String photoUrl;
  final EmployeeStatus status;
  final String joiningDate;
  final String employmentType; // 'دوام كامل', 'دوام جزئي', 'عقد', 'عن بُعد'
  final String lastLogin;
  final String lastActivity;
  final String? leaveReturnDate;
  final int permissionsCount;
  final Map<String, ModulePermission> permissions;
  final String managerName;
  final String? suspensionReason;
  final String nationalId;
  final double salary;

  const EmployeeEntity({
    required this.id,
    required this.name,
    required this.jobTitle,
    required this.department,
    required this.role,
    required this.phone,
    required this.email,
    required this.photoUrl,
    required this.status,
    required this.joiningDate,
    required this.employmentType,
    required this.lastLogin,
    required this.lastActivity,
    this.leaveReturnDate,
    required this.permissionsCount,
    required this.permissions,
    required this.managerName,
    this.suspensionReason,
    this.nationalId = '29501011234567',
    this.salary = 12000.0,
  });

  EmployeeEntity copyWith({
    String? id,
    String? name,
    String? jobTitle,
    String? department,
    String? role,
    String? phone,
    String? email,
    String? photoUrl,
    EmployeeStatus? status,
    String? joiningDate,
    String? employmentType,
    String? lastLogin,
    String? lastActivity,
    String? leaveReturnDate,
    int? permissionsCount,
    Map<String, ModulePermission>? permissions,
    String? managerName,
    String? suspensionReason,
    String? nationalId,
    double? salary,
  }) {
    return EmployeeEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      jobTitle: jobTitle ?? this.jobTitle,
      department: department ?? this.department,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      status: status ?? this.status,
      joiningDate: joiningDate ?? this.joiningDate,
      employmentType: employmentType ?? this.employmentType,
      lastLogin: lastLogin ?? this.lastLogin,
      lastActivity: lastActivity ?? this.lastActivity,
      leaveReturnDate: leaveReturnDate ?? this.leaveReturnDate,
      permissionsCount: permissionsCount ?? this.permissionsCount,
      permissions: permissions ?? this.permissions,
      managerName: managerName ?? this.managerName,
      suspensionReason: suspensionReason ?? this.suspensionReason,
      nationalId: nationalId ?? this.nationalId,
      salary: salary ?? this.salary,
    );
  }
}

/// Department Entity
@immutable
class DepartmentEntity {
  final String id;
  final String name;
  final String code;
  final String description;
  final String headName;
  final int employeeCount;
  final String iconName;

  const DepartmentEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.headName,
    required this.employeeCount,
    this.iconName = 'business',
  });
}

/// Role Entity
@immutable
class RoleEntity {
  final String id;
  final String name;
  final String code;
  final String description;
  final bool isCustom;
  final int assignedUsersCount;
  final Map<String, ModulePermission> permissions;

  const RoleEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    this.isCustom = false,
    required this.assignedUsersCount,
    required this.permissions,
  });
}

/// Employee Activity Item
@immutable
class EmployeeActivityItem {
  final String id;
  final String employeeId;
  final String employeeName;
  final String action;
  final String description;
  final String timestamp;

  const EmployeeActivityItem({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.action,
    required this.description,
    required this.timestamp,
  });
}

/// Employee Attendance Entity
@immutable
class AttendanceEntity {
  final String employeeId;
  final String currentStatus;
  final String lastLogin;
  final String lastActivity;
  final double workingHoursThisMonth;
  final int leaveBalanceDays;
  final List<String> history;

  const AttendanceEntity({
    required this.employeeId,
    required this.currentStatus,
    required this.lastLogin,
    required this.lastActivity,
    required this.workingHoursThisMonth,
    required this.leaveBalanceDays,
    required this.history,
  });
}

/// Employee Assigned Work Item
@immutable
class AssignedWorkEntity {
  final String employeeId;
  final List<String> assignedRFQs;
  final List<String> assignedDeals;
  final List<String> assignedOrders;
  final List<String> assignedSuppliers;
  final List<String> assignedTasks;

  const AssignedWorkEntity({
    required this.employeeId,
    required this.assignedRFQs,
    required this.assignedDeals,
    required this.assignedOrders,
    required this.assignedSuppliers,
    required this.assignedTasks,
  });
}

