import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/activity_log.dart';
import '../../data/repositories/orders_repository_impl.dart';

part 'activity_log_controller.g.dart';

@riverpod
class ActivityLogController extends _$ActivityLogController {
  @override
  FutureOr<List<ActivityLogItem>> build(String rfqId) async {
    final repo = ref.watch(ordersRepositoryProvider);
    return repo.getActivityLog(rfqId);
  }
}



