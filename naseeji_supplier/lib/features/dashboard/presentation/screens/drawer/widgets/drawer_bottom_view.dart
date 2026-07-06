import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/session/session_tracker.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class DrawerBottomView extends ConsumerWidget {
  const DrawerBottomView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            // Night mode toggle
            ListTile(
              leading: const Icon(Icons.dark_mode_outlined, color: AppColors.onSurfaceVariant),
              title: const Text('الوضع الليلي', style: TextStyle(fontSize: 13)),
              trailing: Switch(
                value: false,
                onChanged: (val) {},
                activeThumbColor: AppColors.primary,
              ),
            ),
            // Language selector
            const ListTile(
              leading: Icon(Icons.language, color: AppColors.onSurfaceVariant),
              title: Text('اللغة', style: TextStyle(fontSize: 13)),
              trailing: Text(
                'العربية (SAR)',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Logout Button
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.error),
              title: const Text(
                'تسجيل الخروج',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              onTap: () {
                ref.read(sessionTrackerProvider.notifier).endSession();
                context.go('/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
