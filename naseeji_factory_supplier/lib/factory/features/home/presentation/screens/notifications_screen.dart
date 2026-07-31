import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/notifications_provider.dart';
import '../widgets/notifications_widgets.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  String _activeCategory = 'all';

  @override
  Widget build(BuildContext context) {
    final allNotifications = ref.watch(notificationsNotifierProvider);
    final notifier = ref.read(notificationsNotifierProvider.notifier);

    // Apply Filter
    final filteredNotifications = _activeCategory == 'all'
        ? allNotifications
        : allNotifications.where((n) => n.category == _activeCategory).toList();

    return Scaffold(
      appBar: NotificationAppBarWidget(
        onReadAll: () => notifier.markAllAsRead(),
        onDeleteAll: () => notifier.deleteAll(),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          NotificationFilterWidget(
            selectedCategory: _activeCategory,
            onSelected: (cat) {
              setState(() {
                _activeCategory = cat;
              });
            },
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          Expanded(
            child: filteredNotifications.isEmpty
                ? const EmptyNotificationWidget()
                : ListView.separated(
                    itemCount: filteredNotifications.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final n = filteredNotifications[index];
                      return NotificationCardWidget(
                        notification: n,
                        onToggleRead: () => notifier.toggleReadStatus(n.id),
                        onDelete: () => notifier.deleteNotification(n.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}



