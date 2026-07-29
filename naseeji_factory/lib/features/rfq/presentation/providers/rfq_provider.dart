import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rfq_provider.g.dart';

// ─────────────────────────────────────────────────────────────
//  Enums & Status
// ─────────────────────────────────────────────────────────────

class RFQStatus {
  static const String open = 'open';
  static const String draft = 'draft';
  static const String sent = 'sent';
  static const String waitingQuotations = 'waitingQuotations';
  static const String receivedQuotations = 'receivedQuotations';
  static const String negotiating = 'negotiating';
  static const String approved = 'approved';
  static const String dealCreated = 'dealCreated';
  static const String cancelled = 'cancelled';
  static const String closed = 'closed';

  static String label(String status) {
    switch (status) {
      case open:
        return 'مفتوح';
      case draft:
        return 'مسودة';
      case sent:
        return 'مرسل';
      case waitingQuotations:
        return 'بانتظار عروض';
      case receivedQuotations:
        return 'عروض مستلمة';
      case negotiating:
        return 'قيد التفاوض';
      case approved:
        return 'معتمد';
      case dealCreated:
        return 'صفقة مُنشأة';
      case cancelled:
        return 'ملغي';
      case closed:
        return 'مغلقة';
      default:
        return status;
    }
  }
}

// ─────────────────────────────────────────────────────────────
//  RFQ Supplier Offer Model
// ─────────────────────────────────────────────────────────────

class RFQOffer {
  final String id;
  final String supplierId;
  final String supplierName;
  final String supplierLogo;
  final bool isVerified;
  final bool isBestOffer;
  final String receivedDate;
  final double totalPrice;
  final String deliveryDays;
  final String paymentTerms;

  const RFQOffer({
    required this.id,
    required this.supplierId,
    required this.supplierName,
    required this.supplierLogo,
    this.isVerified = true,
    this.isBestOffer = false,
    required this.receivedDate,
    required this.totalPrice,
    required this.deliveryDays,
    required this.paymentTerms,
  });
}

// ─────────────────────────────────────────────────────────────
//  Domain Model
// ─────────────────────────────────────────────────────────────

class RFQ {
  final String id;
  final String rfqNumber;
  final String title;
  final String category;
  final String productName;
  final String productImage;
  final int invitedSuppliersCount;
  final int receivedQuotesCount;
  final int negotiatingCount;
  final int unrespondedCount;
  final String createdDate;
  final String closingDate;
  final String remainingDays;
  final String status;
  final int currentStepIndex; // 0: مفتوح, 1: العروض, 2: التفاوض, 3: الموافقة, 4: تم الإغلاق
  final String priority;
  final String description;
  final String material;
  final String color;
  final String size;
  final String qualityLevel;
  final int requestedQty;
  final String unit;
  final List<String> attachments;
  final String deliveryGovernorate;
  final String deliveryCity;
  final String deliveryAddress;
  final String deliveryDate;
  final String paymentTerms;
  final String currency;
  final List<RFQOffer> offers;

  const RFQ({
    required this.id,
    required this.rfqNumber,
    required this.title,
    required this.category,
    required this.productName,
    this.productImage = 'https://images.unsplash.com/photo-1528301721190-186c3bd85418?w=500',
    required this.invitedSuppliersCount,
    required this.receivedQuotesCount,
    this.negotiatingCount = 1,
    this.unrespondedCount = 4,
    required this.createdDate,
    this.closingDate = '25 مايو 2024',
    this.remainingDays = '5 أيام متبقية',
    required this.status,
    this.currentStepIndex = 0,
    required this.priority,
    required this.description,
    required this.material,
    required this.color,
    required this.size,
    required this.qualityLevel,
    required this.requestedQty,
    required this.unit,
    required this.attachments,
    required this.deliveryGovernorate,
    required this.deliveryCity,
    required this.deliveryAddress,
    required this.deliveryDate,
    this.paymentTerms = 'اعتماد مستندي 60 يوم',
    this.currency = 'جنيه مصري (EGP)',
    this.offers = const [],
  });

  RFQ copyWith({
    String? status,
    int? receivedQuotesCount,
    int? invitedSuppliersCount,
    int? currentStepIndex,
    List<RFQOffer>? offers,
  }) {
    return RFQ(
      id: id,
      rfqNumber: rfqNumber,
      title: title,
      category: category,
      productName: productName,
      productImage: productImage,
      invitedSuppliersCount: invitedSuppliersCount ?? this.invitedSuppliersCount,
      receivedQuotesCount: receivedQuotesCount ?? this.receivedQuotesCount,
      negotiatingCount: negotiatingCount,
      unrespondedCount: unrespondedCount,
      createdDate: createdDate,
      closingDate: closingDate,
      remainingDays: remainingDays,
      status: status ?? this.status,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      priority: priority,
      description: description,
      material: material,
      color: color,
      size: size,
      qualityLevel: qualityLevel,
      requestedQty: requestedQty,
      unit: unit,
      attachments: attachments,
      deliveryGovernorate: deliveryGovernorate,
      deliveryCity: deliveryCity,
      deliveryAddress: deliveryAddress,
      deliveryDate: deliveryDate,
      paymentTerms: paymentTerms,
      currency: currency,
      offers: offers ?? this.offers,
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Summary Model
// ─────────────────────────────────────────────────────────────

class RFQSummary {
  final int total;
  final int waitingQuotations;
  final int receivedQuotations;
  final int closed;

  const RFQSummary({
    required this.total,
    required this.waitingQuotations,
    required this.receivedQuotations,
    required this.closed,
  });
}

// ─────────────────────────────────────────────────────────────
//  Tab Filter Enum
// ─────────────────────────────────────────────────────────────

class RFQTab {
  static const String all = 'all';
  static const String drafts = 'draft';
  static const String waitingQuotations = 'waitingQuotations';
  static const String receivedQuotations = 'receivedQuotations';
  static const String closed = 'closed';
}

// ─────────────────────────────────────────────────────────────
//  Main RFQ Notifier
// ─────────────────────────────────────────────────────────────

@riverpod
class RFQNotifier extends _$RFQNotifier {
  @override
  List<RFQ> build() {
    return _mockRFQs;
  }

  void createRFQ({
    required String title,
    required String category,
    required String description,
    required String material,
    required String color,
    required String size,
    required String qualityLevel,
    required int quantity,
    required String unit,
    required String governorate,
    required String city,
    required String address,
    required String deliveryDate,
    required String paymentTerms,
    required String currency,
    required List<String> attachments,
    required bool sendToRecommended,
    required List<String> selectedSupplierIds,
  }) {
    final nextNum = (state.length + 45).toString().padLeft(4, '0');
    final newId = 'RFQ-2024-$nextNum';
    final newRfq = RFQ(
      id: newId,
      rfqNumber: '#$newId',
      title: title.isNotEmpty ? title : 'طلب شراء قماش',
      category: category.isNotEmpty ? category : 'أقمشة وصباغة',
      productName: title.isNotEmpty ? title : 'قماش 100% قطن أبيض',
      productImage: 'https://images.unsplash.com/photo-1528301721190-186c3bd85418?w=500',
      invitedSuppliersCount: sendToRecommended ? 8 : (selectedSupplierIds.isNotEmpty ? selectedSupplierIds.length : 3),
      receivedQuotesCount: 0,
      negotiatingCount: 0,
      unrespondedCount: sendToRecommended ? 8 : 3,
      createdDate: '10 مايو 2024 - 11:30 ص',
      closingDate: '25 مايو 2024',
      remainingDays: '15 يوم متبقي',
      status: RFQStatus.open,
      currentStepIndex: 0,
      priority: 'high',
      description: description.isNotEmpty
          ? description
          : 'نحن نبحث عن موردين موثوقين لتوريد قماش 100% قطن عالية الاستخدام في إنتاج الملابس الجاهزة.',
      material: material.isNotEmpty ? material : 'قطن 100%',
      color: color.isNotEmpty ? color : 'أبيض',
      size: size.isNotEmpty ? size : 'عرض 150 سم',
      qualityLevel: qualityLevel.isNotEmpty ? qualityLevel : 'نخب أول',
      requestedQty: quantity > 0 ? quantity : 10000,
      unit: unit.isNotEmpty ? unit : 'متر طولي',
      attachments: attachments,
      deliveryGovernorate: governorate.isNotEmpty ? governorate : 'الجيزة',
      deliveryCity: city.isNotEmpty ? city : 'السادس من أكتوبر',
      deliveryAddress: address.isNotEmpty ? address : 'المصنع الرئيسي - 6 أكتوبر',
      deliveryDate: deliveryDate.isNotEmpty ? deliveryDate : '2024-06-25',
      paymentTerms: paymentTerms.isNotEmpty ? paymentTerms : 'اعتماد مستندي بعد الاستلام',
      currency: currency.isNotEmpty ? currency : 'جنيه مصري (EGP)',
      offers: [],
    );
    state = [newRfq, ...state];
  }

  void cancelRFQ(String id) {
    state = [
      for (final rfq in state)
        if (rfq.id == id || rfq.rfqNumber == id) rfq.copyWith(status: RFQStatus.cancelled) else rfq
    ];
  }

  void updateRFQStatus(String id, String status) {
    state = [
      for (final rfq in state)
        if (rfq.id == id || rfq.rfqNumber == id) rfq.copyWith(status: status) else rfq
    ];
  }

  void sendRFQ(String id) {
    updateRFQStatus(id, RFQStatus.waitingQuotations);
  }

  void closeRFQ(String id) {
    updateRFQStatus(id, RFQStatus.closed);
  }

  void deleteRFQ(String id) {
    state = state.where((rfq) => rfq.id != id && rfq.rfqNumber != id).toList();
  }

  RFQ? getRFQById(String id) {
    try {
      return state.firstWhere((rfq) => rfq.id == id || rfq.rfqNumber == id);
    } catch (_) {
      return state.isNotEmpty ? state.first : null;
    }
  }
}

// ─────────────────────────────────────────────────────────────
//  Filter Provider
// ─────────────────────────────────────────────────────────────

@riverpod
class RFQFilterNotifier extends _$RFQFilterNotifier {
  @override
  String build() => RFQTab.all;

  void setFilter(String tab) {
    state = tab;
  }
}

// ─────────────────────────────────────────────────────────────
//  Search Provider
// ─────────────────────────────────────────────────────────────

@riverpod
class RFQSearchNotifier extends _$RFQSearchNotifier {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }

  void clear() {
    state = '';
  }
}

// ─────────────────────────────────────────────────────────────
//  Filtered RFQ Provider (Computed)
// ─────────────────────────────────────────────────────────────

@riverpod
List<RFQ> filteredRFQs(FilteredRFQsRef ref) {
  final all = ref.watch(rFQNotifierProvider);
  final filter = ref.watch(rFQFilterNotifierProvider);
  final query = ref.watch(rFQSearchNotifierProvider);

  var result = all;

  if (filter != RFQTab.all) {
    result = result.where((r) => r.status == filter).toList();
  }

  if (query.isNotEmpty) {
    final lower = query.toLowerCase();
    result = result.where((r) {
      return r.id.toLowerCase().contains(lower) ||
          r.rfqNumber.toLowerCase().contains(lower) ||
          r.title.toLowerCase().contains(lower) ||
          r.productName.toLowerCase().contains(lower) ||
          r.category.toLowerCase().contains(lower);
    }).toList();
  }

  return result;
}

// ─────────────────────────────────────────────────────────────
//  Summary Provider (Computed)
// ─────────────────────────────────────────────────────────────

@riverpod
RFQSummary rfqSummary(RfqSummaryRef ref) {
  final all = ref.watch(rFQNotifierProvider);
  return RFQSummary(
    total: all.length,
    waitingQuotations: all.where((r) => r.status == RFQStatus.waitingQuotations).length,
    receivedQuotations: all.where((r) => r.status == RFQStatus.receivedQuotations).length,
    closed: all.where((r) => r.status == RFQStatus.closed).length,
  );
}

// ─────────────────────────────────────────────────────────────
//  Mock Data (Matches Reference Image 1 exactly)
// ─────────────────────────────────────────────────────────────

final List<RFQ> _mockRFQs = [
  const RFQ(
    id: 'RFQ-2024-0045',
    rfqNumber: '#RFQ-2024-0045',
    title: 'طلب شراء قماش',
    productName: 'قماش 100% قطن',
    productImage: 'https://images.unsplash.com/photo-1528301721190-186c3bd85418?w=500',
    category: 'أقمشة وصباغة',
    invitedSuppliersCount: 8,
    receivedQuotesCount: 3,
    negotiatingCount: 1,
    unrespondedCount: 4,
    createdDate: '10 مايو 2024 - 11:30 ص',
    closingDate: '25 مايو 2024',
    remainingDays: '5 أيام متبقية',
    status: RFQStatus.open,
    currentStepIndex: 0, // 0: مفتوح, 1: العروض, 2: التفاوض, 3: الموافقة, 4: تم الإغلاق
    priority: 'high',
    description:
        'نحن نبحث عن موردين موثوقين لتوريد قماش 100% قطن عالية الاستخدام في إنتاج الملابس الجاهزة. نفضل التعامل مع موردين لديهم خبرة في التصدير والتوريد المستمر.',
    material: 'قطن 100%',
    color: 'أبيض',
    size: 'عرض 150 سم - 140 جم/م²',
    qualityLevel: 'نخب أول تصديري',
    requestedQty: 10000,
    unit: 'متر طولي',
    attachments: ['مواصفات_القماش_القياسية.pdf'],
    deliveryGovernorate: 'الدقهلية',
    deliveryCity: 'المنصورة',
    deliveryAddress: 'المنصورة، مصر',
    deliveryDate: '7 - 10 يونيو 2024',
    paymentTerms: 'اعتماد مستندي 60 يوم',
    currency: 'جنيه مصري (EGP)',
    offers: [
      RFQOffer(
        id: 'OFFER-101',
        supplierId: 'sup_1',
        supplierName: 'مصر للغزل والنسيج',
        supplierLogo: 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=150',
        isVerified: true,
        isBestOffer: true,
        receivedDate: 'تم الاستلام في 12 مايو 2024 - 09:15 ص',
        totalPrice: 426000.0,
        deliveryDays: '7 أيام',
        paymentTerms: 'اعتماد مستندي 60 يوم',
      ),
      RFQOffer(
        id: 'OFFER-102',
        supplierId: 'sup_2',
        supplierName: 'النساجون المصريون',
        supplierLogo: 'https://images.unsplash.com/photo-1544816155-12df9643f363?w=150',
        isVerified: true,
        isBestOffer: false,
        receivedDate: 'تم الاستلام في 12 مايو 2024 - 11:40 ص',
        totalPrice: 432500.0,
        deliveryDays: '10 أيام',
        paymentTerms: 'تحويل بنكي',
      ),
      RFQOffer(
        id: 'OFFER-103',
        supplierId: 'sup_3',
        supplierName: 'القاهرة للغزل والنسيج',
        supplierLogo: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=150',
        isVerified: true,
        isBestOffer: false,
        receivedDate: 'تم الاستلام في 13 مايو 2024 - 02:20 م',
        totalPrice: 445000.0,
        deliveryDays: '7 أيام',
        paymentTerms: 'اعتماد مستندي 45 يوم',
      ),
    ],
  ),
];
