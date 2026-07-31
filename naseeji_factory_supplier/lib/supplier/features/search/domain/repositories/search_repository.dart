import '../entities/search_item.dart';

abstract class SearchRepository {
  Future<List<SearchItem>> searchItems(String query);
}
