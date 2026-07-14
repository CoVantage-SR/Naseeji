import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/account_provider.dart';
import '../widgets/account_reusable_widgets.dart';

class GeneralSettingsScreen extends ConsumerWidget {
  const GeneralSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات العامة'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account Section
              const SectionHeader(title: 'الحساب'),
              _AccountSectionWidget(),
              AppSpacing.hSM,

              // Security Section
              const SectionHeader(title: 'الأمان'),
              _SecuritySectionWidget(),
              AppSpacing.hSM,

              // Application Section
              const SectionHeader(title: 'التطبيق'),
              _ApplicationSectionWidget(settings: settings, notifier: notifier),
              AppSpacing.hSM,

              // Data Section
              const SectionHeader(title: 'البيانات'),
              _DataSectionWidget(),
              AppSpacing.hSM,

              // Logout
              const SectionHeader(title: ''),
              _LogoutWidget(onLogout: () => context.go('/login')),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Account Section Widget ────────────────────────────────────────────────
class _AccountSectionWidget extends StatelessWidget {
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
            icon: Icons.lock_rounded,
            title: 'تغيير كلمة المرور',
            subtitle: 'آخر تغيير: منذ ٣٠ يوماً',
            onTap: () => _showChangePasswordSheet(context),
          ),
          const Divider(height: 0, indent: 60),
          SettingTile(
            icon: Icons.phone_rounded,
            title: 'تغيير رقم الهاتف',
            subtitle: '+20 10 *** *678',
            onTap: () {},
          ),
          const Divider(height: 0, indent: 60),
          SettingTile(
            icon: Icons.email_rounded,
            title: 'تغيير البريد الإلكتروني',
            subtitle: 'info@naseeji.com',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  void _showChangePasswordSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('تغيير كلمة المرور', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            const TextField(obscureText: true, decoration: InputDecoration(labelText: 'كلمة المرور الحالية', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            const TextField(obscureText: true, decoration: InputDecoration(labelText: 'كلمة المرور الجديدة', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            const TextField(obscureText: true, decoration: InputDecoration(labelText: 'تأكيد كلمة المرور الجديدة', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            PrimaryButton(label: 'تغيير كلمة المرور', onPressed: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }
}

// ─── Security Section Widget ───────────────────────────────────────────────
class _SecuritySectionWidget extends StatelessWidget {
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

// ─── Application Section Widget ────────────────────────────────────────────
class _ApplicationSectionWidget extends StatelessWidget {
  final AppSettingsModel settings;
  final SettingsNotifier notifier;

  const _ApplicationSectionWidget({required this.settings, required this.notifier});

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
            icon: Icons.attach_money_rounded,
            title: 'العملة',
            subtitle: settings.currency,
            onTap: () => _showPickerSheet(context, 'العملة',
                ['جنيه مصري (EGP)', 'دولار أمريكي (USD)', 'يورو (EUR)', 'ريال سعودي (SAR)'],
                notifier.setCurrency),
          ),
          const Divider(height: 0, indent: 60),
          SettingTile(
            icon: Icons.access_time_rounded,
            title: 'المنطقة الزمنية',
            subtitle: settings.timeZone,
            onTap: () => _showPickerSheet(context, 'المنطقة الزمنية',
                ['القاهرة (UTC+3)', 'الرياض (UTC+3)', 'دبي (UTC+4)', 'لندن (UTC+1)'],
                notifier.setTimeZone),
          ),
          const Divider(height: 0, indent: 60),
          SettingTile(
            icon: Icons.calendar_today_rounded,
            title: 'صيغة التاريخ',
            subtitle: settings.dateFormat,
            onTap: () => _showPickerSheet(context, 'صيغة التاريخ',
                ['YYYY/MM/DD', 'DD/MM/YYYY', 'MM-DD-YYYY'],
                notifier.setDateFormat),
          ),
          const Divider(height: 0, indent: 60),
          SettingTile(
            icon: Icons.translate_rounded,
            title: 'لغة التطبيق',
            subtitle: 'العربية (افتراضي)',
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

  void _showPickerSheet(BuildContext context, String title, List<String> options, ValueChanged<String> onPick) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 12),
            ...options.map((o) => ListTile(
                  title: Text(o, style: const TextStyle(fontSize: 13)),
                  trailing: const Icon(Icons.check_rounded, color: AppColors.primary, size: 18),
                  onTap: () {
                    onPick(o);
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }
}

// ─── Data Section Widget ───────────────────────────────────────────────────
class _DataSectionWidget extends StatelessWidget {
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
            icon: Icons.cleaning_services_rounded,
            title: 'مسح الكاش',
            subtitle: '٢٤ ميجابايت',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم مسح الكاش بنجاح.')),
            ),
          ),
          const Divider(height: 0, indent: 60),
          SettingTile(
            icon: Icons.file_download_rounded,
            title: 'تصدير البيانات',
            subtitle: 'تحميل نسخة من بياناتك',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('جاري تحضير الملف للتحميل...')),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Logout Widget ─────────────────────────────────────────────────────────
class _LogoutWidget extends StatelessWidget {
  final VoidCallback onLogout;
  const _LogoutWidget({required this.onLogout});

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
