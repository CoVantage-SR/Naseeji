// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import 'package:naseeji_factory/supplier/core/theme/theme_controller.dart';
import 'package:naseeji_factory/supplier/features/profile/domain/entities/supplier_profile.dart';

class SettingsTabView extends ConsumerWidget {
  final SupplierProfile profile;

  const SettingsTabView({super.key, required this.profile});

  void _showAppearanceBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final currentMode = ref.watch(themeControllerProvider);
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'المظهر وشكل التطبيق',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(height: 1),
              RadioListTile<ThemeMode>(
                value: ThemeMode.light,
                groupValue: currentMode,
                title: const Text('☀ فاتح', textAlign: TextAlign.right),
                onChanged: (mode) {
                  if (mode != null) {
                    ref.read(themeControllerProvider.notifier).setThemeMode(mode);
                    Navigator.pop(ctx);
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.dark,
                groupValue: currentMode,
                title: const Text('🌙 داكن', textAlign: TextAlign.right),
                onChanged: (mode) {
                  if (mode != null) {
                    ref.read(themeControllerProvider.notifier).setThemeMode(mode);
                    Navigator.pop(ctx);
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.system,
                groupValue: currentMode,
                title: const Text('📱 حسب إعدادات الجهاز', textAlign: TextAlign.right),
                onChanged: (mode) {
                  if (mode != null) {
                    ref.read(themeControllerProvider.notifier).setThemeMode(mode);
                    Navigator.pop(ctx);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          title: const Text('تغيير كلمة المرور (الباسورد)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.end),
          leading: const Icon(Icons.lock_outline, color: AppColors.outline),
          onTap: () {},
        ),
        ListTile(
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          title: const Text('المظهر وشكل التطبيق', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.end),
          leading: const Icon(Icons.brightness_medium_outlined, color: AppColors.outline),
          onTap: () => _showAppearanceBottomSheet(context, ref),
        ),
        ListTile(
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          title: const Text('الأجهزة المتصلة والأمان', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.end),
          leading: const Icon(Icons.devices_outlined, color: AppColors.outline),
          onTap: () {},
        ),
        ListTile(
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          title: const Text('تسجيل الخروج من الحساب', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.error), textAlign: TextAlign.end),
          leading: const Icon(Icons.logout, color: AppColors.error),
          onTap: () {},
        ),
      ],
    );
  }
}

