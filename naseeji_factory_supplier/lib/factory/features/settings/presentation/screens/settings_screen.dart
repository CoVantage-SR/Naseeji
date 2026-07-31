import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
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
            _buildSettingTile(
              context,
              'إعدادات الحساب والأمان',
              Icons.lock_outline_rounded,
              'كلمة المرور، رقم الهاتف، البريد الإلكتروني',
              () => context.push('/account/settings'),
            ),
            _buildSettingTile(
              context,
              'إعدادات الإشعارات',
              Icons.notifications_none_rounded,
              'الطلبات، عروض الأسعار، الرسائل',
              () => context.push('/account/notifications'),
            ),
            _buildSettingTile(
              context,
              'المظهر والثيم',
              Icons.dark_mode_outlined,
              'فاتح، داكن، متابعة الجهاز',
              () => context.push('/account/appearance'),
            ),
            _buildSettingTile(
              context,
              'الشروط والأحكام',
              Icons.gavel_rounded,
              'قراءة وقبول الشروط',
              () => context.push('/account/terms'),
            ),
            _buildSettingTile(
              context,
              'سياسة الخصوصية',
              Icons.privacy_tip_outlined,
              'كيفية استخدام بياناتك',
              () => context.push('/account/privacy'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context,
    String title,
    IconData icon,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(
          title,
          style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryLight)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondaryLight),
      ),
    );
  }
}



