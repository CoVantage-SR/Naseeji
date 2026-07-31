import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/employees_provider.dart';
import '../widgets/employee_dialogs.dart';
import '../widgets/employee_widgets.dart';

class EmployeeManagementScreen extends ConsumerStatefulWidget {
  const EmployeeManagementScreen({super.key});

  @override
  ConsumerState<EmployeeManagementScreen> createState() => _EmployeeManagementScreenState();
}

class _EmployeeManagementScreenState extends ConsumerState<EmployeeManagementScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final state = ref.watch(employeesProvider);
    final notifier = ref.read(employeesProvider.notifier);

    final isDark = context.theme.brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Header ──────────────────────────────────────────
            const EmployeeManagementHeader(),

            // ── Scrollable Body Content ─────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                children: [
                  // 1. Statistics Cards (4 Cards)
                  const EmployeeStatsCards(),
                  const SizedBox(height: 16),

                  // 2. Quick Actions Row (Add, Roles, Departments)
                  EmployeeQuickActions(
                    onAddEmployee: () => _showAddEmployeeSheet(context),
                    onRoles: () => context.push('/account/employees/roles'),
                    onDepartments: () => context.push('/account/employees/departments'),
                  ),
                  const SizedBox(height: 16),

                  // 3. Search & Filter Bar
                  const EmployeeSearchAndFilters(),
                  const SizedBox(height: 16),

                  // 4. Section Title Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'قائمة الموظفين (${state.filteredEmployees.length})',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                      if (state.searchQuery.isNotEmpty ||
                          state.selectedRole != 'الكل' ||
                          state.selectedDepartment != 'الكل' ||
                          state.selectedStatus != 'الكل')
                        TextButton(
                          onPressed: () {
                            notifier.setSearchQuery('');
                            notifier.setSelectedRole('الكل');
                            notifier.setSelectedDepartment('الكل');
                            notifier.setSelectedStatus('الكل');
                          },
                          child: const Text('مسح الفلاتر', style: TextStyle(fontSize: 11)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // 5. Paginated Employee Cards List
                  if (state.paginatedEmployees.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: const [
                            Icon(Icons.search_off_rounded, size: 64, color: Colors.grey),
                            SizedBox(height: 12),
                            Text('لا يوجد موظفين يطابقون خيارات البحث والتصفية.',
                                style: TextStyle(color: Colors.grey, fontSize: 13)),
                          ],
                        ),
                      ),
                    )
                  else
                    ...state.paginatedEmployees.map((emp) {
                      return EmployeeCardWidget(
                        employee: emp,
                        onTap: () => context.push('/account/employees/${emp.id}'),
                        onEdit: () => context.push('/account/employees/${emp.id}'),
                        onAssignRole: () => _showAssignRoleDialog(context, emp),
                        onAssignDept: () => _showAssignDeptDialog(context, emp),
                        onResetPassword: () => _showResetPasswordDialog(context, emp),
                        onSuspend: () => _showSuspendDialog(context, emp),
                        onDelete: () => _showDeleteDialog(context, emp),
                      );
                    }),

                  const SizedBox(height: 16),

                  // 6. Pagination Bar
                  if (state.filteredEmployees.isNotEmpty)
                    const EmployeePaginationBar(),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddEmployeeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const AddEmployeeSheet(),
    );
  }

  void _showDeleteDialog(BuildContext context, dynamic emp) {
    showDialog(
      context: context,
      builder: (_) => DeleteEmployeeDialog(
        employee: emp,
        onConfirm: () {
          ref.read(employeesProvider.notifier).deleteEmployee(emp.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم حذف الموظف "${emp.name}".')),
          );
        },
      ),
    );
  }

  void _showSuspendDialog(BuildContext context, dynamic emp) {
    showDialog(
      context: context,
      builder: (_) => SuspendEmployeeDialog(
        employee: emp,
        onConfirm: (reason) {
          ref.read(employeesProvider.notifier).suspendEmployee(emp.id, reason);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم تحديث حالة تجميد الحساب للموظف "${emp.name}".')),
          );
        },
      ),
    );
  }

  void _showResetPasswordDialog(BuildContext context, dynamic emp) {
    showDialog(
      context: context,
      builder: (_) => ResetPasswordDialog(
        employee: emp,
        onConfirm: (newPass) {
          ref.read(employeesProvider.notifier).resetPassword(emp.id, newPass);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم إرسال كلمة المرور الجديدة للموظف "${emp.name}".')),
          );
        },
      ),
    );
  }

  void _showAssignRoleDialog(BuildContext context, dynamic emp) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('تعيين دور جديد لـ ${emp.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('مدير مشتريات'),
              onTap: () {
                ref.read(employeesProvider.notifier).assignRole(emp.id, 'purchasingManager');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('مسؤول مشتريات'),
              onTap: () {
                ref.read(employeesProvider.notifier).assignRole(emp.id, 'purchasingOfficer');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('محاسب'),
              onTap: () {
                ref.read(employeesProvider.notifier).assignRole(emp.id, 'accountant');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('مشرف إنتاج'),
              onTap: () {
                ref.read(employeesProvider.notifier).assignRole(emp.id, 'productionManager');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAssignDeptDialog(BuildContext context, dynamic emp) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('تعيين قسم لـ ${emp.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('قسم المشتريات'),
              onTap: () {
                ref.read(employeesProvider.notifier).assignDepartment(emp.id, 'قسم المشتريات');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('قسم الإنتاج'),
              onTap: () {
                ref.read(employeesProvider.notifier).assignDepartment(emp.id, 'قسم الإنتاج');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('قسم المالية'),
              onTap: () {
                ref.read(employeesProvider.notifier).assignDepartment(emp.id, 'قسم المالية');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('قسم المخازن'),
              onTap: () {
                ref.read(employeesProvider.notifier).assignDepartment(emp.id, 'قسم المخازن');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}


