import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quotations_provider.g.dart';

class QuotationRevision {
  final int revisionNumber;
  final String date;
  final String user; // المصنع, المورد
  final double price;
  final int quantity;
  final String deliveryDate;
  final String paymentTerms;
  final String changes;
  final String notes;

  const QuotationRevision({
    required this.revisionNumber,
    required this.date,
    required this.user,
    required this.price,
    required this.quantity,
    required this.deliveryDate,
    required this.paymentTerms,
    required this.changes,
    required this.notes,
  });
}

class Quotation {
  final String id;
  final String rfqId;
  final String supplierId;
  final String supplierName;
  final double quotedPricePerUnit;
  final int moq;
  final int prepTimeDays;
  final int shippingTimeDays;
  final double supplierRating;
  final String offerDate;
  final String status; // received, negotiating, accepted, rejected
  final String currency;
  final String paymentMethod;
  final String warranty;
  final String validUntil;
  final List<String> attachments;
  final String supplierNotes;
  final List<QuotationRevision> revisions;

  const Quotation({
    required this.id,
    required this.rfqId,
    required this.supplierId,
    required this.supplierName,
    required this.quotedPricePerUnit,
    required this.moq,
    required this.prepTimeDays,
    required this.shippingTimeDays,
    required this.supplierRating,
    required this.offerDate,
    required this.status,
    required this.currency,
    required this.paymentMethod,
    required this.warranty,
    required this.validUntil,
    required this.attachments,
    required this.supplierNotes,
    required this.revisions,
  });

  Quotation copyWith({
    String? status,
    double? quotedPricePerUnit,
    List<QuotationRevision>? revisions,
  }) {
    return Quotation(
      id: id,
      rfqId: rfqId,
      supplierId: supplierId,
      supplierName: supplierName,
      quotedPricePerUnit: quotedPricePerUnit ?? this.quotedPricePerUnit,
      moq: moq,
      prepTimeDays: prepTimeDays,
      shippingTimeDays: shippingTimeDays,
      supplierRating: supplierRating,
      offerDate: offerDate,
      status: status ?? this.status,
      currency: currency,
      paymentMethod: paymentMethod,
      warranty: warranty,
      validUntil: validUntil,
      attachments: attachments,
      supplierNotes: supplierNotes,
      revisions: revisions ?? this.revisions,
    );
  }
}

@riverpod
class QuotationsNotifier extends _$QuotationsNotifier {
  @override
  List<Quotation> build() {
    return _mockQuotations;
  }

  void acceptQuotation(String quoteId) {
    state = [
      for (final q in state)
        if (q.id == quoteId) q.copyWith(status: 'accepted') else q
    ];
  }

  void rejectQuotation(String quoteId, String reason, String comment) {
    state = [
      for (final q in state)
        if (q.id == quoteId) q.copyWith(status: 'rejected') else q
    ];
  }

  void sendCounterOffer(
    String quoteId, {
    required double price,
    required int quantity,
    required String deliveryDate,
    required String paymentTerms,
    required String notes,
  }) {
    state = [
      for (final q in state)
        if (q.id == quoteId)
          q.copyWith(
            status: 'negotiating',
            quotedPricePerUnit: price,
            revisions: [
              ...q.revisions,
              QuotationRevision(
                revisionNumber: q.revisions.length + 1,
                date: '٢٠٢٦/٠٧/١٤',
                user: 'المصنع',
                price: price,
                quantity: quantity,
                deliveryDate: deliveryDate,
                paymentTerms: paymentTerms,
                changes: 'تعديل السعر المقترح ليكون $price ج.م والكمية لتكون $quantity وحدة.',
                notes: notes,
              ),
            ],
          )
        else
          q
    ];
  }

  List<Quotation> getQuotationsForRFQ(String rfqId) {
    return state.where((q) => q.rfqId == rfqId).toList();
  }

  Quotation? getQuotationById(String id) {
    try {
      return state.firstWhere((q) => q.id == id);
    } catch (_) {
      return null;
    }
  }
}

@riverpod
class SelectedQuotesComparison extends _$SelectedQuotesComparison {
  @override
  List<String> build() {
    return [];
  }

  void toggleComparison(String id) {
    if (state.contains(id)) {
      state = state.where((item) => item != id).toList();
    } else {
      if (state.length < 3) {
        state = [...state, id];
      }
    }
  }

  void clear() {
    state = [];
  }
}

final List<Quotation> _mockQuotations = [
  const Quotation(
    id: 'QTE-101',
    rfqId: 'RFQ-2026-001',
    supplierId: 'sup_1',
    supplierName: 'شركة غزل المحلة الكبرى',
    quotedPricePerUnit: 142.0,
    moq: 500,
    prepTimeDays: 7,
    shippingTimeDays: 2,
    supplierRating: 4.8,
    offerDate: '٢٠٢٦/٠٧/١٢',
    status: 'received',
    currency: 'ج.م',
    paymentMethod: 'دفع مقدم 30% وباقي القيمة عند الاستلام بموجب فواتير مقبولة الدفع.',
    warranty: 'شهادة ضمان الجودة والنعومة لمدة سنة كاملة ضد عيوب التحضير أو الغزل.',
    validUntil: '٢٠٢٦/٠٨/١٥',
    attachments: ['عرض_سعر_غزل_المحلة.pdf'],
    supplierNotes: 'يسعدنا تقديم هذا العرض المغري للكميات الكبيرة لمنتج خيوط قطنية ممشطة نمرة 30/1 سوبر. العرض ساري لمدة شهر فقط للتثبيت.',
    revisions: [
      QuotationRevision(
        revisionNumber: 1,
        date: '٢٠٢٦/٠٧/١٢',
        user: 'المورد',
        price: 142.0,
        quantity: 10000,
        deliveryDate: '٢٠٢٦/٠٨/١٥',
        paymentTerms: 'مقدم 30% والباقي تسليم',
        changes: 'الإصدار الأولي لعرض السعر.',
        notes: 'يسعدنا التعامل معكم.',
      ),
    ],
  ),
  const Quotation(
    id: 'QTE-102',
    rfqId: 'RFQ-2026-001',
    supplierId: 'sup_2',
    supplierName: 'مصنع النيل للأقمشة الحديثة',
    quotedPricePerUnit: 148.0,
    moq: 200,
    prepTimeDays: 12,
    shippingTimeDays: 3,
    supplierRating: 4.6,
    offerDate: '٢٠٢٦/٠٧/١١',
    status: 'received',
    currency: 'ج.م',
    paymentMethod: 'كاش عند الاستلام أو تحويل بنكي على حساب المصنع بمصرف الرافدين.',
    warranty: 'ضمان كامل ضد الخدش أو تمزق الخصل ونسيج القطن.',
    validUntil: '٢٠٢٦/٠٨/١٢',
    attachments: ['ملف_النيل_للصباغة.pdf'],
    supplierNotes: 'يمكن تجهيز الشحنات بسرعة خلال ١٢ يوماً كأقصى حد.',
    revisions: [
      QuotationRevision(
        revisionNumber: 1,
        date: '٢٠٢٦/٠٧/١١',
        user: 'المورد',
        price: 148.0,
        quantity: 10000,
        deliveryDate: '٢٠٢٦/٠٨/١٥',
        paymentTerms: 'كاش عند الاستلام',
        changes: 'تقديم العرض الأول.',
        notes: 'يرجى مراجعة المواصفات.',
      ),
    ],
  ),
  const Quotation(
    id: 'QTE-103',
    rfqId: 'RFQ-2026-001',
    supplierId: 'sup_3',
    supplierName: 'الفتح لخيوط البوليستر ومستلزمات المصانع',
    quotedPricePerUnit: 135.0,
    moq: 1000,
    prepTimeDays: 5,
    shippingTimeDays: 4,
    supplierRating: 4.2,
    offerDate: '٢٠٢٦/٠٧/١٣',
    status: 'negotiating',
    currency: 'ج.م',
    paymentMethod: 'دفعات ربع سنوية أو بالاتفاق.',
    warranty: 'لا يوجد.',
    validUntil: '٢٠٢٦/٠٨/٢٥',
    attachments: ['فتح_تطريز_خامات.xlsx'],
    supplierNotes: 'سعر منافس جداً وخيوط بوليستر مستوردة نخب أول.',
    revisions: [
      QuotationRevision(
        revisionNumber: 1,
        date: '٢٠٢٦/٠٧/١٣',
        user: 'المورد',
        price: 135.0,
        quantity: 10000,
        deliveryDate: '٢٠٢٦/٠٨/١٥',
        paymentTerms: 'دفعات بالاتفاق',
        changes: 'العرض الأولي.',
        notes: 'أفضل سعر خيوط بوليستر.',
      ),
    ],
  ),
];
