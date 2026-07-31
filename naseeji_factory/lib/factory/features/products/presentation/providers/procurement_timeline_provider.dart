import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/product_detail_entities.dart';
import 'product_detail_repository_provider.dart';

part 'procurement_timeline_provider.g.dart';

@riverpod
Future<List<ProcurementStage>> procurementTimeline(
  ProcurementTimelineRef ref, {
  required String productId,
}) {
  return ref.watch(productDetailRepositoryProvider).getProcurementTimeline(productId);
}
