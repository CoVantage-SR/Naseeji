import '../entities/rfq_stats.dart';
import '../entities/rfq_item.dart';
import '../entities/rfq_details.dart';
import '../entities/chat_message.dart';
import '../entities/offer_details.dart';
import '../entities/offer_approved.dart';
import '../entities/offer_rejected.dart';

abstract class OrdersRepository {
  Future<RfqStats> getRfqStats();
  Future<List<RfqItem>> getRfqItems();
  Future<RfqDetails> getRfqDetails(String rfqId);
  Future<List<ChatMessage>> getChatMessages(String rfqId);
  Future<OfferDetails> getOfferDetails(String rfqId);
  Future<OfferApproved> getOfferApproved(String rfqId);
  Future<OfferRejected> getOfferRejected(String rfqId);
}
