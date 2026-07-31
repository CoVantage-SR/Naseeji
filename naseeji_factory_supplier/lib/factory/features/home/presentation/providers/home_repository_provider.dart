import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/repositories/home_repository.dart';
import '../../data/repositories/mock_home_repository.dart';

part 'home_repository_provider.g.dart';

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return MockHomeRepository();
}


