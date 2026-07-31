// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/employee_entities.dart';
import '../providers/employees_provider.dart';

class EmployeeDetailsScreen extends ConsumerWidget {
  final String employeeId;

  const EmployeeDetailsScreen({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(employeesProvider);
    final repo = ref.watch(employeesRepositoryProvider);

    final employee = state.allEmployees.firstWhere(
      (e) => e.id == employeeId,
      orElse: () => EmployeeEntity(
        id: employeeId,
        name: 'غير معروف',
        jobTitle: 'موظف',
        department: 'قسم المشتريات',
        role: 'viewer',
        phone: '',
        email: '',
        photoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
        status: EmployeeStatus.active,
        joiningDate: '-',
        employmentType: 'دوام كامل',
        lastLogin: '-',
        lastActivity: '-',
        permissionsCount: 0,
        permissions: const {},
        managerName: 'مصطفى النجار',
      ),
    );

    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      appBar: AppBar(
        title: Text('ملف الموظف (${employee.id})'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _showEditSheet(context, ref, employee),
            tooltip: 'تعديل البيانات',
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          children: [
            // Header Profile Card
            Material(
              color: surface,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.rLG,
                side: BorderSide(color: border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipOval(
                          child: Image.network(
                            employee.photoUrl,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, _) => Container(
                              width: 64,
                              height: 64,
                              color: AppColors.primary.withValues(alpha: 0.1),
                              child: const Icon(Icons.person_rounded, color: AppColors.primary, size: 36),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                employee.name,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${employee.jobTitle}  •  ${employee.department}',
                                style: const TextStyle(fontSize: 12, color: Color(0xFF2563EB), fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: employee.status == EmployeeStatus.active
                                          ? const Color(0xFF10B981)
                                          : const Color(0xFFF59E0B),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    employee.status.label,
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textSecondary),
                                  ),
                                  const SizedBox(width: 10),
                                  Text('تاريخ الانضمام: ${employee.joiningDate}', style: TextStyle(fontSize: 10, color: textSecondary)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Quick Actions Grid
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _showEditSheet(context, ref, employee),
                  icon: const Icon(Icons.edit_rounded, size: 16),
                  label: const Text('تعديل البيانات'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    ref.read(employeesProvider.notifier).resetPassword(employee.id, 'Naseeji@2026');
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إعادة ضبط كلمة المرور إلى Naseeji@2026')));
                  },
                  icon: const Icon(Icons.lock_reset_rounded, size: 16),
                  label: const Text('إعادة ضبط كلمة المرور'),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    ref.read(employeesProvider.notifier).suspendEmployee(employee.id, 'تجميد بواسطة المدير');
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تغيير حالة الحساب.')));
                  },
                  icon: const Icon(Icons.pause_circle_outline_rounded, size: 16),
                  label: Text(employee.status == EmployeeStatus.suspended ? 'إلغاء التجميد' : 'تجميد الحساب'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Information Section
            Text('معلومات الموظف والاتصال', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textPrimary)),
            const SizedBox(height: 8),
            Material(
              color: surface,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.rLG, side: BorderSide(color: border)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    _infoRow(Icons.phone_rounded, 'رقم الهاتف', employee.phone, textPrimary),
                    const Divider(height: 16),
                    _infoRow(Icons.email_rounded, 'البريد الإلكتروني', employee.email, textPrimary),
                    const Divider(height: 16),
                    _infoRow(Icons.badge_rounded, 'الرقم القومي', employee.nationalId, textPrimary),
                    const Divider(height: 16),
                    _infoRow(Icons.person_outline_rounded, 'المدير المباشر', employee.managerName, textPrimary),
                    const Divider(height: 16),
                    _infoRow(Icons.attach_money_rounded, 'الراتب الأساسي', '${employee.salary.toInt()} ج.م / شهرياً', textPrimary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Attendance & Performance Card
            Text('سجل الحضور والنشاط', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textPrimary)),
            const SizedBox(height: 8),
            FutureBuilder<AttendanceEntity?>(
              future: repo.getEmployeeAttendance(employee.id),
              builder: (context, snapshot) {
                final att = snapshot.data;
                return Material(
                  color: surface,
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.rLG, side: BorderSide(color: border)),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('ساعات العمل هذا الشهر:', style: TextStyle(fontSize: 12, color: textSecondary)),
                            Text('${att?.workingHoursThisMonth ?? 168} ساعة', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textPrimary)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('رصيد الإجازات المتبقي:', style: TextStyle(fontSize: 12, color: textSecondary)),
                            Text('${att?.leaveBalanceDays ?? 21} يوم', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.success)),
                          ],
                        ),
                        const Divider(height: 16),
                        const Text('سجل الحضور الأخير:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        ...((att?.history ?? []).map((h) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text('• $h', style: TextStyle(fontSize: 11, color: textSecondary)),
                            ))),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Assigned Work Card
            Text('المهام والأنشطة المسندة', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textPrimary)),
            const SizedBox(height: 8),
            FutureBuilder<AssignedWorkEntity?>(
              future: repo.getEmployeeAssignedWork(employee.id),
              builder: (context, snapshot) {
                final work = snapshot.data;
                return Material(
                  color: surface,
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.rLG, side: BorderSide(color: border)),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('عروض الأسعار المسندة (RFQs):', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ...?work?.assignedRFQs.map((r) => ListTile(
                              dense: true,
                              leading: const Icon(Icons.request_quote_outlined, color: AppColors.primary, size: 18),
                              title: Text(r, style: const TextStyle(fontSize: 12)),
                            )),
                        const Divider(height: 12),
                        const Text('المهام والأنشطة الإدارية:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ...?work?.assignedTasks.map((t) => ListTile(
                              dense: true,
                              leading: const Icon(Icons.check_circle_outline_rounded, color: AppColors.success, size: 18),
                              title: Text(t, style: const TextStyle(fontSize: 12)),
                            )),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, Color textPrimary) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const Spacer(),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textPrimary)),
      ],
    );
  }

  void _showEditSheet(BuildContext context, WidgetRef ref, EmployeeEntity emp) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20, top: 20, left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('تعديل بيانات ${emp.name}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              TextFormField(initialValue: emp.name, decoration: const InputDecoration(labelText: 'الاسم')),
              const SizedBox(height: 10),
              TextFormField(initialValue: emp.jobTitle, decoration: const InputDecoration(labelText: 'الوظيفة')),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, minimumSize: const Size(double.infinity, 44)),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ التعديلات بنجاح!')));
                },
                child: const Text('حفظ', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



