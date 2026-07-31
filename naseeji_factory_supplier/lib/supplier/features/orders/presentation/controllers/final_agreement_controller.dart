import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/final_agreement.dart';
import '../../data/repositories/orders_repository_impl.dart';

part 'final_agreement_controller.g.dart';

@riverpod
class FinalAgreementController extends _$FinalAgreementController {
  @override
  FutureOr<FinalAgreement> build(String rfqId) async {
    final repo = ref.watch(ordersRepositoryProvider);
    return repo.getFinalAgreement(rfqId);
  }
}


