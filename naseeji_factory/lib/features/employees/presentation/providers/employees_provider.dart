import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/employees_repository_impl.dart';
import '../../domain/entities/employee_entities.dart';
import '../../domain/repositories/employees_repository.dart';
import '../../../../features/account/presentation/providers/account_provider.dart';

final employeesRepositoryProvider = Provider<EmployeesRepository>((ref) {
  return EmployeesRepositoryImpl();
});

class EmployeesState {
  final List<EmployeeEntity> allEmployees;
  final List<DepartmentEntity> departments;
  final List<RoleEntity> roles;
  final String searchQuery;
  final String selectedRole;
  final String selectedDepartment;
  final String selectedStatus;
  final String sortOption;
  final int currentPage;
  final int itemsPerPage;

  const EmployeesState({
    this.allEmployees = const [],
    this.departments = const [],
    this.roles = const [],
    this.searchQuery = '',
    this.selectedRole = 'الكل',
    this.selectedDepartment = 'الكل',
    this.selectedStatus = 'الكل',
    this.sortOption = 'أحدث',
    this.currentPage = 1,
    this.itemsPerPage = 5,
  });

  EmployeesState copyWith({
    List<EmployeeEntity>? allEmployees,
    List<DepartmentEntity>? departments,
    List<RoleEntity>? roles,
    String? searchQuery,
    String? selectedRole,
    String? selectedDepartment,
    String? selectedStatus,
    String? sortOption,
    int? currentPage,
    int? itemsPerPage,
  }) {
    return EmployeesState(
      allEmployees: allEmployees ?? this.allEmployees,
      departments: departments ?? this.departments,
      roles: roles ?? this.roles,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedRole: selectedRole ?? this.selectedRole,
      selectedDepartment: selectedDepartment ?? this.selectedDepartment,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      sortOption: sortOption ?? this.sortOption,
      currentPage: currentPage ?? this.currentPage,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
    );
  }

  // Computed Properties
  int get totalEmployeesCount => allEmployees.length;
  int get activeEmployeesCount =>
      allEmployees.where((e) => e.status == EmployeeStatus.active).length;
  int get onLeaveEmployeesCount =>
      allEmployees.where((e) => e.status == EmployeeStatus.onLeave).length;
  int get inactiveEmployeesCount =>
      allEmployees.where((e) => e.status == EmployeeStatus.inactive || e.status == EmployeeStatus.suspended).length;

  List<EmployeeEntity> get filteredEmployees {
    var list = List<EmployeeEntity>.from(allEmployees);

    // Live Search
    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.trim().toLowerCase();
      list = list.where((e) {
        return e.name.toLowerCase().contains(q) ||
            e.id.toLowerCase().contains(q) ||
            e.department.toLowerCase().contains(q) ||
            e.jobTitle.toLowerCase().contains(q) ||
            e.phone.toLowerCase().contains(q) ||
            e.email.toLowerCase().contains(q);
      }).toList();
    }

    // Role filter
    if (selectedRole != 'الكل') {
      list = list.where((e) => e.role == selectedRole || e.jobTitle == selectedRole).toList();
    }

    // Department filter
    if (selectedDepartment != 'الكل') {
      list = list.where((e) => e.department == selectedDepartment).toList();
    }

    // Status filter
    if (selectedStatus != 'الكل') {
      list = list.where((e) {
        if (selectedStatus == 'نشط') return e.status == EmployeeStatus.active;
        if (selectedStatus == 'في إجازة') return e.status == EmployeeStatus.onLeave;
        if (selectedStatus == 'غير نشط') return e.status == EmployeeStatus.inactive;
        if (selectedStatus == 'موقوف') return e.status == EmployeeStatus.suspended;
        return true;
      }).toList();
    }

    // Sort
    if (sortOption == 'أحدث') {
      list.sort((a, b) => b.id.compareTo(a.id));
    } else if (sortOption == 'أقدم') {
      list.sort((a, b) => a.id.compareTo(b.id));
    } else if (sortOption == 'الاسم') {
      list.sort((a, b) => a.name.compareTo(b.name));
    } else if (sortOption == 'القسم') {
      list.sort((a, b) => a.department.compareTo(b.department));
    }

    return list;
  }

  int get totalPages {
    final count = filteredEmployees.length;
    if (count == 0) return 1;
    return (count / itemsPerPage).ceil();
  }

  List<EmployeeEntity> get paginatedEmployees {
    final filtered = filteredEmployees;
    final startIndex = (currentPage - 1) * itemsPerPage;
    if (startIndex >= filtered.length) {
      return [];
    }
    final endIndex = (startIndex + itemsPerPage).clamp(0, filtered.length);
    return filtered.sublist(startIndex, endIndex);
  }
}

class EmployeesNotifier extends StateNotifier<EmployeesState> {
  final EmployeesRepository _repo;
  final Ref _ref;

  EmployeesNotifier(this._repo, this._ref) : super(const EmployeesState()) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final emps = await _repo.getEmployees();
    final depts = await _repo.getDepartments();
    final rls = await _repo.getRoles();
    state = state.copyWith(
      allEmployees: emps,
      departments: depts,
      roles: rls,
    );
  }

  void setSearchQuery(String q) {
    state = state.copyWith(searchQuery: q, currentPage: 1);
  }

  void setSelectedRole(String role) {
    state = state.copyWith(selectedRole: role, currentPage: 1);
  }

  void setSelectedDepartment(String dept) {
    state = state.copyWith(selectedDepartment: dept, currentPage: 1);
  }

  void setSelectedStatus(String status) {
    state = state.copyWith(selectedStatus: status, currentPage: 1);
  }

  void setSortOption(String sort) {
    state = state.copyWith(sortOption: sort, currentPage: 1);
  }

  void setPage(int page) {
    if (page >= 1 && page <= state.totalPages) {
      state = state.copyWith(currentPage: page);
    }
  }

  void setItemsPerPage(int count) {
    state = state.copyWith(itemsPerPage: count, currentPage: 1);
  }

  Future<void> addEmployee(EmployeeEntity emp) async {
    await _repo.addEmployee(emp);
    final updated = await _repo.getEmployees();
    state = state.copyWith(allEmployees: updated);

    // Sync notification
    _ref.read(accountNotifierProvider.notifier);
  }

  Future<void> updateEmployee(EmployeeEntity emp) async {
    await _repo.updateEmployee(emp);
    final updated = await _repo.getEmployees();
    state = state.copyWith(allEmployees: updated);
  }

  Future<void> deleteEmployee(String id) async {
    await _repo.deleteEmployee(id);
    final updated = await _repo.getEmployees();
    state = state.copyWith(allEmployees: updated);
  }

  Future<void> suspendEmployee(String id, String reason) async {
    await _repo.suspendEmployee(id, reason);
    final updated = await _repo.getEmployees();
    state = state.copyWith(allEmployees: updated);
  }

  Future<void> resetPassword(String id, String newPassword) async {
    await _repo.resetPassword(id, newPassword);
  }

  Future<void> assignRole(String id, String roleCode) async {
    await _repo.assignRole(id, roleCode);
    final updated = await _repo.getEmployees();
    state = state.copyWith(allEmployees: updated);
  }

  Future<void> assignDepartment(String id, String deptName) async {
    await _repo.assignDepartment(id, deptName);
    final updated = await _repo.getEmployees();
    state = state.copyWith(allEmployees: updated);
  }

  Future<void> addDepartment(DepartmentEntity dept) async {
    await _repo.addDepartment(dept);
    final depts = await _repo.getDepartments();
    state = state.copyWith(departments: depts);
  }

  Future<void> addRole(RoleEntity role) async {
    await _repo.addRole(role);
    final rls = await _repo.getRoles();
    state = state.copyWith(roles: rls);
  }
}

final employeesProvider =
    StateNotifierProvider<EmployeesNotifier, EmployeesState>((ref) {
  final repo = ref.watch(employeesRepositoryProvider);
  return EmployeesNotifier(repo, ref);
});
