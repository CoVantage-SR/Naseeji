import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'suppliers_provider.g.dart';

class Supplier {
  final String id;
  final String name;
  final String logoUrl;
  final String type;
  final double rating;
  final int productsCount;
  final int completedOrders;
  final String city;
  final String governorate;
  final bool isVerified;
  final String description;
  final String experience;
  final String deliveryPerformance;
  final String responseSpeed;
  final List<String> certificates;
  final bool isFavorite;
  final String? favoriteCategory;
  final String? favoriteNote;
  final bool isOnline;
  final int reviewsCount;
  final String establishedYear;
  final String avgDeliveryDays;

  const Supplier({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.type,
    required this.rating,
    required this.productsCount,
    required this.completedOrders,
    required this.city,
    required this.governorate,
    required this.isVerified,
    required this.description,
    required this.experience,
    required this.deliveryPerformance,
    required this.responseSpeed,
    required this.certificates,
    this.isFavorite = false,
    this.favoriteCategory,
    this.favoriteNote,
    this.isOnline = true,
    this.reviewsCount = 124,
    this.establishedYear = '2005',
    this.avgDeliveryDays = '5 - 7 أيام',
  });

  Supplier copyWith({
    bool? isFavorite,
    String? favoriteCategory,
    String? favoriteNote,
    bool? isOnline,
    int? reviewsCount,
  }) {
    return Supplier(
      id: id,
      name: name,
      logoUrl: logoUrl,
      type: type,
      rating: rating,
      productsCount: productsCount,
      completedOrders: completedOrders,
      city: city,
      governorate: governorate,
      isVerified: isVerified,
      description: description,
      experience: experience,
      deliveryPerformance: deliveryPerformance,
      responseSpeed: responseSpeed,
      certificates: certificates,
      isFavorite: isFavorite ?? this.isFavorite,
      favoriteCategory: favoriteCategory ?? this.favoriteCategory,
      favoriteNote: favoriteNote ?? this.favoriteNote,
      isOnline: isOnline ?? this.isOnline,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      establishedYear: establishedYear,
      avgDeliveryDays: avgDeliveryDays,
    );
  }
}

@riverpod
class SuppliersNotifier extends _$SuppliersNotifier {
  @override
  List<Supplier> build() {
    return _mockSuppliers;
  }

  void toggleFavorite(String supplierId, {String? category, String? note}) {
    state = [
      for (final s in state)
        if (s.id == supplierId)
          s.copyWith(
            isFavorite: !s.isFavorite,
            favoriteCategory: category,
            favoriteNote: note,
          )
        else
          s
    ];
  }

  void updateFavoriteDetails(String supplierId, String category, String note) {
    state = [
      for (final s in state)
        if (s.id == supplierId)
          s.copyWith(
            favoriteCategory: category,
            favoriteNote: note,
          )
        else
          s
    ];
  }

  Supplier? getSupplierById(String id) {
    try {
      return state.firstWhere((s) => s.id == id);
    } catch (_) {
      return state.isNotEmpty ? state.first : null;
    }
  }
}

final List<Supplier> _mockSuppliers = [
  const Supplier(
    id: 'sup_1',
    name: 'مصر للغزل والنسيج',
    logoUrl: 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=150',
    type: 'مصنع غزل ونسيج قطني',
    rating: 4.9,
    reviewsCount: 124,
    productsCount: 245,
    completedOrders: 1240,
    city: 'المنصورة',
    governorate: 'الدقهلية',
    isVerified: true,
    description: 'أكبر مجمع صناعي للغزل والنسيج والطباعة في مصر والدلتا، يتخصص في إنتاج الأقمشة القطنية 100% والمخلوطة بمواصفات جودة قياسية للتصدير والسوق المحلي.',
    experience: 'تأسست عام 2005',
    establishedYear: '2005',
    deliveryPerformance: '98%',
    responseSpeed: '98%',
    avgDeliveryDays: '5 - 7 أيام',
    isOnline: true,
    certificates: ['ISO 9001', 'Oeko-Tex Standard 100', 'GOTS (عضوي)'],
  ),
  const Supplier(
    id: 'sup_2',
    name: 'مصنع النيل للأقمشة الحديثة',
    logoUrl: '',
    type: 'مصنع نسيج وصباغة خاص',
    rating: 4.6,
    productsCount: 68,
    completedOrders: 420,
    city: 'العاشر من رمضان',
    governorate: 'الشرقية',
    isVerified: true,
    description: 'مصنع قطاع خاص حديث مجهز بأحدث الأنوال والمصبغات لإنتاج أقمشة الجينز والجبردين والتريكو لمختلف ماركات الملابس الجاهزة المحلية والدولية.',
    experience: 'أكثر من ١٥ عاماً',
    deliveryPerformance: '٩٤%',
    responseSpeed: 'خلال ساعتين',
    certificates: ['ISO 14001', 'Oeko-Tex Standard 100'],
  ),
  const Supplier(
    id: 'sup_3',
    name: 'الفتح لخيوط البوليستر ومستلزمات المصانع',
    logoUrl: '',
    type: 'مستورد وموزع خيوط وسست',
    rating: 4.2,
    productsCount: 198,
    completedOrders: 310,
    city: 'شبرا الخيمة',
    governorate: 'القليوبية',
    isVerified: false,
    description: 'نستورد أفضل خيوط البوليستر والتطريز وجميع إكسسوارات الملابس ومستلزمات خطوط الإنتاج والتقفيل بأسعار تنافسية.',
    experience: 'منذ ٨ أعوام',
    deliveryPerformance: '٩٠%',
    responseSpeed: 'خلال ٢٤ ساعة',
    certificates: ['شهادة الجودة الصينية CCC'],
  ),
];
