import '../entities/employee_entities.dart';

abstract class EmployeesRepository {
  Future<List<EmployeeEntity>> getEmployees();
  Future<EmployeeEntity?> getEmployeeById(String id);
  Future<void> addEmployee(EmployeeEntity employee);
  Future<void> updateEmployee(EmployeeEntity employee);
  Future<void> deleteEmployee(String id);
  Future<void> suspendEmployee(String id, String reason);
  Future<void> resetPassword(String id, String newPassword);
  Future<void> assignRole(String id, String roleCode);
  Future<void> assignDepartment(String id, String departmentName);

  Future<List<DepartmentEntity>> getDepartments();
  Future<void> addDepartment(DepartmentEntity department);

  Future<List<RoleEntity>> getRoles();
  Future<void> addRole(RoleEntity role);

  Future<List<EmployeeActivityItem>> getEmployeeActivities(String employeeId);
  Future<AttendanceEntity?> getEmployeeAttendance(String employeeId);
  Future<AssignedWorkEntity?> getEmployeeAssignedWork(String employeeId);
}
