import '../entities/product_detail_entities.dart';

/// Abstract contract for all procurement-related data for a single product.
abstract class ProductDetailRepository {
  /// Returns bulk quantity pricing tiers for the given product.
  Future<List<BulkPricingTier>> getBulkPricingTiers(String productId);

  /// Returns supplier production capacity data.
  Future<ProductionCapacity> getProductionCapacity(String productId);

  /// Returns Naseeji Logistics delivery information (carrier always = ناصيجي لوجستيك, SLA always = 48h).
  Future<LogisticsInfo> getLogisticsInfo(String productId);

  /// Returns all downloadable documents for the product.
  Future<List<DocumentItem>> getDocuments(String productId);

  /// Returns physical sample ordering information.
  Future<SampleInfo> getSampleInfo(String productId);

  /// Returns the top B2B factory reviews for the product.
  Future<List<ProductReview>> getReviews(String productId);

  /// Returns the full 24-step procurement timeline for a specific order/product.
  Future<List<ProcurementStage>> getProcurementTimeline(String productId);
}

