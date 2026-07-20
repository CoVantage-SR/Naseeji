import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/product_detail_entities.dart';
import 'product_detail_repository_provider.dart';

part 'production_capacity_provider.g.dart';

@riverpod
Future<ProductionCapacity> productionCapacity(
  ProductionCapacityRef ref, {
  required String productId,
}) {
  return ref.watch(productDetailRepositoryProvider).getProductionCapacity(productId);
}
