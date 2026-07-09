import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notifications_repository.dart';

part 'notifications_repository_impl.g.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final List<AppNotification> _mockNotifications = [
    AppNotification(
      id: '1',
      title: 'طلب شراء جديد #4902',
      body: 'قام مصنع "النسيج الذكي" بتأكيد طلب شراء لـ 500 متر من قماش الكتان الفاخر.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isRead: false,
      type: NotificationType.alert,
    ),
    AppNotification(
      id: '2',
      title: 'تم تحديث حالة الشحن',
      body: 'الشحنة رقم AR-8890 في طريقها الآن إلى مركز التوزيع بجدة.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
      type: NotificationType.info,
    ),
    AppNotification(
      id: '3',
      title: 'تأكيد استلام الدفعة',
      body: 'تم استلام مبلغ 12,450 جنيه بنجاح مقابل فاتورة التوريد الشهرية.',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      isRead: false,
      type: NotificationType.update,
    ),
    AppNotification(
      id: '4',
      title: 'رسالة جديدة من عميل',
      body: '"أهلاً نسيجي، هل تتوفر كميات إضافية من حرير الكريب باللون الأزرق الملكي؟"',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      type: NotificationType.message,
      avatarUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=150',
    ),
    AppNotification(
      id: '5',
      title: 'تحديث النظام مجدول',
      body: 'سيخضع النظام لصيانة دورية يوم الجمعة القادم بين الساعة ٣ ص و ٥ ص.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      type: NotificationType.system,
    ),
  ];

  @override
  Future<List<AppNotification>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_mockNotifications);
  }

  @override
  Future<void> markAsRead(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
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
