import 'package:flutter/material.dart';
import '../../providers/account_provider.dart';
import '../account_reusable_widgets.dart';

class AddEmployeeForm extends StatefulWidget {
  final Function(EmployeeModel) onSave;
  const AddEmployeeForm({super.key, required this.onSave});

  @override
  State<AddEmployeeForm> createState() => _AddEmployeeFormState();
}

class _AddEmployeeFormState extends State<AddEmployeeForm> {
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
              initialValue: _role,
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
                        role: _role.name,
                        status: EmployeeStatus.pending.name,
                        department: _job.isNotEmpty ? _job : 'الإدارة العامة',
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

