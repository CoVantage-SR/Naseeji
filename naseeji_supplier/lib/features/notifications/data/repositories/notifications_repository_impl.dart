import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notifications_repository.dart';

part 'notifications_repository_impl.g.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final List<AppNotification> _mockNotifications = [
    AppNotification(
      id: '1',
      title: 'طلب توريد جديد بانتظار الموافقة',
      body: 'طلب توريد رقم #2401 من مصنع الغزل والنسيج الحديث لـ 500 متر قطن.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      isRead: false,
      type: NotificationType.alert,
    ),
    AppNotification(
      id: '2',
      title: 'تم استلام دفعة مالية جديدة',
      body: 'تم استلام مبلغ 5,000 دولار من مصنع أكسفورد للمنسوجات.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      type: NotificationType.update,
    ),
    AppNotification(
      id: '3',
      title: 'تنبيه مخزون منخفض',
      body: 'مخزون القماش القطني الأبيض شارف على الانتهاء. تبقى 20 لفة فقط.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      type: NotificationType.info,
    ),
  ];

  @override
  Future<List<AppNotification>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return List.from(_mockNotifications);
  }

  @override
  Future<void> markAsRead(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _mockNotifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _mockNotifications[index] = _mockNotifications[index].copyWith(isRead: true);
    }
  }
}

@riverpod
NotificationsRepository notificationsRepository(NotificationsRepositoryRef ref) {
  return NotificationsRepositoryImpl();
}
