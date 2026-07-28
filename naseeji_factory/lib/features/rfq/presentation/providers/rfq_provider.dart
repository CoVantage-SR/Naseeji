import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rfq_provider.g.dart';

// ─────────────────────────────────────────────────────────────
//  Enums & Status
// ─────────────────────────────────────────────────────────────

/// Status lifecycle: draft → sent → waitingQuotations → receivedQuotations
/// → negotiating → approved → dealCreated | cancelled | closed
class RFQStatus {
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
      case draft:
        return 'مسودة';
      case sent:
        return 'مرسل';
      case waitingQuotations:
        return 'بانتظار عروض';
      case receivedQuotations:
        return 'عروض مستلمة';
      case negotiating:
        return 'جاري التقييم';
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
//  Domain Model
// ─────────────────────────────────────────────────────────────

class RFQ {
  final String id;
  final String title;
  final String category;
  final String productName;
  final int invitedSuppliersCount;
  final int receivedQuotesCount;
  final String createdDate;
  final String expiryDate;
  final String status;
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

  const RFQ({
    required this.id,
    required this.title,
    required this.category,
    required this.productName,
    required this.invitedSuppliersCount,
    required this.receivedQuotesCount,
    required this.createdDate,
    required this.expiryDate,
    required this.status,
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
  });

  RFQ copyWith({
    String? status,
    int? receivedQuotesCount,
    int? invitedSuppliersCount,
  }) {
    return RFQ(
      id: id,
      title: title,
      category: category,
      productName: productName,
      invitedSuppliersCount: invitedSuppliersCount ?? this.invitedSuppliersCount,
      receivedQuotesCount: receivedQuotesCount ?? this.receivedQuotesCount,
      createdDate: createdDate,
      expiryDate: expiryDate,
      status: status ?? this.status,
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
    required List<String> attachments,
    required bool sendToRecommended,
    required List<String> selectedSupplierIds,
  }) {
    final newId = 'RFQ-2024-${(state.length + 101).toString().padLeft(4, '0')}';
    final newRfq = RFQ(
      id: newId,
      title: title,
      category: category,
      productName: title,
      invitedSuppliersCount: sendToRecommended ? 4 : selectedSupplierIds.length,
      receivedQuotesCount: 0,
      createdDate: '2024/07/28',
      expiryDate: '2024/08/28',
      status: RFQStatus.draft,
      priority: 'medium',
      description: description,
      material: material,
      color: color,
      size: size,
      qualityLevel: qualityLevel,
      requestedQty: quantity,
      unit: unit,
      attachments: attachments,
      deliveryGovernorate: governorate,
      deliveryCity: city,
      deliveryAddress: address,
      deliveryDate: deliveryDate,
    );
    state = [newRfq, ...state];
  }

  void cancelRFQ(String id) {
    state = [
      for (final rfq in state)
        if (rfq.id == id) rfq.copyWith(status: RFQStatus.cancelled) else rfq
    ];
  }

  void updateRFQStatus(String id, String status) {
    state = [
      for (final rfq in state)
        if (rfq.id == id) rfq.copyWith(status: status) else rfq
    ];
  }

  void sendRFQ(String id) {
    updateRFQStatus(id, RFQStatus.waitingQuotations);
  }

  void closeRFQ(String id) {
    updateRFQStatus(id, RFQStatus.closed);
  }

  void deleteRFQ(String id) {
    state = state.where((rfq) => rfq.id != id).toList();
  }

  RFQ? getRFQById(String id) {
    try {
      return state.firstWhere((rfq) => rfq.id == id);
    } catch (_) {
      return null;
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
//  Mock Data (matches the screenshot exactly)
// ─────────────────────────────────────────────────────────────

final List<RFQ> _mockRFQs = [
  const RFQ(
    id: 'RFQ-2024-0123',
    title: 'طلب شراء خامات قطن',
    productName: 'أقمشة قطنية • 100% قطن',
    category: 'خيوط وتريكو',
    invitedSuppliersCount: 8,
    receivedQuotesCount: 0,
    createdDate: '2024/05/20',
    expiryDate: '2024/06/20',
    status: RFQStatus.waitingQuotations,
    priority: 'high',
    description: 'نبحث عن مورد لتوريد خامات قطنية 100% بكمية 5000 م للموسم الصيفي.',
    material: 'قطن 100%',
    color: 'أبيض خام',
    size: 'عرض 150 سم',
    qualityLevel: 'نخب أول',
    requestedQty: 5000,
    unit: 'م',
    attachments: [],
    deliveryGovernorate: 'الجيزة',
    deliveryCity: 'السادس من أكتوبر',
    deliveryAddress: 'المنطقة الصناعية',
    deliveryDate: '2024/07/01',
  ),
  const RFQ(
    id: 'RFQ-2024-0122',
    title: 'طلب خيوط بوليستر',
    productName: 'خيوط بوليستر DTY',
    category: 'خيوط وتريكو',
    invitedSuppliersCount: 5,
    receivedQuotesCount: 5,
    createdDate: '2024/05/19',
    expiryDate: '2024/06/19',
    status: RFQStatus.receivedQuotations,
    priority: 'medium',
    description: 'نريد خيوط بوليستر DTY لإنتاج خيوط التريكو.',
    material: 'بوليستر 100%',
    color: 'متعدد الألوان',
    size: 'نمرة 150/48',
    qualityLevel: 'جودة تصديرية',
    requestedQty: 2000,
    unit: 'كجم',
    attachments: [],
    deliveryGovernorate: 'القاهرة',
    deliveryCity: 'المرج',
    deliveryAddress: 'المنطقة الصناعية، مبنى 15',
    deliveryDate: '2024/06/30',
  ),
  const RFQ(
    id: 'RFQ-2024-0121',
    title: 'طلب أصباغ وكيماويات',
    productName: 'أصباغ تفاعلية',
    category: 'أصباغ وكيماويات',
    invitedSuppliersCount: 3,
    receivedQuotesCount: 3,
    createdDate: '2024/05/18',
    expiryDate: '2024/06/18',
    status: RFQStatus.negotiating,
    priority: 'medium',
    description: 'نحتاج أصباغ تفاعلية متنوعة لخط الصباغة.',
    material: 'أصباغ كيماوية',
    color: 'تشكيلة كاملة',
    size: 'عبوات 25 كجم',
    qualityLevel: 'مواصفات ISO',
    requestedQty: 500,
    unit: 'كجم',
    attachments: [],
    deliveryGovernorate: 'الغربية',
    deliveryCity: 'المحلة الكبرى',
    deliveryAddress: 'شارع الثورة',
    deliveryDate: '2024/06/25',
  ),
  const RFQ(
    id: 'RFQ-2024-0120',
    title: 'طلب إكسسوارات',
    productName: 'سوست - أزرار - سحابات',
    category: 'إكسسوارات',
    invitedSuppliersCount: 6,
    receivedQuotesCount: 6,
    createdDate: '2024/05/16',
    expiryDate: '2024/06/16',
    status: RFQStatus.closed,
    priority: 'low',
    description: 'توريد إكسسوارات متنوعة للخط الجديد.',
    material: 'بلاستيك ومعدن',
    color: 'متعدد',
    size: 'مقاسات متعددة',
    qualityLevel: 'جودة عالية',
    requestedQty: 10000,
    unit: 'قطعة',
    attachments: [],
    deliveryGovernorate: 'القاهرة',
    deliveryCity: 'مدينة نصر',
    deliveryAddress: 'شارع عباس العقاد',
    deliveryDate: '2024/06/10',
  ),
  const RFQ(
    id: 'RFQ-2024-0119',
    title: 'طلب توريد قطن ممشط',
    productName: 'خيوط قطن ممشط 30/1',
    category: 'خيوط وتريكو',
    invitedSuppliersCount: 4,
    receivedQuotesCount: 0,
    createdDate: '2024/05/15',
    expiryDate: '2024/06/15',
    status: RFQStatus.draft,
    priority: 'high',
    description: 'طلب مسودة لخيوط قطن ممشط.',
    material: 'قطن مصري 100%',
    color: 'أبيض خام',
    size: 'نمرة 30/1',
    qualityLevel: 'نخب أول',
    requestedQty: 8000,
    unit: 'كجم',
    attachments: [],
    deliveryGovernorate: 'الجيزة',
    deliveryCity: 'السادس من أكتوبر',
    deliveryAddress: 'المنطقة الصناعية الثانية',
    deliveryDate: '2024/07/15',
  ),
  const RFQ(
    id: 'RFQ-2024-0118',
    title: 'طلب أقمشة جبردين',
    productName: 'قماش جبردين بوليستر/قطن',
    category: 'أقمشة وصباغة',
    invitedSuppliersCount: 6,
    receivedQuotesCount: 2,
    createdDate: '2024/05/10',
    expiryDate: '2024/06/10',
    status: RFQStatus.dealCreated,
    priority: 'high',
    description: 'أقمشة جبردين لإنتاج ملابس العمل.',
    material: '65% بوليستر 35% قطن',
    color: 'زيتي وكحلي',
    size: 'عرض 150 سم',
    qualityLevel: 'جودة صناعية',
    requestedQty: 15000,
    unit: 'م',
    attachments: [],
    deliveryGovernorate: 'الغربية',
    deliveryCity: 'المحلة الكبرى',
    deliveryAddress: 'مخازن المصنع',
    deliveryDate: '2024/06/01',
  ),
  const RFQ(
    id: 'RFQ-2024-0117',
    title: 'طلب علب تغليف',
    productName: 'علب كرتون مطبوعة',
    category: 'تغليف وتعبئة',
    invitedSuppliersCount: 3,
    receivedQuotesCount: 0,
    createdDate: '2024/05/05',
    expiryDate: '2024/06/05',
    status: RFQStatus.sent,
    priority: 'low',
    description: 'علب كرتون للتغليف النهائي.',
    material: 'كرتون مضلع',
    color: 'بني طبيعي',
    size: '35×25×8 سم',
    qualityLevel: 'نخب ممتاز',
    requestedQty: 50000,
    unit: 'علبة',
    attachments: [],
    deliveryGovernorate: 'القاهرة',
    deliveryCity: 'بدر',
    deliveryAddress: 'المنطقة الصناعية الحرة',
    deliveryDate: '2024/07/30',
  ),
  const RFQ(
    id: 'RFQ-2024-0116',
    title: 'طلب خيوط مطاط',
    productName: 'خيوط مطاط لازيك',
    category: 'خيوط وتريكو',
    invitedSuppliersCount: 2,
    receivedQuotesCount: 0,
    createdDate: '2024/05/01',
    expiryDate: '2024/06/01',
    status: RFQStatus.cancelled,
    priority: 'low',
    description: 'خيوط مطاط للإنتاج.',
    material: 'لازيك مستورد',
    color: 'بيج',
    size: '1.5 مم',
    qualityLevel: 'جودة عالية',
    requestedQty: 3000,
    unit: 'كجم',
    attachments: [],
    deliveryGovernorate: 'القاهرة',
    deliveryCity: 'مدينة نصر',
    deliveryAddress: 'شارع التسعين',
    deliveryDate: '2024/06/15',
  ),
];
