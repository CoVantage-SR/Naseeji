import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/home_entities.dart';
import 'home_repository_provider.dart';

part 'home_statistics_provider.g.dart';

@riverpod
Future<HomeStatistics> homeStatistics(HomeStatisticsRef ref) {
  return ref.watch(homeRepositoryProvider).getHomeStatistics();
}
