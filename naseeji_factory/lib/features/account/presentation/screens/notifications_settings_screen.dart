import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/account_provider.dart';
import '../widgets/account_reusable_widgets.dart';

class NotificationsSettingsScreen extends ConsumerWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);

    final categories = [
      ('عروض الأسعار', Icons.request_quote_rounded, AppColors.primary),
      ('الطلبات', Icons.shopping_bag_rounded, AppColors.info),
      ('الشحن', Icons.local_shipping_rounded, AppColors.secondary),
      ('الرسائل', Icons.chat_rounded, AppColors.success),
      ('الفواتير', Icons.receipt_long_rounded, AppColors.warning),
      ('التقييمات', Icons.star_rounded, Colors.amber),
      ('الاشتراك', Icons.workspace_premium_rounded, const Color(0xFF7C3AED)),
      ('النظام', Icons.info_rounded, Colors.grey),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات الإشعارات'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) {
            final cat = categories[i];
            return _NotificationCategoryCard(
              icon: cat.$2,
              title: cat.$1,
              color: cat.$3,
              pushEnabled: settings.notificationSettings[cat.$1]?['push'] ?? false,
              emailEnabled: settings.notificationSettings[cat.$1]?['email'] ?? false,
              onPushChanged: (v) => notifier.setNotification(cat.$1, 'push', v),
              onEmailChanged: (v) => notifier.setNotification(cat.$1, 'email', v),
            );
          },
        ),
      ),
    );
  }
}

class _NotificationCategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final bool pushEnabled;
  final bool emailEnabled;
  final ValueChanged<bool> onPushChanged;
  final ValueChanged<bool> onEmailChanged;

  const _NotificationCategoryCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.pushEnabled,
    required this.emailEnabled,
    required this.onPushChanged,
    required this.onEmailChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: AppRadius.rSM),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
            const Divider(height: 16),
            NotificationTile(label: 'إشعارات الدفع (Push)', value: pushEnabled, onChanged: onPushChanged),
            NotificationTile(label: 'إشعارات البريد الإلكتروني', value: emailEnabled, onChanged: onEmailChanged),
            NotificationTile(
              label: 'إشعارات واتساب',
              value: false,
              onChanged: (_) {},
              enabled: false,
            ),
          ],
        ),
      ),
    );
  }
}
