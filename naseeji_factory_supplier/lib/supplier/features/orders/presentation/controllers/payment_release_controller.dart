import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/payment_release.dart';
import '../../data/repositories/orders_repository_impl.dart';

part 'payment_release_controller.g.dart';

@riverpod
class PaymentReleaseController extends _$PaymentReleaseController {
  @override
  FutureOr<PaymentRelease> build(String rfqId) async {
    final repo = ref.watch(ordersRepositoryProvider);
    return repo.getPaymentRelease(rfqId);
  }
}

