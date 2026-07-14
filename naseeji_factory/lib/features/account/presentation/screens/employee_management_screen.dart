import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/account_provider.dart';
import '../widgets/account_reusable_widgets.dart';
import '../widgets/employee_management/add_employee_button.dart';
import '../widgets/employee_management/add_employee_form.dart';
import '../widgets/employee_management/edit_permissions_sheet.dart';
import '../widgets/employee_management/employee_list_widget.dart';
import '../widgets/employee_management/employee_search_widget.dart';

class EmployeeManagementScreen extends ConsumerStatefulWidget {
  const EmployeeManagementScreen({super.key});

  @override
  ConsumerState<EmployeeManagementScreen> createState() => _EmployeeManagementScreenState();
}

class _EmployeeManagementScreenState extends ConsumerState<EmployeeManagementScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    ref.watch(accountNotifierProvider);
    final notifier = ref.read(accountNotifierProvider.notifier);
    final employees = notifier.searchEmployees(_searchQuery);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الموظفين والصلاحيات'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      floatingActionButton: AddEmployeeButton(
        onTap: () => _showAddEmployeeSheet(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary row
              Row(
                children: [
                  StatisticCard(
                    icon: Icons.people_rounded,
                    value: '${employees.length}',
                    label: 'إجمالي الموظفين',
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 10),
                  StatisticCard(
                    icon: Icons.check_circle_rounded,
                    value: '${employees.where((e) => e.status == EmployeeStatus.active).length}',
                    label: 'نشطون',
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 10),
                  StatisticCard(
                    icon: Icons.pause_circle_rounded,
                    value: '${employees.where((e) => e.status == EmployeeStatus.inactive).length}',
                    label: 'غير نشطين',
                    color: Colors.grey,
                  ),
                ],
              ),
              AppSpacing.hMD,
              EmployeeSearchWidget(
                onChanged: (q) => setState(() => _searchQuery = q),
              ),
              AppSpacing.hMD,
              EmployeeListWidget(
                employees: employees,
                onEdit: (emp) => _showEditSheet(context, emp),
                onToggleStatus: (id) {
                  ref.read(accountNotifierProvider.notifier).toggleEmployeeStatus(id);
                },
                onDelete: (id) => _confirmDelete(context, id),
              ),
              const SizedBox(height: 80),
            ],
          ),
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
      builder: (_) => AddEmployeeForm(
        onSave: (emp) {
          ref.read(accountNotifierProvider.notifier).addEmployee(emp);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم إضافة الموظف بنجاح!')),
          );
        },
      ),
    );
  }

  void _showEditSheet(BuildContext context, EmployeeModel emp) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => EditPermissionsSheet(
        employee: emp,
        onSave: (updated) {
          ref.read(accountNotifierProvider.notifier).updateEmployee(updated);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تحديث صلاحيات الموظف!')),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('حذف الموظف'),
        content: const Text('هل أنت متأكد من حذف هذا الموظف؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              ref.read(accountNotifierProvider.notifier).removeEmployee(id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حذف الموظف.')),
              );
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
