import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/shipping_manifest.dart';
import '../../data/repositories/orders_repository_impl.dart';

part 'shipping_manifest_controller.g.dart';

@riverpod
class ShippingManifestController extends _$ShippingManifestController {
  @override
  FutureOr<ShippingManifest> build(String rfqId) async {
    final repo = ref.watch(ordersRepositoryProvider);
    return repo.getShippingManifest(rfqId);
  }
}
