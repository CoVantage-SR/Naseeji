import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/app_notification.dart';
import '../../data/repositories/notifications_repository_impl.dart';

part 'notifications_controller.g.dart';

@riverpod
class NotificationsController extends _$NotificationsController {
  @override
  FutureOr<List<AppNotification>> build() async {
    final repo = ref.watch(notificationsRepositoryProvider);
    return repo.getNotifications();
  }

  Future<void> markAsRead(String id) async {
    final repo = ref.read(notificationsRepositoryProvider);
    await repo.markAsRead(id);
    
    // Optimistically update status in state
    if (state.hasValue) {
      final updated = state.value!.map((n) {
        if (n.id == id) {
          return n.copyWith(isRead: true);
        }
        return n;
      }).toList();
      state = AsyncValue.data(updated);
    }
  }
}



