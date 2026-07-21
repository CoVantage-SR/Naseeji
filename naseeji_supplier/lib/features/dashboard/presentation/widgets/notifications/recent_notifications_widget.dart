import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/notification_item_model.dart';
import '../../providers/dashboard_providers.dart';
import '../shared/dashboard_card_widget.dart';
import '../shared/dashboard_section_title_widget.dart';
import '../shared/dashboard_loading_widget.dart';
import '../shared/dashboard_empty_state_widget.dart';

class RecentNotificationsWidget extends ConsumerWidget {
  const RecentNotificationsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifsAsync = ref.watch(notificationsProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardSectionTitleWidget(
          title: 'التنبيهات والأحداث الأخيرة',
          subtitle: 'آخر التحديثات والإشعارات الهامة على النظام',
          icon: Icons.notifications_active_rounded,
          actionText: 'مركز الإشعارات',
          onActionTap: () => context.push('/notifications'),
        ),
        notifsAsync.when(
          loading: () => const DashboardLoadingWidget(height: 180),
          error: (err, stack) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('خطأ في تحميل التنبيهات: $err'),
          ),
          data: (notifications) {
            if (notifications.isEmpty) {
              return const DashboardEmptyStateWidget(
                title: 'لا توجد تنبيهات جديدة',
                description: 'ستصلك التنبيهات حول طلبات الأسعار والمدفوعات هنا.',
                icon: Icons.notifications_off_outlined,
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final notif = notifications[index];
                final iconData = _getNotificationIcon(notif.type);
                final color = _getNotificationColor(notif.type, colorScheme);

                return DashboardCardWidget(
                  padding: const EdgeInsets.all(12),
                  backgroundColor: notif.isRead
                      ? colorScheme.surface
                      : colorScheme.primary.withValues(alpha: 0.04),
                  onTap: () {
                    if (notif.targetRoute != null) {
                      context.push(notif.targetRoute!);
                    } else {
                      context.push('/notifications');
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(iconData, color: color, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    notif.title,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: notif.isRead
                                          ? FontWeight.w600
                                          : FontWeight.bold,
                                      color: colorScheme.onSurface,
                                      fontSize: 13,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (!notif.isRead)
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              notif.message,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatTimestamp(notif.timestamp),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.outline,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
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
      return 'منذ ${diff.inMinutes} دقيقة';
    } else if (diff.inHours < 24) {
      return 'منذ ${diff.inHours} ساعة';
    } else {
      return 'منذ ${diff.inDays} يوم';
    }
  }
}
