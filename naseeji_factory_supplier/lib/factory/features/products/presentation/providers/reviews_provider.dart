import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/product_detail_entities.dart';
import 'product_detail_repository_provider.dart';

part 'reviews_provider.g.dart';

@riverpod
Future<List<ProductReview>> reviews(
  ReviewsRef ref, {
  required String productId,
}) {
  return ref.watch(productDetailRepositoryProvider).getReviews(productId);
}

