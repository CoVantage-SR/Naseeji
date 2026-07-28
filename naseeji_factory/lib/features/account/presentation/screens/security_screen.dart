import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/account_provider.dart';

class SecurityScreen extends ConsumerWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final security = ref.watch(securityNotifierProvider);
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الأمان والحساب'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: AppRadius.rLG,
              border: Border.all(color: border),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.lock_outline_rounded, color: AppColors.primary),
                  title: Text('كلمة المرور', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold)),
                  subtitle: Text('آخر تغيير: ${security.lastPasswordChange}'),
                  trailing: const Icon(Icons.chevron_left_rounded),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تغيير كلمة المرور')),
                    );
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.fingerprint_rounded, color: AppColors.primary),
                  title: Text('البصمة / الوجه', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold)),
                  subtitle: const Text('تسجيل الدخول السريع باستخدام البيومترية'),
                  value: security.biometricEnabled,
                  onChanged: (val) {
                    ref.read(securityNotifierProvider.notifier).toggleBiometric(val);
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.security_rounded, color: AppColors.primary),
                  title: Text('المصادقة الثنائية (2FA)', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold)),
                  subtitle: const Text('إرسال رمز التحقق إلى الهاتف عند الدخول'),
                  value: security.twoFactorEnabled,
                  onChanged: (val) {
                    ref.read(securityNotifierProvider.notifier).toggleTwoFactor(val);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: AppRadius.rLG,
              border: Border.all(color: border),
            ),
            child: ListTile(
              leading: const Icon(Icons.devices_rounded, color: AppColors.primary),
              title: Text('الأجهزة الموثوقة', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold)),
              subtitle: Text('${security.trustedDevicesCount} أجهزة نشطة حالياً'),
              trailing: const Icon(Icons.chevron_left_rounded),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
