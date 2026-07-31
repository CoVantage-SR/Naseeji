import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/offer_details.dart';
import '../../data/repositories/orders_repository_impl.dart';

part 'offer_details_controller.g.dart';

@riverpod
class OfferDetailsController extends _$OfferDetailsController {
  @override
  FutureOr<OfferDetails> build(String rfqId) async {
    final repo = ref.watch(ordersRepositoryProvider);
    return repo.getOfferDetails(rfqId);
  }
}



