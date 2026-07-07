import '../entities/rfq_stats.dart';
import '../entities/rfq_item.dart';
import '../entities/rfq_details.dart';
import '../entities/chat_message.dart';
import '../entities/offer_details.dart';
import '../entities/offer_approved.dart';
import '../entities/offer_rejected.dart';
import '../entities/final_agreement.dart';
import '../entities/quotation_revision.dart';
import '../entities/production_preparation.dart';
import '../entities/shipping_manifest.dart';
import '../entities/delivery_confirmation.dart';
import '../entities/payment_release.dart';
import '../entities/activity_log.dart';

abstract class OrdersRepository {
  Future<RfqStats> getRfqStats();
  Future<List<RfqItem>> getRfqItems();
  Future<RfqDetails> getRfqDetails(String rfqId);
  Future<List<ChatMessage>> getChatMessages(String rfqId);
  Future<OfferDetails> getOfferDetails(String rfqId);
  Future<OfferApproved> getOfferApproved(String rfqId);
  Future<OfferRejected> getOfferRejected(String rfqId);
  Future<FinalAgreement> getFinalAgreement(String rfqId);
  Future<List<QuotationRevision>> getQuotationHistory(String rfqId);
  Future<ProductionPreparation> getProductionPreparation(String rfqId);
  Future<ShippingManifest> getShippingManifest(String rfqId);
  Future<DeliveryConfirmation> getDeliveryConfirmation(String rfqId);
  Future<PaymentRelease> getPaymentRelease(String rfqId);
  Future<List<ActivityLogItem>> getActivityLog(String rfqId);
  Future<void> addActivityLogItem(String rfqId, ActivityLogItem item);
}
