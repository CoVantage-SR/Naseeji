import 'package:flutter/material.dart';
import 'package:naseeji_factory/factory/core/constants/app_colors.dart';
import '../account_reusable_widgets.dart';

class LogoutWidget extends StatelessWidget {
  final VoidCallback onLogout;
  const LogoutWidget({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: SettingTile(
        icon: Icons.logout_rounded,
        title: 'تسجيل الخروج',
        isDestructive: true,
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.error),
        onTap: onLogout,
      ),
    );
  }
}
