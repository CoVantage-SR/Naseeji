import '../entities/shipment.dart';

abstract class ShippingRepository {
  Future<List<Shipment>> getShipments();
  Future<Shipment?> getShipmentDetails(String id);
  Future<void> updateShipmentStatus(String id, ShipmentStatus status);
  Future<void> schedulePickup(String id, {required String driverName, required String driverPhone, required String vehicleNum});
  Future<void> selectCarrier(String id, {required String carrier, required String method});
  Future<void> uploadMedia(String id, String category, String path);
  Future<void> uploadDocument(String id, String type, String name, String url);
  Future<void> reportIssue(String id, {required String category, required String description, required String priority, List<String> attachments});
}



