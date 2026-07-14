import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/account_provider.dart';
import '../widgets/account_reusable_widgets.dart';
import '../widgets/employee_management_widgets.dart';

class EmployeeManagementScreen extends ConsumerStatefulWidget {
  const EmployeeManagementScreen({super.key});

  @override
  ConsumerState<EmployeeManagementScreen> createState() => _EmployeeManagementScreenState();
}

class _EmployeeManagementScreenState extends ConsumerState<EmployeeManagementScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
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
      builder: (_) => _AddEmployeeForm(
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
      builder: (_) => _EditPermissionsSheet(
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

// ─── Add Employee Form ─────────────────────────────────────────────────────
class _AddEmployeeForm extends StatefulWidget {
  final Function(EmployeeModel) onSave;
  const _AddEmployeeForm({required this.onSave});

  @override
  State<_AddEmployeeForm> createState() => _AddEmployeeFormState();
}

class _AddEmployeeFormState extends State<_AddEmployeeForm> {
  String _name = '';
  String _job = '';
  String _phone = '';
  String _email = '';
  EmployeeRole _role = EmployeeRole.viewer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 20, 16, MediaQuery.of(context).viewInsets.bottom + 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('إضافة موظف جديد', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            _field('الاسم الكامل', (v) => _name = v),
            const SizedBox(height: 10),
            _field('المسمى الوظيفي', (v) => _job = v),
            const SizedBox(height: 10),
            _field('رقم الهاتف', (v) => _phone = v),
            const SizedBox(height: 10),
            _field('البريد الإلكتروني', (v) => _email = v),
            const SizedBox(height: 10),
            DropdownButtonFormField<EmployeeRole>(
              value: _role,
              decoration: const InputDecoration(labelText: 'الدور الوظيفي', border: OutlineInputBorder()),
              items: EmployeeRole.values
                  .map((r) => DropdownMenuItem(value: r, child: Text(r.label, style: const TextStyle(fontSize: 12))))
                  .toList(),
              onChanged: (v) => setState(() => _role = v!),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'إضافة الموظف',
              icon: Icons.person_add_rounded,
              onPressed: _name.isNotEmpty
                  ? () => widget.onSave(EmployeeModel(
                        id: 'EMP-${DateTime.now().millisecondsSinceEpoch}',
                        name: _name,
                        jobTitle: _job,
                        phone: _phone,
                        email: _email,
                        photoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
                        role: _role,
                        status: EmployeeStatus.pending,
                        lastLogin: 'لم يسجل دخولاً بعد',
                        permissions: {},
                      ))
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, ValueChanged<String> onChanged) {
    return TextFormField(
      onChanged: onChanged,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      ),
    );
  }
}

// ─── Edit Permissions Sheet ────────────────────────────────────────────────
class _EditPermissionsSheet extends StatefulWidget {
  final EmployeeModel employee;
  final Function(EmployeeModel) onSave;
  const _EditPermissionsSheet({required this.employee, required this.onSave});

  @override
  State<_EditPermissionsSheet> createState() => _EditPermissionsSheetState();
}

class _EditPermissionsSheetState extends State<_EditPermissionsSheet> {
  late EmployeeRole _role;
  late Map<String, bool> _permissions;

  @override
  void initState() {
    super.initState();
    _role = widget.employee.role;
    _permissions = Map.from(widget.employee.permissions);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 20, 16, MediaQuery.of(context).viewInsets.bottom + 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('تعديل: ${widget.employee.name}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 16),
            RoleWidget(
              selected: _role,
              onChanged: (r) => setState(() => _role = r),
            ),
            const SizedBox(height: 12),
            PermissionWidget(
              permissions: _permissions,
              onToggle: (key, val) => setState(() => _permissions[key] = val),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'حفظ التغييرات',
              icon: Icons.save_rounded,
              onPressed: () => widget.onSave(widget.employee.copyWith(role: _role, permissions: _permissions)),
            ),
          ],
        ),
      ),
    );
  }
}
