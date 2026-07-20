import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../domain/entities/product_detail_entities.dart';
import 'product_detail_repository_provider.dart';

part 'bulk_pricing_provider.g.dart';

@riverpod
Future<List<BulkPricingTier>> bulkPricing(
  BulkPricingRef ref, {
  required String productId,
}) {
  return ref.watch(productDetailRepositoryProvider).getBulkPricingTiers(productId);
}
