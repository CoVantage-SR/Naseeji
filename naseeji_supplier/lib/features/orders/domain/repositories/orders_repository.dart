import '../entities/rfq_stats.dart';
import '../entities/rfq_item.dart';

abstract class OrdersRepository {
  Future<RfqStats> getRfqStats();
  Future<List<RfqItem>> getRfqItems();
}
