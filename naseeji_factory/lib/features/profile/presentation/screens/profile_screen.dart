import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي للمصنع'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            tooltip: 'الإعدادات',
            onPressed: () => context.push('/account/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AppSpacing.hSM,
            // Profile card preview
            GestureDetector(
              onTap: () => context.push('/account/profile'),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 64, height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      child: const Icon(Icons.factory_rounded, size: 36, color: Colors.white),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('مصنع نسيجي للصناعات النسيجية',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.verified_rounded, color: Colors.white70, size: 14),
                              const SizedBox(width: 4),
                              Text('حساب موثق', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 11)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                            child: const Text('PRO', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 16),
                  ],
                ),
              ),
            ),
            AppSpacing.hMD,
            _buildListTile(context, 'ملف المصنع الكامل', Icons.business_rounded,
                () => context.push('/account/profile')),
            _buildListTile(context, 'تعديل بيانات المصنع', Icons.edit_rounded,
                () => context.push('/account/profile/edit')),
            _buildListTile(context, 'إدارة الموظفين والصلاحيات', Icons.people_rounded,
                () => context.push('/account/employees')),
            _buildListTile(context, 'الإعدادات العامة والأمان', Icons.settings_rounded,
                () => context.push('/account/settings')),
            _buildListTile(context, 'إعدادات الإشعارات', Icons.notifications_rounded,
                () => context.push('/account/notifications')),
            _buildListTile(context, 'المظهر والثيم', Icons.palette_rounded,
                () => context.push('/account/appearance')),
            _buildListTile(context, 'الشروط والأحكام', Icons.gavel_rounded,
                () => context.push('/account/terms')),
            _buildListTile(context, 'سياسة الخصوصية', Icons.privacy_tip_rounded,
                () => context.push('/account/privacy')),
            AppSpacing.hMD,
            _buildListTile(context, 'تسجيل الخروج', Icons.logout_rounded,
                () => context.go('/login'), isDestructive: true),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    final color = isDestructive ? AppColors.error : AppColors.primary;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: color.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDestructive ? AppColors.error : null,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: color.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
