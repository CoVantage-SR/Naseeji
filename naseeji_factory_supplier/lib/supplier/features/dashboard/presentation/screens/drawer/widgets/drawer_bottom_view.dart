import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/core/session/session_tracker.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import 'package:naseeji_factory/core/theme/theme_controller.dart';
import 'package:naseeji_factory/authentication/presentation/controllers/auth_controller.dart';

class DrawerBottomView extends ConsumerWidget {
  const DrawerBottomView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);
    final isDark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            // Night mode toggle (Egyptian Arabic label)
            ListTile(
              leading: Icon(Icons.dark_mode_outlined, color: AppColors.onSurfaceVariant),
              title: Text('الوضع الداكن', style: TextStyle(fontSize: 13)),
              trailing: Switch(
                value: isDark,
                onChanged: (val) {
                  ref.read(themeControllerProvider.notifier).setThemeMode(
                        val ? ThemeMode.dark : ThemeMode.light,
                      );
                },
                activeThumbColor: AppColors.primary,
              ),
            ),
            // Logout Button
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.error),
              title: Text(
                'تسجيل الخروج',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              onTap: () {
                ref.read(sessionTrackerProvider.notifier).endSession();
                ref.read(authControllerProvider.notifier).logout();
                context.go('/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}

