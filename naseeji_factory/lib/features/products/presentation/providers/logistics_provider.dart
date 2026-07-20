import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../domain/entities/product_detail_entities.dart';
import 'product_detail_repository_provider.dart';

part 'logistics_provider.g.dart';

@riverpod
Future<LogisticsInfo> logisticsInfo(
  LogisticsInfoRef ref, {
  required String productId,
}) {
  return ref.watch(productDetailRepositoryProvider).getLogisticsInfo(productId);
}
