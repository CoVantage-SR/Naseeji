import '../entities/employee_entities.dart';
import '../repositories/employees_repository.dart';

class GetEmployeesUseCase {
  final EmployeesRepository repository;
  GetEmployeesUseCase(this.repository);

  Future<List<EmployeeEntity>> call() => repository.getEmployees();
}

class AddEmployeeUseCase {
  final EmployeesRepository repository;
  AddEmployeeUseCase(this.repository);

  Future<void> call(EmployeeEntity employee) => repository.addEmployee(employee);
}

class UpdateEmployeeUseCase {
  final EmployeesRepository repository;
  UpdateEmployeeUseCase(this.repository);

  Future<void> call(EmployeeEntity employee) => repository.updateEmployee(employee);
}

class DeleteEmployeeUseCase {
  final EmployeesRepository repository;
  DeleteEmployeeUseCase(this.repository);

  Future<void> call(String id) => repository.deleteEmployee(id);
}

class SuspendEmployeeUseCase {
  final EmployeesRepository repository;
  SuspendEmployeeUseCase(this.repository);

  Future<void> call(String id, String reason) => repository.suspendEmployee(id, reason);
}

class ResetPasswordUseCase {
  final EmployeesRepository repository;
  ResetPasswordUseCase(this.repository);

  Future<void> call(String id, String newPassword) => repository.resetPassword(id, newPassword);
}

class AssignRoleUseCase {
  final EmployeesRepository repository;
  AssignRoleUseCase(this.repository);

  Future<void> call(String id, String roleCode) => repository.assignRole(id, roleCode);
}

class AssignDepartmentUseCase {
  final EmployeesRepository repository;
  AssignDepartmentUseCase(this.repository);

  Future<void> call(String id, String deptName) => repository.assignDepartment(id, deptName);
}
