import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/home_entities.dart';
import 'home_repository_provider.dart';

part 'shipment_provider.g.dart';

@riverpod
Future<List<Shipment>> shipment(ShipmentRef ref) {
  return ref.watch(homeRepositoryProvider).getShipments();
}


