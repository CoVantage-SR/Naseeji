import 'order_state_machine.dart';

enum UserRole {
  supplier,
  factory,
  admin,
}

class OrderPermissionService {
  static bool canPerformAction({
    required UserRole role,
    required OrderStatus status,
    required String action,
  }) {
    if (role == UserRole.admin) return true;

    // Supplier restrictions
    if (role == UserRole.supplier) {
      if (action == 'release_payment') return false;
      if (action == 'approve_preparation') return false;
      if (action == 'confirm_delivery') return false;
      
      if (action == 'create_shipment') {
        // Shipment can only be created once the factory reviews and approves preparation (status goes to shipmentCreated)
        return status == OrderStatus.shipmentCreated;
      }
      return true;
    }

    // Factory restrictions
    if (role == UserRole.factory) {
      if (action == 'edit_quotation' && status == OrderStatus.finalAgreement) {
        return false;
      }
      if (action == 'update_preparation_progress') return false;
      if (action == 'mark_as_shipped') return false;
      return true;
    }

    return false;
  }
}


