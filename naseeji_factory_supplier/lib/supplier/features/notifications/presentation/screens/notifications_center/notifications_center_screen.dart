import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/app_notification.dart';
import '../../controllers/notifications_controller.dart';
import 'widgets/filter_pills_row.dart';
import 'widgets/notifications_app_bar.dart';
import 'widgets/notifications_list.dart';

class NotificationsCenterScreen extends ConsumerStatefulWidget {
  const NotificationsCenterScreen({super.key});

  @override
  ConsumerState<NotificationsCenterScreen> createState() =>
      _NotificationsCenterScreenState();
}

class _NotificationsCenterScreenState
    extends ConsumerState<NotificationsCenterScreen> {
  String _selectedFilter = 'الكل';

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsControllerProvider);

    return Scaffold(
      appBar: NotificationsAppBar(
        onMarkAllRead: () {
          ref.invalidate(notificationsControllerProvider);
        },
      ),
      body: Column(
        children: [
          // Filter pills selector row
          FilterPillsRow(
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
            },
          ),

          // Scrollable Notifications list
          Expanded(
            child: notificationsAsync.when(
              loading: () => Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('خطأ: $err')),
              data: (notifications) {
                final filteredList = _applyFilter(notifications);
                return NotificationsList(items: filteredList);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<AppNotification> _applyFilter(List<AppNotification> list) {
    switch (_selectedFilter) {
      case 'الطلبات':
        return list.where((n) => n.type == NotificationType.alert).toList();
      case 'الشحن':
        return list.where((n) => n.type == NotificationType.info).toList();
      case 'الدفع':
        return list.where((n) => n.type == NotificationType.update).toList();
      case 'الكل':
      default:
        return list;
    }
  }
}



