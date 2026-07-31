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

class QuotationDocument {
  final String name;
  final String type; // PDF, ZIP
  final String size;

  const QuotationDocument({
    required this.name,
    required this.type,
    required this.size,
  });
}

class Quotation {
  final String id;
  final String quotationNumber;
  final String rfqId;
  final String rfqNumber;
  final String supplierId;
  final String supplierName;
  final String supplierLogo;
  final bool supplierVerified;
  final int supplierReviewsCount;
  final int completedDealsCount;
  final String deliveryCommitmentRate;
  final String lastActive;

  // Scores
  final int overallScore;
  final int previousCommitmentScore;
  final int supplierRatingScore;
  final int deliveryScore;
  final int priceScore;

  // Offer Details
  final double quotedPricePerUnit;
  final double totalPrice;
  final int requestedQuantity;
  final int moq;
  final int prepTimeDays;
  final int shippingTimeDays;
  final double supplierRating;
  final String offerDate;
  final String submissionTime;
  final String status; // received, negotiating, accepted, rejected
  final String currency;
  final String paymentMethod;
  final String warranty;
  final String validUntil;
  final String remainingDays;
  final String countryOfOrigin;
  final String priceRange;
  final String offerRank;

  final List<String> attachments;
  final List<QuotationDocument> docAttachments;
  final String supplierNotes;
  final List<QuotationRevision> revisions;

  const Quotation({
    required this.id,
    this.quotationNumber = 'QTN-2024-0018',
    required this.rfqId,
    this.rfqNumber = 'RFQ-2024-0045',
    required this.supplierId,
    required this.supplierName,
    this.supplierLogo = 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=150',
    this.supplierVerified = true,
    this.supplierReviewsCount = 128,
    this.completedDealsCount = 320,
    this.deliveryCommitmentRate = '96%',
    this.lastActive = 'أخر تواجد اليوم',
    this.overallScore = 93,
    this.previousCommitmentScore = 97,
    this.supplierRatingScore = 95,
    this.deliveryScore = 88,
    this.priceScore = 92,
    required this.quotedPricePerUnit,
    this.totalPrice = 426000.0,
    this.requestedQuantity = 10000,
    required this.moq,
    required this.prepTimeDays,
    required this.shippingTimeDays,
    required this.supplierRating,
    required this.offerDate,
    this.submissionTime = 'تم استلامه في 12 مايو 2024 - 09:15 ص',
    required this.status,
    required this.currency,
    required this.paymentMethod,
    required this.warranty,
    required this.validUntil,
    this.remainingDays = '13 يوم متبقية',
    this.countryOfOrigin = 'مصر 🇪🇬',
    this.priceRange = '35.00 - 38.50 ج.م',
    this.offerRank = '#1 مِّن 44',
    required this.attachments,
    this.docAttachments = const [
      QuotationDocument(name: 'عرض السعر التفصيلي', type: 'PDF', size: '1.2 MB'),
      QuotationDocument(name: 'كتالوج المنتجات', type: 'PDF', size: '3.5 MB'),
      QuotationDocument(name: 'شهادة ISO 9001 العرض', type: 'PDF', size: '890 KB'),
      QuotationDocument(name: 'صور المنتجات (12)', type: 'ZIP', size: '25 MB'),
    ],
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
      quotationNumber: quotationNumber,
      rfqId: rfqId,
      rfqNumber: rfqNumber,
      supplierId: supplierId,
      supplierName: supplierName,
      supplierLogo: supplierLogo,
      supplierVerified: supplierVerified,
      supplierReviewsCount: supplierReviewsCount,
      completedDealsCount: completedDealsCount,
      deliveryCommitmentRate: deliveryCommitmentRate,
      lastActive: lastActive,
      overallScore: overallScore,
      previousCommitmentScore: previousCommitmentScore,
      supplierRatingScore: supplierRatingScore,
      deliveryScore: deliveryScore,
      priceScore: priceScore,
      quotedPricePerUnit: quotedPricePerUnit ?? this.quotedPricePerUnit,
      totalPrice: totalPrice,
      requestedQuantity: requestedQuantity,
      moq: moq,
      prepTimeDays: prepTimeDays,
      shippingTimeDays: shippingTimeDays,
      supplierRating: supplierRating,
      offerDate: offerDate,
      submissionTime: submissionTime,
      status: status ?? this.status,
      currency: currency,
      paymentMethod: paymentMethod,
      warranty: warranty,
      validUntil: validUntil,
      remainingDays: remainingDays,
      countryOfOrigin: countryOfOrigin,
      priceRange: priceRange,
      offerRank: offerRank,
      attachments: attachments,
      docAttachments: docAttachments,
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
        if (q.id == quoteId || q.quotationNumber == quoteId) q.copyWith(status: 'accepted') else q
    ];
  }

  void rejectQuotation(String quoteId, String reason, String comment) {
    state = [
      for (final q in state)
        if (q.id == quoteId || q.quotationNumber == quoteId) q.copyWith(status: 'rejected') else q
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
        if (q.id == quoteId || q.quotationNumber == quoteId)
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
    return state.where((q) => q.rfqId == rfqId || q.rfqNumber == rfqId).toList();
  }

  Quotation? getQuotationById(String id) {
    try {
      return state.firstWhere((q) => q.id == id || q.quotationNumber == id);
    } catch (_) {
      return state.isNotEmpty ? state.first : null;
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
    id: 'OFFER-101',
    quotationNumber: 'QTN-2024-0018',
    rfqId: 'RFQ-2024-0045',
    rfqNumber: 'RFQ-2024-0045',
    supplierId: 'sup_1',
    supplierName: 'مصر للغزل والنسيج',
    supplierLogo: 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=150',
    supplierVerified: true,
    supplierReviewsCount: 128,
    completedDealsCount: 320,
    deliveryCommitmentRate: '96%',
    lastActive: 'أخر تواجد اليوم',
    overallScore: 93,
    previousCommitmentScore: 97,
    supplierRatingScore: 95,
    deliveryScore: 88,
    priceScore: 92,
    quotedPricePerUnit: 42.0,
    totalPrice: 426000.0,
    requestedQuantity: 10000,
    moq: 500,
    prepTimeDays: 7,
    shippingTimeDays: 2,
    supplierRating: 4.7,
    offerDate: '12 مايو 2024',
    submissionTime: 'تم استلامه في 12 مايو 2024 - 09:15 ص',
    status: 'received',
    currency: 'جنيه مصري (EGP)',
    paymentMethod: 'اعتماد مستندي 60 يوم',
    warranty: 'شهادة ضمان الجودة والنعومة لمدة سنة كاملة ضد عيوب التحضير أو الغزل.',
    validUntil: '25 مايو 2024',
    remainingDays: '13 يوم متبقية',
    countryOfOrigin: 'مصر 🇪🇬',
    priceRange: '35.00 - 38.50 ج.م',
    offerRank: '#1 مِّن 44',
    attachments: ['عرض_سعر_مصر_للغزل.pdf'],
    docAttachments: [
      QuotationDocument(name: 'عرض السعر التفصيلي', type: 'PDF', size: '1.2 MB'),
      QuotationDocument(name: 'كتالوج المنتجات', type: 'PDF', size: '3.5 MB'),
      QuotationDocument(name: 'شهادة ISO 9001 العرض', type: 'PDF', size: '890 KB'),
      QuotationDocument(name: 'صور المنتجات (12)', type: 'ZIP', size: '25 MB'),
    ],
    supplierNotes: 'يسعدنا تقديم هذا العرض المنافس لتوريد قماش 100% قطن أبيض بمواصفات تصديرية قياسية.',
    revisions: [
      QuotationRevision(
        revisionNumber: 1,
        date: '12 مايو 2024',
        user: 'المورد',
        price: 42.0,
        quantity: 10000,
        deliveryDate: '25 مايو 2024',
        paymentTerms: 'اعتماد مستندي 60 يوم',
        changes: 'الإصدار الأولي لعرض السعر.',
        notes: 'يسعدنا التعامل معكم.',
      ),
    ],
  ),
  const Quotation(
    id: 'OFFER-102',
    quotationNumber: 'QTN-2024-0019',
    rfqId: 'RFQ-2024-0045',
    rfqNumber: 'RFQ-2024-0045',
    supplierId: 'sup_2',
    supplierName: 'النساجون المصريون',
    supplierLogo: 'https://images.unsplash.com/photo-1544816155-12df9643f363?w=150',
    supplierVerified: true,
    supplierReviewsCount: 86,
    completedDealsCount: 210,
    deliveryCommitmentRate: '94%',
    lastActive: 'أخر تواجد منذ ساعتين',
    overallScore: 89,
    previousCommitmentScore: 92,
    supplierRatingScore: 90,
    deliveryScore: 85,
    priceScore: 90,
    quotedPricePerUnit: 43.25,
    totalPrice: 432500.0,
    requestedQuantity: 10000,
    moq: 300,
    prepTimeDays: 10,
    shippingTimeDays: 3,
    supplierRating: 4.5,
    offerDate: '12 مايو 2024',
    submissionTime: 'تم استلامه في 12 مايو 2024 - 11:40 ص',
    status: 'received',
    currency: 'جنيه مصري (EGP)',
    paymentMethod: 'تحويل بنكي',
    warranty: 'ضمان كامل ضد الخدش أو تمزق النسيج.',
    validUntil: '25 مايو 2024',
    remainingDays: '13 يوم متبقية',
    countryOfOrigin: 'مصر 🇪🇬',
    priceRange: '35.00 - 38.50 ج.م',
    offerRank: '#2 مِّن 44',
    attachments: ['ملف_النساجون_المصريون.pdf'],
    docAttachments: [
      QuotationDocument(name: 'عرض السعر التفصيلي', type: 'PDF', size: '1.5 MB'),
    ],
    supplierNotes: 'يمكن تجهيز الشحنات بسرعة خلال 10 أيام.',
    revisions: [
      QuotationRevision(
        revisionNumber: 1,
        date: '12 مايو 2024',
        user: 'المورد',
        price: 43.25,
        quantity: 10000,
        deliveryDate: '25 مايو 2024',
        paymentTerms: 'تحويل بنكي',
        changes: 'تقديم العرض الأول.',
        notes: 'يرجى مراجعة المواصفات.',
      ),
    ],
  ),
];



