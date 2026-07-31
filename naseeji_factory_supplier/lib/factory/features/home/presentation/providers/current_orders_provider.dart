import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/home_entities.dart';
import 'home_repository_provider.dart';

part 'current_orders_provider.g.dart';

@riverpod
Future<List<CurrentOrder>> currentOrders(CurrentOrdersRef ref) {
  return ref.watch(homeRepositoryProvider).getCurrentOrders();
}

