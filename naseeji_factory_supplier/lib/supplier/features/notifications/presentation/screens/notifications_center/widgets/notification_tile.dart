import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../../../../domain/entities/app_notification.dart';

class NotificationTile extends StatelessWidget {
  final AppNotification item;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.01),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Thick blue accent line on the right edge for unread items
              if (!item.isRead)
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: 4,
                  child: Container(
                    color: AppColors.primary,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Blue dot indicator on the left for unread items
                    if (!item.isRead)
                      Padding(
                        padding: const EdgeInsets.only(top: 14.0, right: 4.0, left: 8.0),
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    else
                      SizedBox(width: 20), // Placeholder spacing matching the dot size

                    SizedBox(width: 8),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            item.body,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            _formatTime(item.timestamp),
                            style: TextStyle(fontSize: 10, color: AppColors.outline),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 12),

                    // Round themed icon or customer avatar image on the right
                    _buildLeading(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeading(BuildContext context) {
    if (item.type == NotificationType.message && item.avatarUrl != null) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(item.avatarUrl!),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    IconData iconData;
    Color color;
    Color bgColor;

    switch (item.type) {
      case NotificationType.alert:
        iconData = Icons.shopping_cart_outlined;
        color = const Color(0xFF1A73E8);
        bgColor = const Color(0xFFE8F0FE);
        break;
      case NotificationType.info:
        iconData = Icons.local_shipping_outlined;
        color = const Color(0xFF00BFA5);
        bgColor = const Color(0xFFE4FBF7);
        break;
      case NotificationType.update:
        iconData = Icons.account_balance_wallet_outlined;
        color = const Color(0xFFEA4335);
        bgColor = const Color(0xFFFCE8E6);
        break;
      case NotificationType.system:
        iconData = Icons.settings_outlined;
        color = const Color(0xFF5F6368);
        bgColor = const Color(0xFFF1F3F4);
        break;
      default:
        iconData = Icons.notifications_none;
        color = AppColors.primary;
        bgColor = AppColors.primaryContainer.withValues(alpha: 0.1);
        break;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: color, size: 22),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final difference = now.difference(dt);
    if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقائق';
    } else if (difference.inHours < 24) {
      if (difference.inHours == 1) return 'منذ ساعة';
      if (difference.inHours == 2) return 'منذ ساعتين';
      return 'منذ ${difference.inHours} ساعات';
    } else if (difference.inDays < 7) {
      if (difference.inDays == 1) return 'أمس، ٩:٣٠ م';
      return 'منذ ${difference.inDays} أيام';
    } else {
      return '${dt.day}/${dt.month}/${dt.year}';
    }
  }
}


