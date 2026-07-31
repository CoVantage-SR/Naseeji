import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/employee_entities.dart';
import '../providers/employees_provider.dart';

class RolesManagementScreen extends ConsumerWidget {
  const RolesManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(employeesProvider);

    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الأدوار والصلاحيات'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddRoleDialog(context, ref),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.security_rounded, color: Colors.white),
        label: const Text('إنشاء دور مخصص', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          children: [
            Text(
              'تعيين واستعراض الصلاحيات لكل مسمى وظيفي داخل المنظومة:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textPrimary),
            ),
            const SizedBox(height: 12),

            ...state.roles.map((role) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: surface,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.rLG,
                    side: BorderSide(color: border),
                  ),
                  child: ExpansionTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.shield_rounded, color: AppColors.primary, size: 20),
                    ),
                    title: Row(
                      children: [
                        Text(role.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textPrimary)),
                        if (role.isCustom) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.1), borderRadius: AppRadius.rRound),
                            child: const Text('مخصص', style: TextStyle(fontSize: 9, color: AppColors.info, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ],
                    ),
                    subtitle: Text('${role.description} • (${role.assignedUsersCount} موظفين)', style: TextStyle(fontSize: 11, color: textSecondary)),
                    children: [
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('مصفوفة الصلاحيات الممنوحة:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: role.permissions.keys.map((module) {
                                return Chip(
                                  backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                                  side: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
                                  avatar: const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.primary),
                                  label: Text(module, style: const TextStyle(fontSize: 11, color: AppColors.primary)),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  void _showAddRoleDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إنشاء دور مخصص جديد'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'اسم الدور (مثال: مشرف تصدير)')),
            const SizedBox(height: 10),
            TextField(controller: descController, decoration: const InputDecoration(labelText: 'الوصف')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                final newRole = RoleEntity(
                  id: 'ROL-${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}',
                  name: nameController.text.trim(),
                  code: 'custom',
                  description: descController.text.trim(),
                  isCustom: true,
                  assignedUsersCount: 0,
                  permissions: const {},
                );
                ref.read(employeesProvider.notifier).addRole(newRole);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم إنشاء الدور المخصص "${newRole.name}" بنجاح!')),
                );
              }
            },
            child: const Text('إنشاء الدور', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}


