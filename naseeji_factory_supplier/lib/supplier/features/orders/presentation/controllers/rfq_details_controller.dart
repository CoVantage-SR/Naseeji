import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/rfq_details.dart';
import '../../data/repositories/orders_repository_impl.dart';

part 'rfq_details_controller.g.dart';

@riverpod
class RfqDetailsController extends _$RfqDetailsController {
  @override
  FutureOr<RfqDetails> build(String rfqId) async {
    final repo = ref.watch(ordersRepositoryProvider);
    return repo.getRfqDetails(rfqId);
  }
}


