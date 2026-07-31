// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/constants/app_colors.dart';
import 'package:naseeji_factory/core/constants/app_radius.dart';
import 'package:naseeji_factory/core/extensions/context_extensions.dart';

import '../../providers/account_provider.dart';

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



