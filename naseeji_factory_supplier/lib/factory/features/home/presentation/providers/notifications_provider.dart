import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications_provider.g.dart';

class AppNotification {
  final String id;
  final String title;
  final String description;
  final String time;
  final String category; // 'orders', 'rfqs', 'shipping', 'payment', 'system', 'support'
  final bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.category,
    this.isRead = false,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? description,
    String? time,
    String? category,
    bool? isRead,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      category: category ?? this.category,
      isRead: isRead ?? this.isRead,
    );
  }
}

@riverpod
class NotificationsNotifier extends _$NotificationsNotifier {
  @override
  List<AppNotification> build() {
    return [
      AppNotification(
        id: '1',
        title: 'عرض سعر جديد متاح',
        description: 'قدم مصنع النيل للأقمشة عرض سعر جديد لطلبك رقم 104.',
        time: 'منذ ١٠ دقائق',
        category: 'rfqs',
        isRead: false,
      ),
      AppNotification(
        id: '2',
        title: 'تم شحن طلبك',
        description: 'طلبك رقم ORD-9721 قيد الشحن الآن مع أرامكس.',
        time: 'منذ ساعتين',
        category: 'shipping',
        isRead: false,
      ),
      AppNotification(
        id: '3',
        title: 'تم قبول الطلب',
        description: 'وافق المورد على طلب التوريد ORD-9843.',
        time: 'منذ ٥ ساعات',
        category: 'orders',
        isRead: true,
      ),
      AppNotification(
        id: '4',
        title: 'فشل عملية الدفع',
        description: 'لم نتمكن من معالجة دفعة الاشتراك الخاص بك. يرجى مراجعة بطاقة الدفع.',
        time: 'بالأمس',
        category: 'payment',
        isRead: false,
      ),
      AppNotification(
        id: '5',
        title: 'تحديث أمان النظام',
        description: 'تمت إضافة ميزة المصادقة الثنائية لحماية حسابك.',
        time: 'قبل يومين',
        category: 'system',
        isRead: true,
      ),
      AppNotification(
        id: '6',
        title: 'الرد على استفسارك',
        description: 'أجاب فريق الدعم الفني على تذكرتك المفتوحة رقم #5021.',
        time: 'قبل ٣ أيام',
        category: 'support',
        isRead: true,
      ),
    ];
  }

  void markAllAsRead() {
    state = state.map((notification) => notification.copyWith(isRead: true)).toList();
  }

  void deleteAll() {
    state = [];
  }

  void toggleReadStatus(String id) {
    state = state.map((notification) {
      if (notification.id == id) {
        return notification.copyWith(isRead: !notification.isRead);
      }
      return notification;
    }).toList();
  }

  void addNotification(AppNotification notification) {
    state = [notification, ...state];
  }

  void deleteNotification(String id) {
    state = state.where((notification) => notification.id != id).toList();
  }
}

@riverpod
String selectedNotificationCategory(SelectedNotificationCategoryRef ref) {
  return 'all';
}


