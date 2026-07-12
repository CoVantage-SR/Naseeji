import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSettingTile(context, 'إعدادات الحساب والأمان', Icons.lock_outline_rounded, () {}),
            _buildSettingTile(context, 'إعدادات الإشعارات والتنبيهات', Icons.notifications_none_rounded, () {}),
            _buildSettingTile(context, 'إعدادات المظهر', Icons.dark_mode_outlined, () {}),
            _buildSettingTile(context, 'عن التطبيق والشروط والأحكام', Icons.info_outline_rounded, () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: const Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: AppColors.textSecondaryLight,
        ),
      ),
    );
  }
}
