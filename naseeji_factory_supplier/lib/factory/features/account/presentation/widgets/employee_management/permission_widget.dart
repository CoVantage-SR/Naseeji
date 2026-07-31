import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/constants/app_colors.dart';
import 'package:naseeji_factory/core/constants/app_radius.dart';
import 'package:naseeji_factory/core/extensions/context_extensions.dart';

import '../account_reusable_widgets.dart';

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


