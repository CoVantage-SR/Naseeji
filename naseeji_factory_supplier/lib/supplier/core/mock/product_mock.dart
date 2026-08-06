class ProductMock {
  final String id;
  final String supplierId;
  final String subscriptionId;
  final String title;
  final String category;
  final double unitPrice;
  final String currency;
  final int minOrderQuantity;
  final int availableStock;
  final String imageUrl;
  final String description;
  final bool isAvailable;

  const ProductMock({
    required this.id,
    required this.supplierId,
    this.subscriptionId = 'SUB-101',
    required this.title,
    required this.category,
    required this.unitPrice,
    this.currency = 'ج.م',
    required this.minOrderQuantity,
    required this.availableStock,
    required this.imageUrl,
    required this.description,
    this.isAvailable = true,
  });

  static const List<ProductMock> sampleProducts = [
    // ── Supplier 1: مصر للغزل والنسيج (sup_1) ───────────────────────
    ProductMock(
      id: 'prod_1_1',
      supplierId: 'sup_1',
      title: 'قماش قطن مصري 100% ممتاز',
      category: 'أقمشة وغزول قطنية',
      unitPrice: 75.0,
      minOrderQuantity: 500,
      availableStock: 50000,
      imageUrl: 'https://images.unsplash.com/photo-1528301721190-186c3bd85418?w=500',
      description: 'قماش قطن مصري نخب أول تصديري عرض 150 سم - 140 جم/م² مخصص للملابس الجاهزة.',
    ),
    ProductMock(
      id: 'prod_1_2',
      supplierId: 'sup_1',
      title: 'غزل قطن ممشط نمرة 30/1',
      category: 'أقمشة وغزول قطنية',
      unitPrice: 120.0,
      minOrderQuantity: 200,
      availableStock: 15000,
      imageUrl: 'https://images.unsplash.com/photo-1606760227091-3dd858d9721d?w=500',
      description: 'غزل قطن ممشط عالي المتانة نمرة 30/1 للغزل والتريكو.',
    ),
    ProductMock(
      id: 'prod_1_3',
      supplierId: 'sup_1',
      title: 'قماش تريكو جيرسي قطن',
      category: 'أقمشة وغزول قطنية',
      unitPrice: 85.0,
      minOrderQuantity: 300,
      availableStock: 20000,
      imageUrl: 'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=500',
      description: 'قماش تريكو سينجل جيرسي قطن 100% ناعم للتيشرتات والملابس الصيفية.',
    ),
    ProductMock(
      id: 'prod_1_4',
      supplierId: 'sup_1',
      title: 'قماش كباردين قطني سميك',
      category: 'أقمشة وغزول قطنية',
      unitPrice: 95.0,
      minOrderQuantity: 400,
      availableStock: 12000,
      imageUrl: 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=500',
      description: 'قماش كباردين قطن سميك متين للبنطلونات والجاكيتات وزي العمل.',
    ),

    // ── Supplier 2: النساجون المصريون (sup_2) ─────────────────────
    ProductMock(
      id: 'prod_2_1',
      supplierId: 'sup_2',
      title: 'قماش مفروشات مخمل راقي',
      category: 'أقمشة ومفروشات وسجاد',
      unitPrice: 145.0,
      minOrderQuantity: 200,
      availableStock: 8000,
      imageUrl: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=500',
      description: 'قماش مخمل فاخر ذو ملمس حريري ناعم مخصص للمفروشات والستائر.',
    ),
    ProductMock(
      id: 'prod_2_2',
      supplierId: 'sup_2',
      title: 'خيوط صوف طبيعي 100%',
      category: 'أقمشة ومفروشات وسجاد',
      unitPrice: 190.0,
      minOrderQuantity: 100,
      availableStock: 5000,
      imageUrl: 'https://images.unsplash.com/photo-1584992236310-6edddc08acff?w=500',
      description: 'خيوط صوف نيوزيلندي طبيعي 100% مصبوغة بألوان ثابتة.',
    ),

    // ── Supplier 3: المحلة الكبرى للغزول (sup_3) ─────────────────
    ProductMock(
      id: 'prod_3_1',
      supplierId: 'sup_3',
      title: 'خيوط بوليستر عالية المتانة 150/48',
      category: 'خيوط بوليستر وأكريليك',
      unitPrice: 55.0,
      minOrderQuantity: 200,
      availableStock: 25000,
      imageUrl: 'https://images.unsplash.com/photo-1544816155-12df9643f363?w=500',
      description: 'خيوط بوليستر DTY عالي الجودة 150/48 للنسيج والحياكة.',
    ),
    ProductMock(
      id: 'prod_3_2',
      supplierId: 'sup_3',
      title: 'خيوط خياطة بوليستر مسبوكة',
      category: 'خيوط بوليستر وأكريليك',
      unitPrice: 42.0,
      minOrderQuantity: 100,
      availableStock: 40000,
      imageUrl: 'https://images.unsplash.com/photo-1606760227091-3dd858d9721d?w=500',
      description: 'بكرات خيوط خياطة بوليستر مسبوكة مقاس 40/2 للمصانع.',
    ),

    // ── Supplier 4: القاهرة للنسيج والصباغة (sup_4) ────────────────
    ProductMock(
      id: 'prod_4_1',
      supplierId: 'sup_4',
      title: 'قماش قطن أبيض مصبوغ ممتاز',
      category: 'أقمشة مصبوغة ومجهزة',
      unitPrice: 68.0,
      minOrderQuantity: 400,
      availableStock: 35000,
      imageUrl: 'https://images.unsplash.com/photo-1528301721190-186c3bd85418?w=500',
      description: 'قماش قطن أبيض مصبوغ بالكامل متوافق مع الاشتراطات البيئية.',
    ),

    // ── Supplier 5: الأهرام للكيماويات (sup_5) ────────────────────
    ProductMock(
      id: 'prod_5_1',
      supplierId: 'sup_5',
      title: 'صبغة نسيج تفاعلية (Reactive Blue)',
      category: 'أصباغ ومواد كيميائية',
      unitPrice: 140.0,
      minOrderQuantity: 50,
      availableStock: 5000,
      imageUrl: 'https://images.unsplash.com/photo-1550684848-fac1c5b4e853?w=500',
      description: 'صبغة نسيج زرقاء تفاعلية عالية الثبات للغسيل والضوء.',
    ),

    // ── Supplier 6: الإسكندرية للأقمشة (sup_6) ───────────────────
    ProductMock(
      id: 'prod_6_1',
      supplierId: 'sup_6',
      title: 'قماش جينز دนيم 12 أونصة',
      category: 'أقمشة وجينز تصديري',
      unitPrice: 98.0,
      minOrderQuantity: 500,
      availableStock: 25000,
      imageUrl: 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=500',
      description: 'قماش دنيم قطن 100% وزن 12 أونصة بنسيج تويل مخصص للجينز.',
    ),

    // ── Supplier 7: الشرقية للاكسسوارات (sup_7) ──────────────────
    ProductMock(
      id: 'prod_7_1',
      supplierId: 'sup_7',
      title: 'سوستة معدنية مخفية 20 سم',
      category: 'إكسسوارات وسوست وأزرار',
      unitPrice: 4.50,
      minOrderQuantity: 500,
      availableStock: 100000,
      imageUrl: 'https://images.unsplash.com/photo-1590736969955-71cc94901144?w=500',
      description: 'سوستة معدنية مخفية عالي التجهيز لمصانع الملابس.',
    ),

    // ── Supplier 8: الدولية لماكينات النسيج (sup_8) ───────────────
    ProductMock(
      id: 'prod_8_1',
      supplierId: 'sup_8',
      title: 'إبر ماكينات خياطة صناعية (100 إبرة)',
      category: 'ماكينات وقطع غيار',
      unitPrice: 180.0,
      minOrderQuantity: 10,
      availableStock: 1000,
      imageUrl: 'https://images.unsplash.com/photo-1516962215378-7fa2e137ae93?w=500',
      description: 'إبر خياطة صناعية عالية المتانة شتوتجارت الألمانية.',
    ),
  ];
}
