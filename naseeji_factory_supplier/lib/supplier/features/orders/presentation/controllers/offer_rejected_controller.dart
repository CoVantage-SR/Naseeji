import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/offer_rejected.dart';
import '../../data/repositories/orders_repository_impl.dart';

part 'offer_rejected_controller.g.dart';

@riverpod
class OfferRejectedController extends _$OfferRejectedController {
  @override
  FutureOr<OfferRejected> build(String rfqId) async {
    final repo = ref.watch(ordersRepositoryProvider);
    return repo.getOfferRejected(rfqId);
  }
}

