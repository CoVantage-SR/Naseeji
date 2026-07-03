import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/app_notification.dart';
import '../controllers/notifications_controller.dart';

class NotificationsCenterScreen extends ConsumerStatefulWidget {
  const NotificationsCenterScreen({super.key});

  @override
  ConsumerState<NotificationsCenterScreen> createState() => _NotificationsCenterScreenState();
}

class _NotificationsCenterScreenState extends ConsumerState<NotificationsCenterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('مركز الإشعارات'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.onSurface,
        elevation: 0.5,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.onSurfaceVariant,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'الكل'),
            Tab(text: 'غير مقروء'),
            Tab(text: 'تنبيهات'),
            Tab(text: 'تحديثات'),
          ],
        ),
      ),
      body: notificationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
        data: (notifications) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildNotificationList(notifications),
              _buildNotificationList(notifications.where((n) => !n.isRead).toList()),
              _buildNotificationList(
                notifications.where((n) => n.type == NotificationType.alert).toList(),
              ),
              _buildNotificationList(
                notifications.where((n) => n.type == NotificationType.update).toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNotificationList(List<AppNotification> list) {
    if (list.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد إشعارات حالياً',
          style: TextStyle(color: AppColors.outline),
        ),
      );
    }

    return ListView.separated(
      itemCount: list.length,
      padding: const EdgeInsets.all(16),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = list[index];
        return GestureDetector(
          onTap: () {
            if (!item.isRead) {
              ref.read(notificationsControllerProvider.notifier).markAsRead(item.id);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: item.isRead ? Colors.white : AppColors.primary.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: item.isRead
                    ? AppColors.outlineVariant.withValues(alpha: 0.3)
                    : AppColors.primary.withValues(alpha: 0.15),
                width: item.isRead ? 1 : 1.5,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIcon(item.type, item.isRead),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: item.isRead ? FontWeight.w600 : FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.body,
                        style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatTime(item.timestamp),
                        style: const TextStyle(fontSize: 10, color: AppColors.outline),
                      ),
                    ],
                  ),
                ),
                if (!item.isRead)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIcon(NotificationType type, bool isRead) {
    IconData iconData;
    Color color;
    switch (type) {
      case NotificationType.alert:
        iconData = Icons.warning_amber_rounded;
        color = AppColors.tertiary;
        break;
      case NotificationType.update:
        iconData = Icons.receipt_long;
        color = AppColors.secondary;
        break;
      case NotificationType.info:
        iconData = Icons.info_outline;
        color = AppColors.outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: color, size: 20),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final difference = now.difference(dt);
    if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else {
      return '${dt.day}/${dt.month}/${dt.year}';
    }
  }
}
