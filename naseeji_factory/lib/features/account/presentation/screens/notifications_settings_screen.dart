import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/account_provider.dart';

class NotificationsSettingsScreen extends ConsumerWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(settingsNotifierProvider.notifier);

    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    final categories = [
      'الصفقات',
      'عروض الأسعار',
      'السوق والمنتجات',
      'الرسائل والمحادثات',
      'المدفوعات والمحفظة',
      'الاشتراكات والخدمات',
      'النظام والأمان',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفضيلات الإشعارات والتنبيهات'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        children: [
          Text(
            'تخصيص وسائط وقنوات التنبيه لكل قسم من أقسام المنظومة:',
            style: TextStyle(color: textPrimary, fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ...categories.map((category) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: AppRadius.rLG,
                border: Border.all(color: border),
              ),
              child: ExpansionTile(
                initiallyExpanded: category == 'الصفقات' || category == 'عروض الأسعار',
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: Icon(_categoryIcon(category), color: AppColors.primary, size: 20),
                ),
                title: Text(category, style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
                children: [
                  const Divider(height: 1),
                  _switchTile(
                    title: 'إشعارات لحظية Push Notifications',
                    value: notifier.getNotification(category, 'push'),
                    onChanged: (val) => notifier.setNotification(category, 'push', val),
                  ),
                  _switchTile(
                    title: 'رسائل البريد الإلكتروني Email',
                    value: notifier.getNotification(category, 'email'),
                    onChanged: (val) => notifier.setNotification(category, 'email', val),
                  ),
                  _switchTile(
                    title: 'رسائل نصية قصيرة SMS',
                    value: notifier.getNotification(category, 'sms'),
                    onChanged: (val) => notifier.setNotification(category, 'sms', val),
                  ),
                  _switchTile(
                    title: 'تنبيهات واتساب WhatsApp',
                    value: notifier.getNotification(category, 'whatsapp'),
                    onChanged: (val) => notifier.setNotification(category, 'whatsapp', val),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            icon: const Icon(Icons.save_rounded),
            label: const Text('حفظ التفضيلات'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حفظ تفضيلات الإشعارات بنجاح!')),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _switchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      dense: true,
      title: Text(title, style: const TextStyle(fontSize: 12)),
      value: value,
      onChanged: onChanged,
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'الصفقات':
        return Icons.handshake_outlined;
      case 'عروض الأسعار':
        return Icons.request_quote_outlined;
      case 'السوق والمنتجات':
        return Icons.shopping_bag_outlined;
      case 'الرسائل والمحادثات':
        return Icons.chat_bubble_outline_rounded;
      case 'المدفوعات والمحفظة':
        return Icons.account_balance_wallet_outlined;
      case 'الاشتراكات والخدمات':
        return Icons.card_membership_rounded;
      case 'النظام والأمان':
        return Icons.shield_outlined;
      default:
        return Icons.notifications_none_rounded;
    }
  }
}
