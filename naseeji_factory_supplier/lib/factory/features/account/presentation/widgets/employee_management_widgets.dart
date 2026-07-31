// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/constants/app_colors.dart';
import 'package:naseeji_factory/core/constants/app_radius.dart';
import 'package:naseeji_factory/core/extensions/context_extensions.dart';

import '../providers/account_provider.dart';
import 'account_reusable_widgets.dart';

// ─── Employee Search Widget ────────────────────────────────────────────────
class EmployeeSearchWidget extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const EmployeeSearchWidget({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'بحث في الموظفين...',
        hintStyle: const TextStyle(fontSize: 13),
        prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: AppRadius.rMD),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.rMD,
          borderSide: BorderSide(
            color: context.theme.brightness == Brightness.dark
                ? AppColors.borderDark
                : AppColors.borderLight,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.rMD,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        filled: true,
      ),
    );
  }
}

// ─── Employee List Widget ──────────────────────────────────────────────────
class EmployeeListWidget extends StatelessWidget {
  final List<EmployeeModel> employees;
  final Function(EmployeeModel) onEdit;
  final Function(String) onToggleStatus;
  final Function(String) onDelete;

  const EmployeeListWidget({
    super.key,
    required this.employees,
    required this.onEdit,
    required this.onToggleStatus,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (employees.isEmpty) {
      return const AccountEmptyStateWidget(
        title: 'لا يوجد موظفون',
        description: 'أضف موظفين إلى المصنع وحدد صلاحياتهم.',
        icon: Icons.people_outline_rounded,
      );
    }
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: employees.length,
      itemBuilder: (_, i) {
        final emp = employees[i];
        return EmployeeCard(
          employee: emp,
          onEdit: () => onEdit(emp),
          onToggleStatus: () => onToggleStatus(emp.id),
          onDelete: () => onDelete(emp.id),
        );
      },
    );
  }
}

// ─── Role Widget ───────────────────────────────────────────────────────────
class RoleWidget extends StatelessWidget {
  final EmployeeRole selected;
  final ValueChanged<EmployeeRole> onChanged;
  const RoleWidget({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('الدور الوظيفي',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
            const SizedBox(height: 12),
            ...EmployeeRole.values.map((r) => RadioListTile<EmployeeRole>(
                  dense: true,
                  title: Text(r.label, style: const TextStyle(fontSize: 13)),
                  value: r,
                  groupValue: selected,
                  onChanged: (v) => onChanged(v!),
                  activeColor: AppColors.primary,
                )),
          ],
        ),
      ),
    );
  }
}

// ─── Permission Widget ─────────────────────────────────────────────────────
class PermissionWidget extends StatelessWidget {
  final Map<String, bool> permissions;
  final Function(String, bool) onToggle;
  const PermissionWidget({super.key, required this.permissions, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('الصلاحيات الممنوحة',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: permissions.entries
                  .map((e) => PermissionChip(
                        label: e.key,
                        granted: e.value,
                        onToggle: () => onToggle(e.key, !e.value),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Add/Edit Employee Button ──────────────────────────────────────────────
class AddEmployeeButton extends StatelessWidget {
  final VoidCallback onTap;
  const AddEmployeeButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: null,
      onPressed: onTap,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.person_add_rounded),
      label: const Text('إضافة موظف', style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}



