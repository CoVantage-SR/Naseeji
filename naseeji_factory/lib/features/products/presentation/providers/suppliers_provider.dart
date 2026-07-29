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
  final String memberSince;
  final int clientsCount;
  final int certificatesCount;
  final String companyType;
  final String employeesCount;
  final String commercialReg;
  final String taxNumber;
  final String productionCapacity;
  final List<String> exportCountries;
  final List<String> factoryImages;
  final List<String> paymentMethods;
  final List<String> supportedIndustries;

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
    this.reviewsCount = 128,
    this.establishedYear = '1960',
    this.avgDeliveryDays = '7 أيام',
    this.memberSince = 'يناير 2020',
    this.clientsCount = 86,
    this.certificatesCount = 6,
    this.companyType = 'شركة مساهمة مصرية',
    this.employeesCount = '350 - 500 موظف',
    this.commercialReg = '10294857',
    this.taxNumber = '492-104-582',
    this.productionCapacity = '40,000 متر / يوم',
    this.exportCountries = const ['مصر', 'السعودية', 'الأردن', 'تركيا', 'أوروبا'],
    this.factoryImages = const [
      'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=600',
      'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=300',
      'https://images.unsplash.com/photo-1581092335397-9583fe92d232?w=300',
      'https://images.unsplash.com/photo-1504328345606-18bbc8c9d7d1?w=300',
    ],
    this.paymentMethods = const ['تحويل بنكي', 'اعتماد مستندي (LC)', 'دفعة مقدمة + عند الاستلام'],
    this.supportedIndustries = const [
      'الملابس الجاهزة والبدل',
      'المفروشات المنزلية',
      'الزي الموحد والملابس الطبية',
      'صناعة التريكو والأنسجة'
    ],
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
      memberSince: memberSince,
      clientsCount: clientsCount,
      certificatesCount: certificatesCount,
      companyType: companyType,
      employeesCount: employeesCount,
      commercialReg: commercialReg,
      taxNumber: taxNumber,
      productionCapacity: productionCapacity,
      exportCountries: exportCountries,
      factoryImages: factoryImages,
      paymentMethods: paymentMethods,
      supportedIndustries: supportedIndustries,
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
    rating: 4.8,
    reviewsCount: 128,
    productsCount: 245,
    completedOrders: 128,
    clientsCount: 86,
    certificatesCount: 6,
    city: 'القاهرة',
    governorate: 'مصر',
    isVerified: true,
    description:
        'مصر للغزل والنسيج هي إحدى الشركات الرائدة في مجال الغزل والنسيج في مصر والشرق الأوسط منذ عام 1960. نقدم مجموعة واسعة من الأقمشة عالية الجودة والخيوط والمنتجات النسيجية بخبرات متقدمة ومعايير جودة عالمية.',
    experience: 'تأسست عام 1960',
    establishedYear: '1960',
    deliveryPerformance: '95%',
    responseSpeed: '95%',
    avgDeliveryDays: '7 أيام',
    memberSince: 'يناير 2020',
    companyType: 'شركة مساهمة مصرية',
    employeesCount: '350 - 500 موظف',
    commercialReg: '10294857',
    taxNumber: '492-104-582',
    productionCapacity: '40,000 متر / يوم',
    exportCountries: ['مصر', 'السعودية', 'الأردن', 'تركيا', 'أوروبا'],
    isOnline: true,
    certificates: [
      'ISO 9001:2015 الجودة القياسية',
      'ISO 14001:2015 الإدارة البيئية',
      'Oeko-Tex Standard 100 خالي من المواد الضارة',
      'GOTS الشهادة العالمية للأقمشة العضوية',
      'REACH مطابقة للمعايير الأوروبية',
      'شهادة الاعتماد الصناعي الهيئة العامة للتصنيع',
    ],
    paymentMethods: [
      'تحويل بنكي مباشر (Wire Transfer)',
      'اعتماد مستندي مغطى (L/C)',
      'دفعة مقدمة 30% والباقي عند التسليم',
      'شيكات مسبقة المصنع (للمشترين المعتمدين)',
    ],
    factoryImages: [
      'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=600',
      'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=300',
      'https://images.unsplash.com/photo-1581092335397-9583fe92d232?w=300',
      'https://images.unsplash.com/photo-1504328345606-18bbc8c9d7d1?w=300',
    ],
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
    description:
        'مصنع قطاع خاص حديث مجهز بأحدث الأنوال والمصبغات لإنتاج أقمشة الجينز والجبردين والتريكو لمختلف ماركات الملابس الجاهزة المحلية والدولية.',
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
    description:
        'نستورد أفضل خيوط البوليستر والتطريز وجميع إكسسوارات الملابس ومستلزمات خطوط الإنتاج والتقفيل بأسعار تنافسية.',
    experience: 'منذ ٨ أعوام',
    deliveryPerformance: '٩٠%',
    responseSpeed: 'خلال ٢٤ ساعة',
    certificates: ['شهادة الجودة الصينية CCC'],
  ),
];
