import '../entities/rfq_stats.dart';
import '../entities/rfq_item.dart';
import '../entities/rfq_details.dart';

abstract class OrdersRepository {
  Future<RfqStats> getRfqStats();
  Future<List<RfqItem>> getRfqItems();
  Future<RfqDetails> getRfqDetails(String rfqId);
}
