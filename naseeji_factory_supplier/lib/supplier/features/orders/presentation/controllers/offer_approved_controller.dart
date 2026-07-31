import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/offer_approved.dart';
import '../../data/repositories/orders_repository_impl.dart';

part 'offer_approved_controller.g.dart';

@riverpod
class OfferApprovedController extends _$OfferApprovedController {
  @override
  FutureOr<OfferApproved> build(String rfqId) async {
    final repo = ref.watch(ordersRepositoryProvider);
    return repo.getOfferApproved(rfqId);
  }
}



