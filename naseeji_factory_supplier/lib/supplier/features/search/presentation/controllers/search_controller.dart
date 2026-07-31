import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/search_item.dart';
import '../../data/repositories/search_repository_impl.dart';

part 'search_controller.g.dart';

@riverpod
class SearchController extends _$SearchController {
  @override
  FutureOr<List<SearchItem>> build() async {
    final repo = ref.watch(searchRepositoryProvider);
    return repo.searchItems('');
  }

  Future<void> search(String query) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(searchRepositoryProvider);
      return repo.searchItems(query);
    });
  }
}



