import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/mock_product_detail_repository.dart';
import '../../domain/repositories/product_detail_repository.dart';

part 'product_detail_repository_provider.g.dart';

@riverpod
ProductDetailRepository productDetailRepository(ProductDetailRepositoryRef ref) {
  return const MockProductDetailRepository();
}


