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

  static const sampleProducts = [
    ProductMock(
      id: 'P001',
      supplierId: 'SUP-001',
      title: 'غزل قطن 100% ممتاز تمشيط عالي 30/1',
      category: 'خيوط وغزل قطني',
      unitPrice: 43.0,
      minOrderQuantity: 500,
      availableStock: 50000,
      imageUrl: 'https://images.unsplash.com/photo-1604754742629-3e5728249d81?auto=format&fit=crop&w=400&q=80',
      description: 'خيوط غزل قطنية فائقة النعومة مقاس 30/1 مصنعة وفق المعايير العالمية لصناعة النسيج والملابس.',
    ),
    ProductMock(
      id: 'P002',
      supplierId: 'SUP-001',
      title: 'قماش بوليستر ممزوج 65/35 مصبوغ بالكامل',
      category: 'أقمشة نسيجية',
      unitPrice: 38.5,
      minOrderQuantity: 1000,
      availableStock: 35000,
      imageUrl: 'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?auto=format&fit=crop&w=400&q=80',
      description: 'أقمشة بوليستر ممزوجة بالقطن متينة ومقاومة للانكماش وتتحمل درجات الحرارة والغسيل التكراري.',
    ),
  ];
}

