import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/quotation_revision.dart';
import '../../data/repositories/orders_repository_impl.dart';

part 'quotation_history_controller.g.dart';

@riverpod
class QuotationHistoryController extends _$QuotationHistoryController {
  @override
  FutureOr<List<QuotationRevision>> build(String rfqId) async {
    final repo = ref.watch(ordersRepositoryProvider);
    return repo.getQuotationHistory(rfqId);
  }
}

