import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/home_entities.dart';
import 'home_repository_provider.dart';

part 'quotation_provider.g.dart';

@riverpod
Future<List<LatestQuotation>> quotation(QuotationRef ref) {
  return ref.watch(homeRepositoryProvider).getLatestQuotations();
}


