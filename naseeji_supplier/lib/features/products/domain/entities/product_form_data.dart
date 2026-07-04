class ProductFormData {
  final String name;
  final String category;
  final String description;
  final String productNature; // 'تجزئة' or 'صناعي'
  final bool availableForDirectOrder;
  final int currentStep;

  const ProductFormData({
    this.name = 'قطن مصري فاخر 100%',
    this.category = 'خيوط طبيعية',
    this.description = '',
    this.productNature = 'تجزئة',
    this.availableForDirectOrder = true,
    this.currentStep = 1,
  });

  ProductFormData copyWith({
    String? name,
    String? category,
    String? description,
    String? productNature,
    bool? availableForDirectOrder,
    int? currentStep,
  }) {
    return ProductFormData(
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      productNature: productNature ?? this.productNature,
      availableForDirectOrder: availableForDirectOrder ?? this.availableForDirectOrder,
      currentStep: currentStep ?? this.currentStep,
    );
  }
}
