import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/employee_entities.dart';
import '../providers/employees_provider.dart';

class AddEmployeeSheet extends ConsumerStatefulWidget {
  const AddEmployeeSheet({super.key});

  @override
  ConsumerState<AddEmployeeSheet> createState() => _AddEmployeeSheetState();
}

class _AddEmployeeSheetState extends ConsumerState<AddEmployeeSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _managerController = TextEditingController(text: 'مصطفى النجار');

  String _selectedDept = 'قسم المشتريات';
  String _selectedRole = 'purchasingOfficer';
  final String _selectedEmploymentType = 'دوام كامل';
  final EmployeeStatus _selectedStatus = EmployeeStatus.active;
  final Map<String, bool> _permissions = {
    'المنتجات': true,
    'عروض الأسعار': true,
    'الطلبات': true,
    'المالية': false,
    'التقارير': false,
    'الموظفون': false,
  };

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('إضافة موظف جديد', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textPrimary)),
                  IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 12),

              // Avatar picker placeholder
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: const Icon(Icons.person_add_rounded, color: AppColors.primary, size: 36),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'الاسم بالكامل *', border: OutlineInputBorder()),
                validator: (v) => v == null || v.trim().isEmpty ? 'برجاء إدخال الاسم' : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _jobTitleController,
                decoration: const InputDecoration(labelText: 'المسمى الوظيفي *', border: OutlineInputBorder()),
                validator: (v) => v == null || v.trim().isEmpty ? 'برجاء إدخال الوظيفة' : null,
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: 'رقم الهاتف *', border: OutlineInputBorder()),
                      validator: (v) => v == null || v.trim().isEmpty ? 'مطلوب' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'البريد الإلكتروني *', border: OutlineInputBorder()),
                      validator: (v) => v == null || v.trim().isEmpty ? 'مطلوب' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'كلمة المرور المؤقتة *', border: OutlineInputBorder()),
                validator: (v) => v == null || v.length < 6 ? 'كلمة المرور 6 أحرف على الأقل' : null,
              ),
              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                initialValue: _selectedDept,
                decoration: const InputDecoration(labelText: 'القسم', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'قسم المشتريات', child: Text('قسم المشتريات')),
                  DropdownMenuItem(value: 'قسم الإنتاج', child: Text('قسم الإنتاج')),
                  DropdownMenuItem(value: 'قسم المالية', child: Text('قسم المالية')),
                  DropdownMenuItem(value: 'قسم المخازن', child: Text('قسم المخازن')),
                  DropdownMenuItem(value: 'قسم الجودة', child: Text('قسم الجودة')),
                  DropdownMenuItem(value: 'قسم الصيانة', child: Text('قسم الصيانة')),
                  DropdownMenuItem(value: 'الإدارة العليا', child: Text('الإدارة العليا')),
                ],
                onChanged: (val) => setState(() => _selectedDept = val!),
              ),
              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                initialValue: _selectedRole,
                decoration: const InputDecoration(labelText: 'الدور الوظيفي', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'purchasingOfficer', child: Text('مسؤول مشتريات')),
                  DropdownMenuItem(value: 'purchasingManager', child: Text('مدير مشتريات')),
                  DropdownMenuItem(value: 'accountant', child: Text('محاسب')),
                  DropdownMenuItem(value: 'qualityInspector', child: Text('أخصائي جودة')),
                  DropdownMenuItem(value: 'productionManager', child: Text('مشرف إنتاج')),
                  DropdownMenuItem(value: 'warehouseManager', child: Text('مدير مخازن')),
                  DropdownMenuItem(value: 'viewer', child: Text('مشاهد فقط')),
                ],
                onChanged: (val) => setState(() => _selectedRole = val!),
              ),
              const SizedBox(height: 12),

              const Text('الصلاحيات الممنوحة:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Wrap(
                spacing: 8,
                children: _permissions.keys.map((key) {
                  final val = _permissions[key]!;
                  return FilterChip(
                    label: Text(key),
                    selected: val,
                    onSelected: (selected) {
                      setState(() => _permissions[key] = selected);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 46),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                ),
                onPressed: _save,
                child: const Text('حفظ وإضافة الموظف', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final newEmp = EmployeeEntity(
        id: 'EMP0${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}',
        name: _nameController.text.trim(),
        jobTitle: _jobTitleController.text.trim(),
        department: _selectedDept,
        role: _selectedRole,
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        photoUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
        status: _selectedStatus,
        joiningDate: 'الآن',
        employmentType: _selectedEmploymentType,
        lastLogin: 'لم يسجل دخول بعد',
        lastActivity: 'تم إنشاء الحساب',
        permissionsCount: _permissions.values.where((v) => v).length,
        permissions: const {},
        managerName: _managerController.text.trim(),
      );

      ref.read(employeesProvider.notifier).addEmployee(newEmp);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم إضافة الموظف "${newEmp.name}" بنجاح!')),
      );
    }
  }
}

class DeleteEmployeeDialog extends StatelessWidget {
  final EmployeeEntity employee;
  final VoidCallback onConfirm;

  const DeleteEmployeeDialog({super.key, required this.employee, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('تأكيد حذف الموظف'),
      content: Text('هل أنت متأكد من رغبتك في حذف الموظف "${employee.name}"؟ سيتم نقل بياناته للأرشيف وسيُمنع من الدخول.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },
          child: const Text('تأكيد الحذف', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class SuspendEmployeeDialog extends StatefulWidget {
  final EmployeeEntity employee;
  final ValueChanged<String> onConfirm;

  const SuspendEmployeeDialog({super.key, required this.employee, required this.onConfirm});

  @override
  State<SuspendEmployeeDialog> createState() => _SuspendEmployeeDialogState();
}

class _SuspendEmployeeDialogState extends State<SuspendEmployeeDialog> {
  final _reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isSuspended = widget.employee.status == EmployeeStatus.suspended;
    return AlertDialog(
      title: Text(isSuspended ? 'إلغاء تجميد الحساب' : 'تجميد حساب الموظف'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(isSuspended
              ? 'هل ترغب في إعادة تفعيل حساب الموظف "${widget.employee.name}" للسماح له بالدخول؟'
              : 'يرجى كتابة سبب تجميد حساب الموظف "${widget.employee.name}":'),
          if (!isSuspended) ...[
            const SizedBox(height: 10),
            TextField(
              controller: _reasonController,
              decoration: const InputDecoration(labelText: 'سبب التجميد', border: OutlineInputBorder()),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning),
          onPressed: () {
            widget.onConfirm(_reasonController.text.trim());
            Navigator.pop(context);
          },
          child: Text(isSuspended ? 'تفعيل الحساب' : 'تأكيد التجميد', style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class ResetPasswordDialog extends StatefulWidget {
  final EmployeeEntity employee;
  final ValueChanged<String> onConfirm;

  const ResetPasswordDialog({super.key, required this.employee, required this.onConfirm});

  @override
  State<ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  final _passController = TextEditingController(text: 'Naseeji@2026');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('إعادة ضبط كلمة المرور'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('تعيين كلمة مرور جديدة للموظف "${widget.employee.name}":'),
          const SizedBox(height: 10),
          TextField(
            controller: _passController,
            decoration: const InputDecoration(labelText: 'كلمة المرور الجديدة', border: OutlineInputBorder()),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          onPressed: () {
            widget.onConfirm(_passController.text.trim());
            Navigator.pop(context);
          },
          child: const Text('حفظ وإرسال', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
