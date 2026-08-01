import 'service_locator.dart';
import '../services/image_picker_service.dart';
import '../services/network_monitor_service.dart';
import '../services/permission_service.dart';
import '../services/storage_service.dart';

class RegisterServices {
  static void init() {
    if (!ServiceLocator.isRegistered<ImagePickerService>()) {
      ServiceLocator.register<ImagePickerService>(ImagePickerService());
    }
    if (!ServiceLocator.isRegistered<PermissionService>()) {
      ServiceLocator.register<PermissionService>(PermissionService());
    }
    if (!ServiceLocator.isRegistered<StorageService>()) {
      ServiceLocator.register<StorageService>(StorageService());
    }
    if (!ServiceLocator.isRegistered<NetworkMonitorService>()) {
      ServiceLocator.register<NetworkMonitorService>(NetworkMonitorService());
    }
  }
}
