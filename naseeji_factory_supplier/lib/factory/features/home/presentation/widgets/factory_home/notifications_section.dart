import 'package:flutter/material.dart';
import '../../../domain/entities/factory_home_models.dart';

class NotificationsSection extends StatelessWidget {
  final List<NotificationPreviewItem> notifications;
  final VoidCallback onViewAll;
  final ValueChanged<NotificationPreviewItem> onNotificationTap;

  const NotificationsSection({
    super.key,
    required this.notifications,
    required this.onViewAll,
    required this.onNotificationTap,
  });

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'shipment':
        return Icons.local_shipping_rounded;
      case 'deal':
        return Icons.assignment_turned_in_rounded;
      case 'chat':
        return Icons.mark_chat_unread_rounded;
      case 'quotation':
      default:
        return Icons.local_offer_rounded;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'shipment':
        return Colors.blue;
      case 'deal':
        return Colors.green;
      case 'chat':
        return Colors.orange;
      case 'quotation':
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'آخر الإشعارات',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              InkWell(
                onTap: onViewAll,
                child: Text(
                  'عرض الكل',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Horizontal list of Notification Cards
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notif = notifications[index];
              final iconColor = _getIconColor(notif.type);

              return Container(
                width: 200,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: theme.cardTheme.color ?? colorScheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.25),
                    width: 1,
                  ),
                ),
                child: InkWell(
                  onTap: () => onNotificationTap(notif),
                  borderRadius: BorderRadius.circular(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              notif.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: iconColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _getNotificationIcon(notif.type),
                              color: iconColor,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        notif.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 10,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        notif.timeAgo,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

