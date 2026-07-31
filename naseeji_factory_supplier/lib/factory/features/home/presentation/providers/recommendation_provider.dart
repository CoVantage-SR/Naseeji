import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/home_entities.dart';
import 'home_repository_provider.dart';

part 'recommendation_provider.g.dart';

@riverpod
Future<List<SmartRecommendation>> recommendation(RecommendationRef ref) {
  return ref.watch(homeRepositoryProvider).getSmartRecommendations();
}

