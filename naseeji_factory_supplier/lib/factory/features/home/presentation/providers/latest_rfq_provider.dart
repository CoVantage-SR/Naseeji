import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/home_entities.dart';
import 'home_repository_provider.dart';

part 'latest_rfq_provider.g.dart';

@riverpod
Future<List<LatestRFQ>> latestRfq(LatestRfqRef ref) {
  return ref.watch(homeRepositoryProvider).getLatestRFQs();
}

