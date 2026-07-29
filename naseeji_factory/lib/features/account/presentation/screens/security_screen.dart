import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/account_provider.dart';
import '../widgets/account_dialogs.dart';

class SecurityScreen extends ConsumerStatefulWidget {
  const SecurityScreen({super.key});

  @override
  ConsumerState<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends ConsumerState<SecurityScreen> {
  bool _pinLockEnabled = false;

  @override
  Widget build(BuildContext context) {
    final security = ref.watch(securityNotifierProvider);
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الأمان والحساب'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Section 1: Security & Credentials
          Text('إعدادات الدخول والحماية', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
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
                  title: Text('تغيير كلمة المرور', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('آخر تغيير: ${security.lastPasswordChange}', style: TextStyle(color: textSecondary, fontSize: 11)),
                  trailing: const Icon(Icons.chevron_left_rounded),
                  onTap: () => _showChangePasswordDialog(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.phone_iphone_rounded, color: AppColors.primary),
                  title: Text('تغيير رقم الهاتف', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('+20 10 **** 5678', style: TextStyle(color: textSecondary, fontSize: 11)),
                  trailing: const Icon(Icons.chevron_left_rounded),
                  onTap: () => _showChangePhoneDialog(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.email_outlined, color: AppColors.primary),
                  title: Text('تغيير البريد الإلكتروني', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('info@naseeji.com', style: TextStyle(color: textSecondary, fontSize: 11)),
                  trailing: const Icon(Icons.chevron_left_rounded),
                  onTap: () => _showChangeEmailDialog(context),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.security_rounded, color: AppColors.primary),
                  title: Text('المصادقة الثنائية (2FA)', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: const Text('إرسال رمز التحقق إلى الهاتف عند الدخول', style: TextStyle(fontSize: 11)),
                  value: security.twoFactorEnabled,
                  onChanged: (val) {
                    ref.read(securityNotifierProvider.notifier).toggleTwoFactor(val);
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.pin_rounded, color: AppColors.primary),
                  title: Text('قفل التطبيق برمز PIN', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: const Text('طلب رمز PIN مكون من 4 أرقام عند فتح التطبيق', style: TextStyle(fontSize: 11)),
                  value: _pinLockEnabled,
                  onChanged: (val) {
                    setState(() => _pinLockEnabled = val);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(val ? 'تم تفعيل قفل PIN.' : 'تم إيقاف قفل PIN.')),
                    );
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.fingerprint_rounded, color: AppColors.primary),
                  title: Text('البصمة / Face ID', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: const Text('تسجيل الدخول السريع باستخدام الوجه أو البصمة', style: TextStyle(fontSize: 11)),
                  value: security.biometricEnabled,
                  onChanged: (val) {
                    ref.read(securityNotifierProvider.notifier).toggleBiometric(val);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Section 2: Sessions & Devices
          Text('الأجهزة وجلسات الدخول', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: AppRadius.rLG,
              border: Border.all(color: border),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.devices_rounded, color: AppColors.primary),
                  title: Text('الأجهزة الموثوقة والجلسات النشطة', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('${security.trustedDevicesCount} أجهزة نشطة حالياً', style: TextStyle(color: textSecondary, fontSize: 11)),
                  trailing: const Icon(Icons.chevron_left_rounded),
                  onTap: () => _showSessionsModal(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.history_toggle_off_rounded, color: AppColors.primary),
                  title: Text('سجل عمليات تسجيل الدخول', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: const Text('عرض التواريخ والأجهزة والعناوين IP', style: TextStyle(fontSize: 11)),
                  trailing: const Icon(Icons.chevron_left_rounded),
                  onTap: () => _showLoginHistoryModal(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.phonelink_erase_rounded, color: AppColors.warning),
                  title: const Text('تسجيل الخروج من كافة الأجهزة الأخرى', style: TextStyle(color: AppColors.warning, fontWeight: FontWeight.bold, fontSize: 13)),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم إنهاء جميع الجلسات الفعالة من الأجهزة الأخرى.')),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Section 3: Account Control & Deletion
          Text('إدارة وإلغاء الحساب', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: AppRadius.rLG,
              border: Border.all(color: border),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.pause_circle_outline_rounded, color: AppColors.warning),
                  title: const Text('تعليق الحساب مؤقتاً', style: TextStyle(color: AppColors.warning, fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: const Text('إيقاف ظهور المصنع دون حذف البيانات', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => DeactivateAccountDialog(
                        onConfirm: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم تجميد حساب المصنع مؤقتاً.')),
                          );
                        },
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.delete_forever_rounded, color: AppColors.error),
                  title: const Text('حذف الحساب نهائياً', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: const Text('حذف كامل بيانات ومستندات المصنع', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => DeleteAccountDialog(
                        onConfirm: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم تقديم طلب حذف الحساب نهائياً.')),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تغيير كلمة المرور'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(obscureText: true, decoration: InputDecoration(labelText: 'كلمة المرور الحالية')),
            SizedBox(height: 10),
            TextField(obscureText: true, decoration: InputDecoration(labelText: 'كلمة المرور الجديدة')),
            SizedBox(height: 10),
            TextField(obscureText: true, decoration: InputDecoration(labelText: 'تأكيد كلمة المرور الجديدة')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تغيير كلمة المرور بنجاح!')),
              );
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _showChangePhoneDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تغيير رقم الهاتف'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: 'رقم الهاتف الجديد')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إرسال رمز OTP لتأكيد الرقم الجديد.')),
              );
            },
            child: const Text('إرسال رمز التأكيد'),
          ),
        ],
      ),
    );
  }

  void _showChangeEmailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تغيير البريد الإلكتروني'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(keyboardType: TextInputType.emailAddress, decoration: InputDecoration(labelText: 'البريد الإلكتروني الجديد')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إرسال رابط التفعيل للبريد الجديد.')),
              );
            },
            child: const Text('حفظ وتأكيد'),
          ),
        ],
      ),
    );
  }

  void _showSessionsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('الجلسات والأجهزة المفتوحة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.phone_android_rounded, color: AppColors.primary),
              title: const Text('Samsung Galaxy S24 Ultra (هذا الجهاز)'),
              subtitle: const Text('القاهرة، مصر • 197.38.12.44 • الآن'),
              trailing: const Text('نشط', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 11)),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.laptop_mac_rounded, color: AppColors.primary),
              title: const Text('MacBook Pro 16"'),
              subtitle: const Text('المحلة الكبرى، مصر • 156.204.89.12 • منذ 3 ساعات'),
              trailing: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم إنهاء الجلسة.')),
                  );
                },
                child: const Text('إنهاء', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLoginHistoryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('سجل عمليات الدخول الأخيرة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 12),
            ListTile(
              leading: Icon(Icons.check_circle_rounded, color: AppColors.success),
              title: Text('دخول ناجح من Galaxy S24'),
              subtitle: Text('2026/07/29 - 14:22 • IP: 197.38.12.44'),
            ),
            Divider(height: 1),
            ListTile(
              leading: Icon(Icons.check_circle_rounded, color: AppColors.success),
              title: Text('دخول ناجح من MacBook Pro'),
              subtitle: Text('2026/07/28 - 09:15 • IP: 156.204.89.12'),
            ),
          ],
        ),
      ),
    );
  }
}
