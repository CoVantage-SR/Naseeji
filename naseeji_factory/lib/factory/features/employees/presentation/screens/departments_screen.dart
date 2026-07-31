import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/employee_entities.dart';
import '../providers/employees_provider.dart';

class DepartmentsScreen extends ConsumerWidget {
  const DepartmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(employeesProvider);

    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة أقسام المصنع'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDepartmentDialog(context, ref),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_business_outlined, color: Colors.white),
        label: const Text(
          'إضافة قسم جديد',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          children: [
            Text(
              'الهيكل التنظيمي وأقسام المصنع المعتمدة:',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            ...state.departments.map((dept) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: surface,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.rLG,
                    side: BorderSide(color: border),
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.business_rounded,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ),
                    title: Text(
                      dept.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      '${dept.description}\nرئيس القسم: ${dept.headName}',
                      style: TextStyle(fontSize: 11, color: textSecondary),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: AppRadius.rRound,
                      ),
                      child: Text(
                        '${dept.employeeCount} موظف',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
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

  void _showAddDepartmentDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إضافة قسم جديد'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'اسم القسم (مثال: قسم التعبئة والتغليف)',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'الوصف والمهام'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                final newDept = DepartmentEntity(
                  id: 'DEP-${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}',
                  name: nameController.text.trim(),
                  code: 'CUSTOM',
                  description: descController.text.trim(),
                  headName: 'غير محدد',
                  employeeCount: 0,
                );
                ref.read(employeesProvider.notifier).addDepartment(newDept);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم إضافة القسم "${newDept.name}" بنجاح!'),
                  ),
                );
              }
            },
            child: const Text(
              'إضافة القسم',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
