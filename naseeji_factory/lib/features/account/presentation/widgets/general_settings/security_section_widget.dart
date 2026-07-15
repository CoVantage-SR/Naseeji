import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/constants/app_colors.dart';
import '../account_reusable_widgets.dart';

class SecuritySectionWidget extends StatelessWidget {
  const SecuritySectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          SettingTile(
            icon: Icons.devices_rounded,
            title: 'الأجهزة المتصلة',
            subtitle: '٣ أجهزة نشطة',
            onTap: () {},
          ),
          const Divider(height: 0, indent: 60),
          SettingTile(
            icon: Icons.logout_rounded,
            title: 'تسجيل الخروج من جميع الأجهزة',
            iconColor: AppColors.warning,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تسجيل الخروج من جميع الأجهزة.')),
              );
            },
          ),
          const Divider(height: 0, indent: 60),
          SettingTile(
            icon: Icons.fingerprint_rounded,
            title: 'تسجيل الدخول البيومتري',
            subtitle: 'قريباً',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
              child: const Text('قريباً', style: TextStyle(fontSize: 10, color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }
}
