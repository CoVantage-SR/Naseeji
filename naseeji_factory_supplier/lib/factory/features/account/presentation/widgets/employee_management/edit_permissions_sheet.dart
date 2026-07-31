import 'package:flutter/material.dart';
import '../../providers/account_provider.dart';
import '../account_reusable_widgets.dart';
import 'role_widget.dart';
import 'permission_widget.dart';

class EditPermissionsSheet extends StatefulWidget {
  final EmployeeModel employee;
  final Function(EmployeeModel) onSave;
  const EditPermissionsSheet({super.key, required this.employee, required this.onSave});

  @override
  State<EditPermissionsSheet> createState() => _EditPermissionsSheetState();
}

class _EditPermissionsSheetState extends State<EditPermissionsSheet> {
  late EmployeeRole _role;
  late Map<String, bool> _permissions;

  @override
  void initState() {
    super.initState();
    _role = EmployeeRole.values.firstWhere(
      (r) => r.name == widget.employee.role,
      orElse: () => EmployeeRole.viewer,
    );
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
              onPressed: () => widget.onSave(widget.employee.copyWith(role: _role.name, permissions: _permissions)),
            ),
          ],
        ),
      ),
    );
  }
}


