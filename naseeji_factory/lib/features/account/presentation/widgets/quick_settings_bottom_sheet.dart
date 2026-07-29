import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';

class QuickSettingsBottomSheet extends StatelessWidget {
  const QuickSettingsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: border,
                borderRadius: AppRadius.rRound,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الإعدادات السريعة',
                style: TextStyle(
                  color: textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          _itemTile(
            context,
            icon: Icons.palette_outlined,
            title: 'المظهر والثيم',
            subtitle: 'فاتح / داكن / AMOLED',
            onTap: () {
              Navigator.pop(context);
              context.push('/account/appearance');
            },
          ),
          _itemTile(
            context,
            icon: Icons.language_rounded,
            title: 'اللغة',
            subtitle: 'العربية / English',
            onTap: () {
              Navigator.pop(context);
              context.push('/account/language');
            },
          ),
          _itemTile(
            context,
            icon: Icons.notifications_none_rounded,
            title: 'الإشعارات والتنبيهات',
            subtitle: 'إدارة أسلوب وقنوات التنبيه',
            onTap: () {
              Navigator.pop(context);
              context.push('/account/notifications');
            },
          ),
          _itemTile(
            context,
            icon: Icons.shield_outlined,
            title: 'الأمان والحساب',
            subtitle: 'كلمة المرور والبصمة والدخول',
            onTap: () {
              Navigator.pop(context);
              context.push('/account/security');
            },
          ),
          _itemTile(
            context,
            icon: Icons.card_membership_rounded,
            title: 'الاشتراك والفواتير',
            subtitle: 'تفاصيل الباقة وتاريخ الفواتير',
            onTap: () {
              Navigator.pop(context);
              context.push('/account/subscription');
            },
          ),
          _itemTile(
            context,
            icon: Icons.headset_mic_outlined,
            title: 'الدعم الفني والدردشة المباشرة',
            subtitle: 'فتح تذكرة دعم أو مراسلة الواتساب',
            onTap: () {
              Navigator.pop(context);
              context.push('/account/support');
            },
          ),
          _itemTile(
            context,
            icon: Icons.help_outline_rounded,
            title: 'مركز المساعدة والأسئلة الشائعة',
            subtitle: 'الدروس والوثائق والحلول',
            onTap: () {
              Navigator.pop(context);
              context.push('/account/help');
            },
          ),
          _itemTile(
            context,
            icon: Icons.info_outline_rounded,
            title: 'عن تطبيق نسيجي',
            subtitle: 'الإصدار والشروط ورخص المكتبات',
            onTap: () {
              Navigator.pop(context);
              context.push('/account/about');
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _itemTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isDark = context.theme.brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: AppRadius.rSM,
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title, style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(subtitle, style: TextStyle(color: textSecondary, fontSize: 11)),
      trailing: const Icon(Icons.chevron_left_rounded, size: 20),
      onTap: onTap,
    );
  }
}
