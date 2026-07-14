import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'products_provider.g.dart';

class Product {
  final String id;
  final String name;
  final String supplierName;
  final String supplierId;
  final double price;
  final int moq;
  final int prepTimeDays;
  final double rating;
  final String countryOfOrigin;
  final bool isVerifiedSupplier;
  final String imageUrl;
  final String description;
  final String material;
  final List<String> colors;
  final List<String> sizes;
  final int availableQty;
  final Map<String, String> technicalSpecs;
  final bool isFavorite;

  const Product({
    required this.id,
    required this.name,
    required this.supplierName,
    required this.supplierId,
    required this.price,
    required this.moq,
    required this.prepTimeDays,
    required this.rating,
    required this.countryOfOrigin,
    required this.isVerifiedSupplier,
    required this.imageUrl,
    required this.description,
    required this.material,
    required this.colors,
    required this.sizes,
    required this.availableQty,
    required this.technicalSpecs,
    this.isFavorite = false,
  });

  Product copyWith({bool? isFavorite}) {
    return Product(
      id: id,
      name: name,
      supplierName: supplierName,
      supplierId: supplierId,
      price: price,
      moq: moq,
      prepTimeDays: prepTimeDays,
      rating: rating,
      countryOfOrigin: countryOfOrigin,
      isVerifiedSupplier: isVerifiedSupplier,
      imageUrl: imageUrl,
      description: description,
      material: material,
      colors: colors,
      sizes: sizes,
      availableQty: availableQty,
      technicalSpecs: technicalSpecs,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

@riverpod
class ProductsNotifier extends _$ProductsNotifier {
  @override
  List<Product> build() {
    return _mockProducts;
  }

  void toggleFavorite(String productId) {
    state = [
      for (final p in state)
        if (p.id == productId) p.copyWith(isFavorite: !p.isFavorite) else p
    ];
  }

  Product? getProductById(String id) {
    try {
      return state.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}

final List<Product> _mockProducts = [
  const Product(
    id: 'prod_1',
    name: 'خيوط قطن ممشط 30/1 سوبر',
    supplierName: 'شركة غزل المحلة الكبرى',
    supplierId: 'sup_1',
    price: 145.0,
    moq: 500,
    prepTimeDays: 7,
    rating: 4.8,
    countryOfOrigin: 'مصر',
    isVerifiedSupplier: true,
    imageUrl: 'https://images.unsplash.com/photo-1528301721190-186c3bd85418?w=500',
    description: 'خيوط قطن طبيعي 100% ممشط نمرة 30/1 مناسبة لحياكة المنسوجات الفاخرة والملابس الرياضية القطنية الناعمة. تتميز بمقاومة عالية للاهتراء ولمعان طبيعي.',
    material: 'قطن مصري 100%',
    colors: ['أبيض ناصع', 'أسود فاحم', 'رمادي فاتح'],
    sizes: ['نمرة 30/1', 'نمرة 40/1', 'نمرة 24/1'],
    availableQty: 15000,
    technicalSpecs: {
      'قوة الشد': '18.5 RKM',
      'الانحراف': '1.2%',
      'نوع التمشيط': 'ممشط بالكامل (Combed)',
      'الاستخدام': 'حياكة وتريكو دائري',
    },
  ),
  const Product(
    id: 'prod_2',
    name: 'أقمشة جبردين قطني متين',
    supplierName: 'مصنع النيل للأقمشة الحديثة',
    supplierId: 'sup_2',
    price: 85.0,
    moq: 200,
    prepTimeDays: 12,
    rating: 4.6,
    countryOfOrigin: 'مصر',
    isVerifiedSupplier: true,
    imageUrl: 'https://images.unsplash.com/photo-1584290860587-2231ffc3df78?w=500',
    description: 'قماش جبردين عالي الجودة بوزن متوسط متين جداً لإنتاج البنطلونات والسترات العملية ويتحمل الغسيل المتكرر دون بهتان.',
    material: '98% قطن، 2% ليكرا سباندكس',
    colors: ['بيج صحراوي', 'أزرق داكن', 'زيتي كحلي'],
    sizes: ['عرض 150 سم', 'عرض 160 سم'],
    availableQty: 8000,
    technicalSpecs: {
      'الوزن': '280 جرام/متر مربع',
      'الاستطالة': 'مرن نسبياً (Stretch)',
      'مقاومة الماء': 'غير مقاوم للماء',
      'عدد الخيوط': '2/20 كاردد',
    },
  ),
  const Product(
    id: 'prod_3',
    name: 'بكر خيوط بوليستر مغزول',
    supplierName: 'الفتح لخيوط البوليستر',
    supplierId: 'sup_3',
    price: 32.0,
    moq: 1000,
    prepTimeDays: 5,
    rating: 4.3,
    countryOfOrigin: 'الصين',
    isVerifiedSupplier: false,
    imageUrl: 'https://images.unsplash.com/photo-1605721911519-3dfeb3be25e7?w=500',
    description: 'خيوط بوليستر مغزول نمرة 40/2 ذات جودة تجارية ممتازة وتكلفة اقتصادية، مثالية للتطريز الآلي ومصانع الملابس الجاهزة ذات الإنتاج الضخم.',
    material: 'بوليستر 100%',
    colors: ['أحمر ناري', 'أصفر ليموني', 'أخضر عشبي', 'أزرق ملكي'],
    sizes: ['بكرة 5000 ياردة', 'بكرة 10000 ياردة'],
    availableQty: 25000,
    technicalSpecs: {
      'النوع': 'نمرة 40/2 مغزول',
      'قوة الانقطاع': '1100 cN',
      'مقاومة الحرارة': 'تتحمل الكي حتى 150 درجة',
    },
  ),
  const Product(
    id: 'prod_4',
    name: 'أزرار بلاستيكية قميص فاخرة',
    supplierName: 'الفتح لخيوط البوليستر ومستلزمات المصانع',
    supplierId: 'sup_3',
    price: 0.85,
    moq: 5000,
    prepTimeDays: 3,
    rating: 4.5,
    countryOfOrigin: 'مصر',
    isVerifiedSupplier: false,
    imageUrl: 'https://images.unsplash.com/photo-1549490349-8643362247b5?w=500',
    description: 'أزرار بلاستيكية بفتحتين وأربعة فتحات لقمصان البدل والملابس الخفيفة، مقاومة للكسر ودرجات الحرارة العالية أثناء الكي والتنظيف الجاف.',
    material: 'بلاستيك بوليستر مقوى',
    colors: ['أبيض صدفي', 'أسود لامع', 'كحلي داكن'],
    sizes: ['نمرة 14', 'نمرة 16', 'نمرة 18'],
    availableQty: 500000,
    technicalSpecs: {
      'النوع': 'أزرار قمصان ملابس جاهزة',
      'التحمل': 'تتحمل الغسيل حتى 90 درجة',
    },
  ),
  const Product(
    id: 'prod_5',
    name: 'خيوط تطريز حريرية لامعة',
    supplierName: 'شركة غزل المحلة الكبرى',
    supplierId: 'sup_1',
    price: 65.0,
    moq: 100,
    prepTimeDays: 8,
    rating: 4.9,
    countryOfOrigin: 'مصر',
    isVerifiedSupplier: true,
    imageUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=500',
    description: 'خيوط حرير صناعي (رايون) فائقة اللمعان مخصصة للتطريز الآلي عالي السرعة على ماكينات التطريز متعددة الرؤوس، ثبات ألوان ممتاز عند الغسيل الكلوري.',
    material: '100% رايون حرير صناعي',
    colors: ['ذهبي ملكي', 'فضي برّاق', 'وردي فاتح', 'أخضر زمردي'],
    sizes: ['بكرة 3000 متر'],
    availableQty: 12000,
    technicalSpecs: {
      'الشد اللين': 'جيد جداً',
      'الاستخدام': 'تطريز ملابس أطفال وفساتين وسجاد',
    },
  ),
  const Product(
    id: 'prod_6',
    name: 'أكياس تعبئة وتغليف ملابس كرتون',
    supplierName: 'مصنع النيل للأقمشة الحديثة',
    supplierId: 'sup_2',
    price: 4.5,
    moq: 2000,
    prepTimeDays: 10,
    rating: 4.7,
    countryOfOrigin: 'مصر',
    isVerifiedSupplier: true,
    imageUrl: 'https://images.unsplash.com/photo-1589939705384-5185137a7f0f?w=500',
    description: 'علب كرتون وأكياس بولي إيثيلين شفافة وذاتية اللصق لحفظ الملابس وتهيئتها للشحن والتصدير والتوزيع المحلى، مطبوعة بخيار شعار مصنعك.',
    material: 'بولي إيثيلين LDPE معاد تدويره عالي الجودة',
    colors: ['شفاف بالكامل', 'أبيض معتم'],
    sizes: ['مقاس 30×40 سم', 'مقاس 40×50 سم'],
    availableQty: 100000,
    technicalSpecs: {
      'السمك': '40 ميكرون',
      'نوع الغلق': 'شريط لاصق ذاتي التثبيت (self-adhesive)',
    },
  ),
];
