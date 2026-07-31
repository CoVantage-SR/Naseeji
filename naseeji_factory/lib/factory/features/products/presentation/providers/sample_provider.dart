import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/product_detail_entities.dart';
import 'product_detail_repository_provider.dart';

part 'sample_provider.g.dart';

@riverpod
Future<SampleInfo> sampleInfo(
  SampleInfoRef ref, {
  required String productId,
}) {
  return ref.watch(productDetailRepositoryProvider).getSampleInfo(productId);
}
