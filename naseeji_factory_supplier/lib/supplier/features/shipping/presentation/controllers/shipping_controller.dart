import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/shipment.dart';
import '../../data/repositories/shipping_repository_impl.dart';

part 'shipping_controller.g.dart';

@riverpod
class ShippingController extends _$ShippingController {
  @override
  FutureOr<List<Shipment>> build() async {
    final repo = ref.watch(shippingRepositoryProvider);
    return repo.getShipments();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(shippingRepositoryProvider);
      return repo.getShipments();
    });
  }

  Future<void> updateStatus(String id, ShipmentStatus status) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(shippingRepositoryProvider);
      await repo.updateShipmentStatus(id, status);
      return repo.getShipments();
    });
  }

  Future<void> scheduleCarrierPickup(String id, {required String driverName, required String driverPhone, required String vehicleNum}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(shippingRepositoryProvider);
      await repo.schedulePickup(id, driverName: driverName, driverPhone: driverPhone, vehicleNum: vehicleNum);
      return repo.getShipments();
    });
  }

  Future<void> selectCarrierDetails(String id, {required String carrier, required String method}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(shippingRepositoryProvider);
      await repo.selectCarrier(id, carrier: carrier, method: method);
      return repo.getShipments();
    });
  }

  Future<void> uploadProofMedia(String id, String category, String path) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(shippingRepositoryProvider);
      await repo.uploadMedia(id, category, path);
      return repo.getShipments();
    });
  }

  Future<void> uploadCommercialDoc(String id, String type, String name, String url) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(shippingRepositoryProvider);
      await repo.uploadDocument(id, type, name, url);
      return repo.getShipments();
    });
  }

  Future<void> reportLogisticsIssue(String id, {required String category, required String description, required String priority, List<String> attachments = const []}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(shippingRepositoryProvider);
      await repo.reportIssue(id, category: category, description: description, priority: priority, attachments: attachments);
      return repo.getShipments();
    });
  }
}


