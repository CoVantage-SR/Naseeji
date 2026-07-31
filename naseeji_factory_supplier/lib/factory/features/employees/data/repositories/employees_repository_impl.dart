import '../../domain/entities/employee_entities.dart';
import '../../domain/repositories/employees_repository.dart';
import '../datasources/employees_mock_database.dart';

class EmployeesRepositoryImpl implements EmployeesRepository {
  final EmployeesMockDatabase _db = EmployeesMockDatabase.instance;

  @override
  Future<List<EmployeeEntity>> getEmployees() async {
    return _db.employees;
  }

  @override
  Future<EmployeeEntity?> getEmployeeById(String id) async {
    try {
      return _db.employees.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addEmployee(EmployeeEntity employee) async {
    _db.addEmployee(employee);
  }

  @override
  Future<void> updateEmployee(EmployeeEntity employee) async {
    _db.updateEmployee(employee);
  }

  @override
  Future<void> deleteEmployee(String id) async {
    _db.deleteEmployee(id);
  }

  @override
  Future<void> suspendEmployee(String id, String reason) async {
    _db.suspendEmployee(id, reason);
  }

  @override
  Future<void> resetPassword(String id, String newPassword) async {
    final emp = await getEmployeeById(id);
    if (emp != null) {
      // Log reset password action
      await updateEmployee(emp.copyWith(lastActivity: 'تمت إعادة ضبط كلمة المرور'));
    }
  }

  @override
  Future<void> assignRole(String id, String roleCode) async {
    final emp = await getEmployeeById(id);
    if (emp != null) {
      await updateEmployee(emp.copyWith(role: roleCode));
    }
  }

  @override
  Future<void> assignDepartment(String id, String departmentName) async {
    final emp = await getEmployeeById(id);
    if (emp != null) {
      await updateEmployee(emp.copyWith(department: departmentName));
    }
  }

  @override
  Future<List<DepartmentEntity>> getDepartments() async {
    return _db.departments;
  }

  @override
  Future<void> addDepartment(DepartmentEntity department) async {
    _db.addDepartment(department);
  }

  @override
  Future<List<RoleEntity>> getRoles() async {
    return _db.roles;
  }

  @override
  Future<void> addRole(RoleEntity role) async {
    _db.addRole(role);
  }

  @override
  Future<List<EmployeeActivityItem>> getEmployeeActivities(String employeeId) async {
    return [
      EmployeeActivityItem(
        id: 'ACT-01',
        employeeId: employeeId,
        employeeName: 'الموظف',
        action: 'تسجيل دخول',
        description: 'تسجيل دخول ناجح من الجهاز الحالي',
        timestamp: 'اليوم 08:45 ص',
      ),
      EmployeeActivityItem(
        id: 'ACT-02',
        employeeId: employeeId,
        employeeName: 'الموظف',
        action: 'تعديل عرض سعر',
        description: 'تعديل السعر الإجمالي في طلب عرض السعر #RFQ-102',
        timestamp: 'أمس 03:20 م',
      ),
      EmployeeActivityItem(
        id: 'ACT-03',
        employeeId: employeeId,
        employeeName: 'الموظف',
        action: 'اعتماد صفقة',
        description: 'اعتماد الصفقة #DEAL-2024-88',
        timestamp: 'منذ 3 أيام',
      ),
    ];
  }

  @override
  Future<AttendanceEntity?> getEmployeeAttendance(String employeeId) async {
    final emp = await getEmployeeById(employeeId);
    if (emp == null) return null;
    return AttendanceEntity(
      employeeId: employeeId,
      currentStatus: emp.status.label,
      lastLogin: emp.lastLogin,
      lastActivity: emp.lastActivity,
      workingHoursThisMonth: 168.0,
      leaveBalanceDays: 21,
      history: [
        '2026/07/28: حضور (08:30 ص - 04:30 م)',
        '2026/07/27: حضور (08:45 ص - 04:45 م)',
        '2026/07/26: حضور (08:30 ص - 04:30 م)',
        '2026/07/25: إجازة عارضة',
      ],
    );
  }

  @override
  Future<AssignedWorkEntity?> getEmployeeAssignedWork(String employeeId) async {
    return AssignedWorkEntity(
      employeeId: employeeId,
      assignedRFQs: ['RFQ-102 (غزول قطن)', 'RFQ-108 (خيوط بوليستر)'],
      assignedDeals: ['DEAL-2024-88 (توريد 500 كجم)'],
      assignedOrders: ['ORD-902 (طلب تصنيع أقمشة)'],
      assignedSuppliers: ['شركة النيل للغزول', 'الهرم للغزل والنسيج'],
      assignedTasks: [
        'مراجعة جودة العينات الواردة',
        'متابعة الشحنة المعلقة في ميناء السخنة',
      ],
    );
  }
}
