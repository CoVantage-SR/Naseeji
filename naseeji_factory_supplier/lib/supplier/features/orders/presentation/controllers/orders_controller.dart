import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/rfq_stats.dart';
import '../../domain/entities/rfq_item.dart';
import '../../data/repositories/orders_repository_impl.dart';

part 'orders_controller.g.dart';

class OrdersViewState {
  final RfqStats stats;
  final List<RfqItem> items;

  const OrdersViewState({
    required this.stats,
    required this.items,
  });
}

@riverpod
class OrdersController extends _$OrdersController {
  @override
  FutureOr<OrdersViewState> build() async {
    final repo = ref.watch(ordersRepositoryProvider);
    final stats = await repo.getRfqStats();
    final items = await repo.getRfqItems();
    return OrdersViewState(stats: stats, items: items);
  }

  Future<void> refreshOrders() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(ordersRepositoryProvider);
      final stats = await repo.getRfqStats();
      final items = await repo.getRfqItems();
      return OrdersViewState(stats: stats, items: items);
    });
  }
}

