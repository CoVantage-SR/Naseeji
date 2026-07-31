import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import 'package:naseeji_factory/supplier/features/notifications/domain/entities/app_notification.dart';
import 'package:naseeji_factory/supplier/features/notifications/presentation/controllers/notifications_controller.dart';
import 'notification_tile.dart';

class NotificationsList extends ConsumerWidget {
  final List<AppNotification> items;

  const NotificationsList({super.key, required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          'لا توجد إشعارات حالياً',
          style: TextStyle(color: AppColors.outline),
        ),
      );
    }

    return ListView.separated(
      itemCount: items.length,
      padding: const EdgeInsets.all(16),
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        return NotificationTile(
          item: item,
          onTap: () {
            // Mark as read in state
            if (!item.isRead) {
              ref.read(notificationsControllerProvider.notifier).markAsRead(item.id);
            }
            // Navigate or show section dialog
            _handleNotificationTap(context, item);
          },
        );
      },
    );
  }

  void _handleNotificationTap(BuildContext context, AppNotification item) {
    switch (item.type) {
      case NotificationType.alert:
        // Redirect to Orders Section
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('الانتقال إلى صفحة إدارة الطلبات لـ: ${item.title}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.primary,
          ),
        );
        break;
      case NotificationType.info:
        // Redirect / Show Shipping status dialog
        _showDetailDialog(
          context: context,
          title: item.title,
          content: '${item.body}\n\nحالة الشحن: قيد التوصيل للمخازن الرئيسية بجدة.',
          icon: Icons.local_shipping,
          iconColor: const Color(0xFF00BFA5),
        );
        break;
      case NotificationType.update:
        // Redirect / Show Finance payment confirmation dialog
        _showDetailDialog(
          context: context,
          title: item.title,
          content: '${item.body}\n\nرقم الفاتورة: #INV-2026-789\nتاريخ الاستلام: اليوم، ١:١٥ م',
          icon: Icons.account_balance_wallet,
          iconColor: const Color(0xFFEA4335),
        );
        break;
      case NotificationType.message:
        // Redirect to Message Chat
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('الانتقال إلى صندوق المحادثات للرد على العميل...'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.secondary,
          ),
        );
        break;
      case NotificationType.system:
        // Redirect / Show System Maintenance hours details dialog
        _showDetailDialog(
          context: context,
          title: item.title,
          content: '${item.body}\n\nنرجو حفظ التعديلات وإتمام العمليات الهامة قبل موعد الصيانة المذكور.',
          icon: Icons.settings,
          iconColor: const Color(0xFF5F6368),
        );
        break;
    }
  }

  void _showDetailDialog({
    required BuildContext context,
    required String title,
    required String content,
    required IconData icon,
    required Color iconColor,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8),
            Icon(icon, color: iconColor),
          ],
        ),
        content: Text(
          content,
          textAlign: TextAlign.right,
          style: TextStyle(fontSize: 13, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}

