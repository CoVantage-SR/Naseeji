import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/notification_item_model.dart';
import 'dashboard_card.dart';

class NotificationCard extends StatelessWidget {
  final NotificationItemModel notification;

  const NotificationCard({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final IconData icon = _getNotificationIcon(notification.type);
    final Color color = _getNotificationColor(notification.type, colorScheme);

    return DashboardCard(
      padding: const EdgeInsets.all(10),
      backgroundColor: notification.isRead
          ? colorScheme.surface
          : colorScheme.primary.withValues(alpha: 0.04),
      onTap: () {
        if (notification.targetRoute != null) {
          context.push(notification.targetRoute!);
        } else {
          context.push('/notifications');
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
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
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.bold,
                          color: colorScheme.onSurface,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      _formatTimestamp(notification.timestamp),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.outline,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  notification.message,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.newRfq:
        return Icons.request_quote_rounded;
      case NotificationType.counterOffer:
        return Icons.handshake_rounded;
      case NotificationType.agreementApproved:
        return Icons.verified_user_rounded;
      case NotificationType.shipmentCreated:
        return Icons.local_shipping_rounded;
      case NotificationType.paymentReleased:
        return Icons.account_balance_wallet_rounded;
      case NotificationType.subscriptionExpiring:
        return Icons.warning_amber_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _getNotificationColor(NotificationType type, ColorScheme colorScheme) {
    switch (type) {
      case NotificationType.newRfq:
        return const Color(0xFF0040E0);
      case NotificationType.counterOffer:
        return const Color(0xFFE65100);
      case NotificationType.agreementApproved:
        return const Color(0xFF2E7D32);
      case NotificationType.shipmentCreated:
        return const Color(0xFF006B5F);
      case NotificationType.paymentReleased:
        return const Color(0xFF673AB7);
      case NotificationType.subscriptionExpiring:
        return colorScheme.error;
      default:
        return colorScheme.primary;
    }
  }

  String _formatTimestamp(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) {
      return 'منذ ${diff.inMinutes} د';
    } else if (diff.inHours < 24) {
      return 'منذ ${diff.inHours} س';
    } else {
      return 'منذ ${diff.inDays} ي';
    }
  }
}


