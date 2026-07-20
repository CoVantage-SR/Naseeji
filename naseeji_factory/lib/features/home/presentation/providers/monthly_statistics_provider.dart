import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/home_entities.dart';
import 'home_repository_provider.dart';

part 'monthly_statistics_provider.g.dart';

@riverpod
Future<MonthlyStatistics> monthlyStatistics(MonthlyStatisticsRef ref) {
  return ref.watch(homeRepositoryProvider).getMonthlyStatistics();
}
