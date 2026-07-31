import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/home_entities.dart';
import 'home_repository_provider.dart';

part 'favorite_suppliers_provider.g.dart';

@riverpod
Future<List<FavoriteSupplier>> favoriteSuppliers(FavoriteSuppliersRef ref) {
  return ref.watch(homeRepositoryProvider).getFavoriteSuppliers();
}

