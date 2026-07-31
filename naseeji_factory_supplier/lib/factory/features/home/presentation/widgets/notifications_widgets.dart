import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/notifications_provider.dart';

/// 1. NotificationAppBarWidget
class NotificationAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onReadAll;
  final VoidCallback onDeleteAll;

  const NotificationAppBarWidget({
    super.key,
    required this.onReadAll,
    required this.onDeleteAll,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('الإشعارات'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_forward_rounded),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.done_all_rounded, color: AppColors.primary),
          tooltip: 'قراءة الكل',
          onPressed: onReadAll,
        ),
        IconButton(
          icon: const Icon(Icons.delete_sweep_outlined, color: AppColors.error),
          tooltip: 'حذف الكل',
          onPressed: onDeleteAll,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// 2. NotificationFilterWidget
class NotificationFilterWidget extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  const NotificationFilterWidget({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
  });

  final List<Map<String, String>> _categories = const [
    {'key': 'all', 'label': 'الكل'},
    {'key': 'orders', 'label': 'طلبات'},
    {'key': 'rfqs', 'label': 'عروض أسعار'},
    {'key': 'shipping', 'label': 'الشحن'},
    {'key': 'payment', 'label': 'الدفع'},
    {'key': 'system', 'label': 'النظام'},
    {'key': 'support', 'label': 'الدعم الفني'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: _categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = selectedCategory == cat['key'];

          return ChoiceChip(
            label: Text(cat['label']!),
            selected: isSelected,
            onSelected: (_) => onSelected(cat['key']!),
            selectedColor: AppColors.primary,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : context.colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.rRound,
            ),
            showCheckmark: false,
          );
        },
      ),
    );
  }
}

/// 3. NotificationCardWidget
class NotificationCardWidget extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onToggleRead;
  final VoidCallback onDelete;

  const NotificationCardWidget({
    super.key,
    required this.notification,
    required this.onToggleRead,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    IconData icon = Icons.notifications_none_rounded;
    Color color = AppColors.primary;

    if (notification.category == 'orders') {
      icon = Icons.receipt_long_outlined;
      color = AppColors.primary;
    } else if (notification.category == 'rfqs') {
      icon = Icons.request_quote_outlined;
      color = AppColors.secondary;
    } else if (notification.category == 'shipping') {
      icon = Icons.local_shipping_outlined;
      color = AppColors.info;
    } else if (notification.category == 'payment') {
      icon = Icons.payment_rounded;
      color = AppColors.error;
    } else if (notification.category == 'system') {
      icon = Icons.settings_rounded;
      color = Colors.blueGrey;
    } else if (notification.category == 'support') {
      icon = Icons.support_agent_rounded;
      color = AppColors.success;
    }

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.horizontal,
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onDelete();
        } else {
          onToggleRead();
        }
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onToggleRead();
          return false; // Don't remove the widget from tree
        }
        return true; // remove for delete
      },
      background: Container(
        color: AppColors.primary.withValues(alpha: 0.8),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Row(
          children: [
            Icon(Icons.mark_email_read_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'تغيير المقروءية',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        color: AppColors.error.withValues(alpha: 0.8),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'حذف الإشعار',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8),
            Icon(Icons.delete_outline_rounded, color: Colors.white),
          ],
        ),
      ),
      child: Container(
        color: notification.isRead
            ? Colors.transparent
            : AppColors.primary.withValues(alpha: isDark ? 0.08 : 0.03),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: isDark ? 0.2 : 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            AppSpacing.wMD,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: context.textTheme.titleSmall?.copyWith(
                            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        notification.time,
                        style: context.textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.description,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            if (!notification.isRead) ...[
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 4. EmptyNotificationWidget
class EmptyNotificationWidget extends StatelessWidget {
  const EmptyNotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.notifications_none_rounded,
      title: 'صندوق الإشعارات فارغ',
      description: 'لا توجد إشعارات لعرضها في هذا القسم حالياً.',
    );
  }
}

