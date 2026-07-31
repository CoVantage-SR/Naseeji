import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/quotation_model.dart';
import '../../data/repositories/quotations_repository_impl.dart';

part 'quotations_controller.g.dart';

@riverpod
class QuotationsController extends _$QuotationsController {
  @override
  FutureOr<List<QuotationModel>> build() async {
    final repo = ref.watch(quotationsRepositoryProvider);
    return repo.getQuotations();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(quotationsRepositoryProvider);
      return repo.getQuotations();
    });
  }

  Future<void> save(QuotationModel quotation) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(quotationsRepositoryProvider);
      await repo.saveQuotation(quotation);
      return repo.getQuotations();
    });
  }

  Future<void> delete(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(quotationsRepositoryProvider);
      await repo.deleteQuotation(id);
      return repo.getQuotations();
    });
  }

  Future<void> send(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(quotationsRepositoryProvider);
      await repo.sendQuotation(id);
      return repo.getQuotations();
    });
  }

  Future<void> withdraw(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(quotationsRepositoryProvider);
      await repo.withdrawQuotation(id);
      return repo.getQuotations();
    });
  }

  Future<void> accept(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(quotationsRepositoryProvider);
      await repo.acceptQuotation(id);
      return repo.getQuotations();
    });
  }

  Future<void> reject(String id, String reason) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(quotationsRepositoryProvider);
      await repo.rejectQuotation(id, reason);
      return repo.getQuotations();
    });
  }

  Future<void> duplicate(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(quotationsRepositoryProvider);
      final list = await repo.getQuotations();
      final index = list.indexWhere((q) => q.id == id);
      if (index != -1) {
        final original = list[index];
        final newId = 'QT-${1000 + DateTime.now().millisecond}';
        final duplicated = original.copyWith(
          id: newId,
          version: '1.0',
          status: QuotationStatus.draft,
          createdDate: DateTime.now().toString().split(' ')[0],
          lastUpdated: DateTime.now().toString().split(' ')[0],
          rejectionReason: null,
          revisions: [],
          timeline: [
            QuotationTimelineStep(
              title: 'تم تكرار العرض من $id',
              date: DateTime.now().toString().split(' ')[0],
              time: '00:00 ص',
              responsibleUser: 'مورد نسيجي',
              status: 'مكتمل',
              notes: 'عرض جديد مكرر من النسخة السابقة $id.',
            ),
          ],
        );
        await repo.saveQuotation(duplicated);
      }
      return repo.getQuotations();
    });
  }

  Future<void> renew(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(quotationsRepositoryProvider);
      final list = await repo.getQuotations();
      final index = list.indexWhere((q) => q.id == id);
      if (index != -1) {
        final original = list[index];
        final renewed = original.copyWith(
          status: QuotationStatus.draft,
          expirationDate: DateTime.now().add(const Duration(days: 7)).toString().split(' ')[0],
          lastUpdated: DateTime.now().toString().split(' ')[0],
          timeline: List.from(original.timeline)
            ..add(QuotationTimelineStep(
              title: 'تجديد عرض السعر',
              date: DateTime.now().toString().split(' ')[0],
              time: '00:00 ص',
              responsibleUser: 'مورد نسيجي',
              status: 'مكتمل',
              notes: 'تم تجديد العرض وتمديد فترة الصلاحية لأسبوع إضافي.',
            )),
        );
        await repo.saveQuotation(renewed);
      }
      return repo.getQuotations();
    });
  }

  Future<void> sendCounterOffer(String id, double newPrice, String notes) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(quotationsRepositoryProvider);
      final list = await repo.getQuotations();
      final index = list.indexWhere((q) => q.id == id);
      if (index != -1) {
        final original = list[index];
        final double currentVer = double.tryParse(original.version) ?? 1.0;
        final nextVerStr = (currentVer + 1.0).toStringAsFixed(1);
        
        final newRevision = QuotationRevisionModel(
          version: 'v$nextVerStr',
          supplierPrice: newPrice,
          factoryCounterOffer: original.supplierUnitPrice, // Old price
          priceDifference: (original.supplierUnitPrice - newPrice).abs(),
          reason: notes,
          createdDate: DateTime.now().toString().split(' ')[0],
          negotiatedBy: 'مورد نسيجي',
          status: 'تحت المفاوضات النشطة',
        );

        final newTimelineStep = QuotationTimelineStep(
          title: 'إرسال عرض مقابل بقيمة $newPrice جنيه',
          date: DateTime.now().toString().split(' ')[0],
          time: '00:00 ص',
          responsibleUser: 'مورد نسيجي',
          status: 'مكتمل',
          notes: notes,
        );

        // Recalculate Grand Total
        final subtotal = newPrice * original.quantity;
        final tax = subtotal * (original.taxes / (original.supplierUnitPrice * original.quantity));
        final grandTotal = subtotal - original.discount + tax + original.shippingCost + original.additionalCharges;

        final updated = original.copyWith(
          version: nextVerStr,
          supplierUnitPrice: newPrice,
          grandTotal: grandTotal,
          status: QuotationStatus.underNegotiation,
          lastUpdated: DateTime.now().toString().split(' ')[0],
          revisions: List.from(original.revisions)..add(newRevision),
          timeline: List.from(original.timeline)..add(newTimelineStep),
        );
        await repo.saveQuotation(updated);
      }
      return repo.getQuotations();
    });
  }
}

