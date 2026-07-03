import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../../domain/entities/app_notification.dart';
import '../../controllers/notifications_controller.dart';
import 'widgets/notification_tile.dart';

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
        return NotificationTile(
          item: item,
          onTap: () {
            if (!item.isRead) {
              ref.read(notificationsControllerProvider.notifier).markAsRead(item.id);
            }
          },
        );
      },
    );
  }
}
