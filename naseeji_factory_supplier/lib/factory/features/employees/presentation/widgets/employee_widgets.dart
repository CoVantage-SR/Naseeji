// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/employee_entities.dart';
import '../providers/employees_provider.dart';

// ══════════════════════════════════════════════════════════════
//  1. Employee Management Header
// ══════════════════════════════════════════════════════════════

class EmployeeManagementHeader extends ConsumerWidget {
  const EmployeeManagementHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: surface,
        border: Border(bottom: BorderSide(color: border, width: 0.5)),
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                context.go('/profile');
              }
            },
          ),
          const SizedBox(width: 4),

          // Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'إدارة الموظفين',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'إدارة فريق عمل مصنع النسيج الحديث',
                  style: TextStyle(
                    fontSize: 11,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Notification Bell + Badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => context.push('/account/notification-center'),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // More Options Menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (val) {
              if (val == 'export') _showExportDialog(context);
              if (val == 'import') _showImportDialog(context);
              if (val == 'refresh') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم تحديث قائمة الموظفين.')),
                );
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.download_rounded, size: 18),
                    SizedBox(width: 8),
                    Text('تصدير الموظفين (Excel/PDF)'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'import',
                child: Row(
                  children: [
                    Icon(Icons.upload_rounded, size: 18),
                    SizedBox(width: 8),
                    Text('استيراد بيانات موظفين'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'refresh',
                child: Row(
                  children: [
                    Icon(Icons.refresh_rounded, size: 18),
                    SizedBox(width: 8),
                    Text('تحديث البيانات'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تصدير بيانات الموظفين'),
        content: const Text('اختر صيغة الملف المراد تصديره:'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تصدير ملف Excel بنجاح!')),
              );
            },
            child: const Text('Excel (.xlsx)'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تصدير ملف PDF بنجاح!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('PDF Report'),
          ),
        ],
      ),
    );
  }

  void _showImportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('استيراد قائمة الموظفين'),
        content: const Text('قم برفع ملف Excel محتوي على أعمدة: الاسم، الوظيفة، القسم، الهاتف، البريد.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم استيراد البيانات بنجاح!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('رفع الملف'),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  2. Statistics Cards Row (1:1 design matching screenshot)
// ══════════════════════════════════════════════════════════════

class EmployeeStatsCards extends ConsumerWidget {
  const EmployeeStatsCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(employeesProvider);
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Row(
      children: [
        // Card 1: Total Employees
        _statCard(
          context,
          surface: surface,
          border: border,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          label: 'إجمالي الموظفين',
          value: '${state.totalEmployeesCount}',
          unit: 'موظف',
          icon: Icons.groups_outlined,
          iconColor: const Color(0xFF10B981),
          bgColor: isDark ? const Color(0xFF064E3B) : const Color(0xFFECFDF5),
        ),
        const SizedBox(width: 8),

        // Card 2: Active Employees
        _statCard(
          context,
          surface: surface,
          border: border,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          label: 'نشط',
          value: '${state.activeEmployeesCount}',
          unit: 'موظف',
          icon: Icons.person_outline_rounded,
          iconColor: const Color(0xFF2563EB),
          bgColor: isDark ? const Color(0xFF1E3A8A) : const Color(0xFFEFF6FF),
        ),
        const SizedBox(width: 8),

        // Card 3: On Leave Employees
        _statCard(
          context,
          surface: surface,
          border: border,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          label: 'في إجازة',
          value: '${state.onLeaveEmployeesCount}',
          unit: 'موظف',
          icon: Icons.access_time_rounded,
          iconColor: const Color(0xFFF59E0B),
          bgColor: isDark ? const Color(0xFF78350F) : const Color(0xFFFFFBEB),
        ),
        const SizedBox(width: 8),

        // Card 4: Inactive / Suspended
        _statCard(
          context,
          surface: surface,
          border: border,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          label: 'غير نشط',
          value: '${state.inactiveEmployeesCount}',
          unit: 'موظف',
          icon: Icons.person_off_outlined,
          iconColor: const Color(0xFFEF4444),
          bgColor: isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEF2F2),
        ),
      ],
    );
  }

  Widget _statCard(
    BuildContext context, {
    required Color surface,
    required Color border,
    required Color textPrimary,
    required Color textSecondary,
    required String label,
    required String value,
    required String unit,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Expanded(
      child: Material(
        color: surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.rLG,
          side: BorderSide(color: border),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          child: Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  color: textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 10,
                  color: textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  3. Quick Actions Row (3 buttons matching screenshot)
// ══════════════════════════════════════════════════════════════

class EmployeeQuickActions extends ConsumerWidget {
  final VoidCallback onAddEmployee;
  final VoidCallback onRoles;
  final VoidCallback onDepartments;

  const EmployeeQuickActions({
    super.key,
    required this.onAddEmployee,
    required this.onRoles,
    required this.onDepartments,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Row(
      children: [
        // Button 1: Add Employee (Primary Blue)
        Expanded(
          flex: 4,
          child: ElevatedButton.icon(
            onPressed: onAddEmployee,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
            ),
            icon: const Icon(Icons.add_rounded, size: 20),
            label: const Text(
              'إضافة موظف جديد',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Button 2: Roles & Permissions
        Expanded(
          flex: 4,
          child: OutlinedButton.icon(
            onPressed: onRoles,
            style: OutlinedButton.styleFrom(
              backgroundColor: surface,
              foregroundColor: AppColors.primary,
              side: BorderSide(color: border),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
            ),
            icon: const Icon(Icons.shield_outlined, size: 18),
            label: const Text(
              'الأدوار والصلاحيات',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Button 3: Departments
        Expanded(
          flex: 3,
          child: OutlinedButton.icon(
            onPressed: onDepartments,
            style: OutlinedButton.styleFrom(
              backgroundColor: surface,
              foregroundColor: AppColors.primary,
              side: BorderSide(color: border),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
            ),
            icon: const Icon(Icons.badge_outlined, size: 18),
            label: const Text(
              'الأقسام',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  4. Live Search & Filter Bar
// ══════════════════════════════════════════════════════════════

class EmployeeSearchAndFilters extends ConsumerWidget {
  const EmployeeSearchAndFilters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(employeesProvider);
    final notifier = ref.read(employeesProvider.notifier);

    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Column(
      children: [
        // Live Search TextField
        Material(
          color: surface,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.rMD,
            side: BorderSide(color: border),
          ),
          child: TextField(
            onChanged: (q) => notifier.setSearchQuery(q),
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 13, color: textPrimary),
            decoration: InputDecoration(
              hintText: 'ابحث عن موظف بالاسم، المسمى الوظيفي أو القسم...',
              hintStyle: TextStyle(fontSize: 12, color: textSecondary),
              prefixIcon: Icon(Icons.search_rounded, color: textSecondary),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Filter Pills Row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              // Filter Funnel Button
              OutlinedButton.icon(
                onPressed: () => _showFilterSheet(context, ref),
                style: OutlinedButton.styleFrom(
                  backgroundColor: surface,
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: border),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.rRound),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
                icon: const Icon(Icons.filter_list_rounded, size: 16),
                label: const Text('تصفية', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 6),

              // Status Dropdown Pill
              _filterDropdownPill(
                context,
                label: 'الحالة',
                value: state.selectedStatus,
                options: ['الكل', 'نشط', 'في إجازة', 'غير نشط', 'موقوف'],
                onSelect: (val) => notifier.setSelectedStatus(val),
              ),
              const SizedBox(width: 6),

              // Department Dropdown Pill
              _filterDropdownPill(
                context,
                label: 'القسم',
                value: state.selectedDepartment,
                options: [
                  'الكل',
                  'قسم المشتريات',
                  'قسم الإنتاج',
                  'قسم المالية',
                  'قسم المخازن',
                  'قسم الجودة',
                  'قسم الصيانة',
                  'الإدارة العليا',
                  'قسم المبيعات',
                ],
                onSelect: (val) => notifier.setSelectedDepartment(val),
              ),
              const SizedBox(width: 6),

              // Role Dropdown Pill
              _filterDropdownPill(
                context,
                label: 'الدور',
                value: state.selectedRole,
                options: [
                  'الكل',
                  'مالك المصنع',
                  'مدير المشتريات',
                  'محاسب',
                  'مشرف إنتاج',
                  'أخصائي جودة',
                  'مدير مخازن',
                ],
                onSelect: (val) => notifier.setSelectedRole(val),
              ),
              const SizedBox(width: 6),

              // Sort Pill
              OutlinedButton.icon(
                onPressed: () => _showSortOptions(context, ref),
                style: OutlinedButton.styleFrom(
                  backgroundColor: surface,
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: border),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.rRound),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
                icon: const Icon(Icons.swap_vert_rounded, size: 16),
                label: Text('ترتيب: ${state.sortOption}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _filterDropdownPill(
    BuildContext context, {
    required String label,
    required String value,
    required List<String> options,
    required ValueChanged<String> onSelect,
  }) {
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return PopupMenuButton<String>(
      onSelected: onSelect,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: AppRadius.rRound,
          border: Border.all(color: border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$label: $value',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textPrimary),
            ),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: textPrimary),
          ],
        ),
      ),
      itemBuilder: (_) => options
          .map((opt) => PopupMenuItem(
                value: opt,
                child: Text(opt, style: const TextStyle(fontSize: 12)),
              ))
          .toList(),
    );
  }

  void _showSortOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ترتيب القائمة حسب', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            ListTile(
              title: const Text('الأحدث (الافتراضي)'),
              trailing: const Icon(Icons.check_rounded, color: AppColors.primary),
              onTap: () {
                ref.read(employeesProvider.notifier).setSortOption('أحدث');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('الأقدم'),
              onTap: () {
                ref.read(employeesProvider.notifier).setSortOption('أقدم');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('الاسم أبجدياً'),
              onTap: () {
                ref.read(employeesProvider.notifier).setSortOption('الاسم');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('القسم'),
              onTap: () {
                ref.read(employeesProvider.notifier).setSortOption('القسم');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('تصفية نتائج البحث', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                TextButton(
                  onPressed: () {
                    final notifier = ref.read(employeesProvider.notifier);
                    notifier.setSelectedRole('الكل');
                    notifier.setSelectedDepartment('الكل');
                    notifier.setSelectedStatus('الكل');
                    Navigator.pop(context);
                  },
                  child: const Text('إعادة ضبط'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('تطبيق التصفية', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  5. Employee Card (Pixel-perfect matching screenshot)
// ══════════════════════════════════════════════════════════════

class EmployeeCardWidget extends StatelessWidget {
  final EmployeeEntity employee;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onAssignRole;
  final VoidCallback onAssignDept;
  final VoidCallback onResetPassword;
  final VoidCallback onSuspend;
  final VoidCallback onDelete;

  const EmployeeCardWidget({
    super.key,
    required this.employee,
    required this.onTap,
    required this.onEdit,
    required this.onAssignRole,
    required this.onAssignDept,
    required this.onResetPassword,
    required this.onSuspend,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    Color statusColor;
    String statusText;
    switch (employee.status) {
      case EmployeeStatus.active:
        statusColor = const Color(0xFF10B981);
        statusText = 'نشط ${employee.permissionsCount}';
      case EmployeeStatus.onLeave:
        statusColor = const Color(0xFFF59E0B);
        statusText = 'في إجازة ${employee.leaveReturnDate != null ? 'حتى ${employee.leaveReturnDate}' : ''}';
      case EmployeeStatus.inactive:
        statusColor = const Color(0xFFEF4444);
        statusText = 'غير نشط';
      case EmployeeStatus.suspended:
        statusColor = const Color(0xFFEF4444);
        statusText = 'موقوف';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: AppRadius.rLG,
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.rLG,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.rLG,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Right (RTL): Avatar Photo
                ClipOval(
                  child: Image.network(
                    employee.photoUrl,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, _) => Container(
                      width: 52,
                      height: 52,
                      color: AppColors.primary.withValues(alpha: 0.1),
                      child: const Icon(Icons.person_rounded, color: AppColors.primary, size: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Middle: Job Title, Name, ID & Department
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.jobTitle,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        employee.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${employee.department}  •  ID: ${employee.id}',
                        style: TextStyle(
                          fontSize: 10,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Left (RTL): Status pill, Last Login, Three-dots menu
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.more_vert_rounded, color: textSecondary, size: 20),
                          onSelected: (val) {
                            if (val == 'view') onTap();
                            if (val == 'edit') onEdit();
                            if (val == 'role') onAssignRole();
                            if (val == 'dept') onAssignDept();
                            if (val == 'reset') onResetPassword();
                            if (val == 'suspend') onSuspend();
                            if (val == 'delete') onDelete();
                          },
                          itemBuilder: (_) => [
                            const PopupMenuItem(value: 'view', child: Text('عرض الملف الشامل')),
                            const PopupMenuItem(value: 'edit', child: Text('تعديل البيانات')),
                            const PopupMenuItem(value: 'role', child: Text('تعيين دور جديد')),
                            const PopupMenuItem(value: 'dept', child: Text('تعيين قسم')),
                            const PopupMenuItem(value: 'reset', child: Text('إعادة ضبط كلمة المرور')),
                            PopupMenuItem(
                              value: 'suspend',
                              child: Text(
                                employee.status == EmployeeStatus.suspended ? 'تفعيل الحساب' : 'تجميد الحساب',
                                style: const TextStyle(color: AppColors.warning),
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('حذف الموظف', style: TextStyle(color: AppColors.error)),
                            ),
                          ],
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'آخر تسجيل دخول',
                      style: TextStyle(fontSize: 9, color: textSecondary),
                    ),
                    Text(
                      employee.lastLogin,
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textPrimary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  6. Pagination Bar (1:1 design matching screenshot)
// ══════════════════════════════════════════════════════════════

class EmployeePaginationBar extends ConsumerWidget {
  const EmployeePaginationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(employeesProvider);
    final notifier = ref.read(employeesProvider.notifier);

    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Previous Button
        InkWell(
          onTap: state.currentPage > 1 ? () => notifier.setPage(state.currentPage - 1) : null,
          borderRadius: AppRadius.rSM,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: AppRadius.rSM,
              border: Border.all(color: border),
            ),
            child: Icon(
              Icons.chevron_right_rounded, // RTL previous arrow
              size: 18,
              color: state.currentPage > 1 ? textPrimary : textSecondary.withValues(alpha: 0.4),
            ),
          ),
        ),

        // Page Numbers
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int p = 1; p <= state.totalPages && p <= 5; p++) ...[
              GestureDetector(
                onTap: () => notifier.setPage(p),
                child: Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: state.currentPage == p ? AppColors.primary : surface,
                    borderRadius: AppRadius.rSM,
                    border: Border.all(
                      color: state.currentPage == p ? AppColors.primary : border,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$p',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: state.currentPage == p ? Colors.white : textPrimary,
                    ),
                  ),
                ),
              ),
            ],
            if (state.totalPages > 5) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text('...', style: TextStyle(color: textSecondary, fontWeight: FontWeight.bold)),
              ),
              GestureDetector(
                onTap: () => notifier.setPage(state.totalPages),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: state.currentPage == state.totalPages ? AppColors.primary : surface,
                    borderRadius: AppRadius.rSM,
                    border: Border.all(
                      color: state.currentPage == state.totalPages ? AppColors.primary : border,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${state.totalPages}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: state.currentPage == state.totalPages ? Colors.white : textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),

        // Next Button
        InkWell(
          onTap: state.currentPage < state.totalPages ? () => notifier.setPage(state.currentPage + 1) : null,
          borderRadius: AppRadius.rSM,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: AppRadius.rSM,
              border: Border.all(color: border),
            ),
            child: Icon(
              Icons.chevron_left_rounded, // RTL next arrow
              size: 18,
              color: state.currentPage < state.totalPages ? textPrimary : textSecondary.withValues(alpha: 0.4),
            ),
          ),
        ),

        // Items per page dropdown
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PopupMenuButton<int>(
              onSelected: (val) => notifier.setItemsPerPage(val),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: AppRadius.rSM,
                  border: Border.all(color: border),
                ),
                child: Row(
                  children: [
                    Text('${state.itemsPerPage}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textPrimary)),
                    const SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: textPrimary),
                  ],
                ),
              ),
              itemBuilder: (_) => const [
                PopupMenuItem(value: 5, child: Text('5')),
                PopupMenuItem(value: 10, child: Text('10')),
                PopupMenuItem(value: 20, child: Text('20')),
              ],
            ),
            const SizedBox(width: 6),
            Text('عدد في الصفحة', style: TextStyle(fontSize: 10, color: textSecondary)),
          ],
        ),
      ],
    );
  }
}


