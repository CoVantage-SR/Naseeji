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
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AppSpacing.hLG,
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.factory_rounded, size: 50, color: Colors.white),
            ),
            AppSpacing.hMD,
            Text(
              'مصنع نسيج النيل للغزل والنسيج',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.hXS,
            Text(
              'سجل تجاري رقم: ٤٨٧٢٦١٩',
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
            AppSpacing.hXL,
            _buildListTile(context, 'بيانات المصنع الأساسية', Icons.info_outline_rounded, () {}),
            _buildListTile(context, 'المستندات القانونية والتراخيص', Icons.document_scanner_outlined, () {}),
            _buildListTile(context, 'إدارة الموظفين والصلحيات', Icons.people_outline_rounded, () {}),
            _buildListTile(context, 'تفاصيل الحساب البنكي', Icons.account_balance_outlined, () {}),
            _buildListTile(context, 'الدعم الفني والمساعدة', Icons.support_agent_rounded, () {}),
            AppSpacing.hLG,
            _buildListTile(context, 'تسجيل الخروج', Icons.logout_rounded, () => context.go('/login'), isDestructive: true),
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
    final color = isDestructive ? AppColors.error : AppColors.textPrimaryLight;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: context.textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: color.withOpacity(0.5),
        ),
      ),
    );
  }
}
