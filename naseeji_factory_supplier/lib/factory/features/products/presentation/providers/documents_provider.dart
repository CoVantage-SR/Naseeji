import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/product_detail_entities.dart';
import 'product_detail_repository_provider.dart';

part 'documents_provider.g.dart';

@riverpod
Future<List<DocumentItem>> documents(
  DocumentsRef ref, {
  required String productId,
}) {
  return ref.watch(productDetailRepositoryProvider).getDocuments(productId);
}


