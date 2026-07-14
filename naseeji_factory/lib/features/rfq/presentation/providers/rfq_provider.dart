import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rfq_provider.g.dart';

class RFQ {
  final String id;
  final String title;
  final String category;
  final int invitedSuppliersCount;
  final int receivedQuotesCount;
  final String createdDate;
  final String expiryDate;
  final String status; // open, negotiation, approved, rejected, expired
  final String priority; // high, medium, low
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
  }) {
    return RFQ(
      id: id,
      title: title,
      category: category,
      invitedSuppliersCount: invitedSuppliersCount,
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
    final newId = 'RFQ-2026-${state.length + 101}';
    final newRfq = RFQ(
      id: newId,
      title: title,
      category: category,
      invitedSuppliersCount: sendToRecommended ? 4 : selectedSupplierIds.length,
      receivedQuotesCount: 0,
      createdDate: '٢٠٢٦/٠٧/١٤',
      expiryDate: '٢٠٢٦/٠٧/٣٠',
      status: 'open',
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
        if (rfq.id == id) rfq.copyWith(status: 'rejected') else rfq
    ];
  }

  void updateRFQStatus(String id, String status) {
    state = [
      for (final rfq in state)
        if (rfq.id == id) rfq.copyWith(status: status) else rfq
    ];
  }

  RFQ? getRFQById(String id) {
    try {
      return state.firstWhere((rfq) => rfq.id == id);
    } catch (_) {
      return null;
    }
  }
}

final List<RFQ> _mockRFQs = [
  const RFQ(
    id: 'RFQ-2026-001',
    title: 'طلب توريد خيوط قطن ممشط 30/1 للموسم الشتوي',
    category: 'خيوط وتريكو',
    invitedSuppliersCount: 5,
    receivedQuotesCount: 3,
    createdDate: '٢٠٢٦/٠٧/١٠',
    expiryDate: '٢٠٢٦/٠٧/٢٥',
    status: 'open',
    priority: 'high',
    description: 'نبحث عن مورد معتمد لتوريد خيوط قطن مصري ممشط نمرة 30/1 سوبر بكميات كبيرة لخط إنتاج الملابس الرياضية الشتوية. يرجى توفير عينات للتحليل الفني قبل التأكيد.',
    material: 'قطن مصري 100% ممشط بالكامل',
    color: 'أبيض خام طبيعي',
    size: 'نمرة 30/1',
    qualityLevel: 'نخب أول (Grade A)',
    requestedQty: 10000,
    unit: 'كيلو جرام',
    attachments: ['مواصفات_الخيوط_الفنية.pdf', 'شروط_الاستلام_والتفتيش.xlsx'],
    deliveryGovernorate: 'الجيزة',
    deliveryCity: 'السادس من أكتوبر',
    deliveryAddress: 'المنطقة الصناعية الثانية، قطعة 44/ب',
    deliveryDate: '٢٠٢٦/٠٨/١٥',
  ),
  const RFQ(
    id: 'RFQ-2026-002',
    title: 'طلب أقمشة جبردين متينة لبنطلونات العمل الكاجوال',
    category: 'أقمشة وصباغة',
    invitedSuppliersCount: 3,
    receivedQuotesCount: 2,
    createdDate: '٢٠٢٦/٠٧/٠٥',
    expiryDate: '٢٠٢٦/٠٧/٢٠',
    status: 'negotiation',
    priority: 'medium',
    description: 'نريد قماش جبردين عالي التحمل لإنتاج ملابس العمل والسترات الواقية، بوزن لا يقل عن 270 جرام/متر مربع ومقاوم جزئياً للماء والزيت.',
    material: '65% بوليستر، 35% قطن',
    color: 'زيتي غامق وكحلي داكن',
    size: 'عرض 150 سم',
    qualityLevel: 'جودة صناعية قياسية',
    requestedQty: 15000,
    unit: 'متر',
    attachments: ['كتالوج_الألوان_المطلوبة.pdf'],
    deliveryGovernorate: 'الغربية',
    deliveryCity: 'المحلة الكبرى',
    deliveryAddress: 'مخازن مصنع نسيج المحلة، شارع الثورة',
    deliveryDate: '٢٠٢٦/٠٨/٢٠',
  ),
  const RFQ(
    id: 'RFQ-2026-003',
    title: 'علب كرتون لتغليف قمصان التصدير الجاهزة',
    category: 'تغليف وتعبئة',
    invitedSuppliersCount: 4,
    receivedQuotesCount: 1,
    createdDate: '٢٠٢٦/٠٦/٢٠',
    expiryDate: '٢٠٢٦/٠٧/٠٥',
    status: 'approved',
    priority: 'low',
    description: 'توريد علب كرتون مقوى مطبوع بشعار المصنع وتفاصيل المنتج لتغليف قمصان تصدير فاخرة.',
    material: 'كرتون ثلاثي الطبقات مضلع',
    color: 'بني طبيعي صديق للبيئة',
    size: '35 × 25 × 8 سم',
    qualityLevel: 'نخب ممتاز',
    requestedQty: 50000,
    unit: 'بكرة',
    attachments: ['شعار_المصنع_للطباعة.pdf'],
    deliveryGovernorate: 'القاهرة',
    deliveryCity: 'بدر',
    deliveryAddress: 'المنطقة الصناعية الحرة، قطعة 12',
    deliveryDate: '٢٠٢٦/٠٧/٣٠',
  ),
];
