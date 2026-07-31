import 'package:flutter/material.dart';
import 'package:naseeji_factory/supplier/features/products/domain/entities/product_model.dart';

class ProductBasicInfoCard extends StatefulWidget {
  final ProductModel product;

  const ProductBasicInfoCard({
    super.key,
    required this.product,
  });

  @override
  State<ProductBasicInfoCard> createState() => _ProductBasicInfoCardState();
}

class _ProductBasicInfoCardState extends State<ProductBasicInfoCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final specs = [
      {'label': 'نوع القماش', 'value': widget.product.subCategory.isNotEmpty ? widget.product.subCategory : 'قطني 100%', 'icon': Icons.grid_view_rounded},
      {'label': 'العرض', 'value': '150 سم', 'icon': Icons.straighten_rounded},
      {'label': 'الوزن', 'value': '120 جم/م²', 'icon': Icons.scale_outlined},
      {'label': 'الألوان المتاحة', 'value': '8 ألوان', 'icon': Icons.palette_outlined},
      {'label': 'بلد المنشأ', 'value': widget.product.countryOfOrigin, 'icon': Icons.location_on_outlined},
      {'label': 'طريقة التعبئة', 'value': widget.product.packagingMethod, 'icon': Icons.inventory_2_outlined},
    ];

    final extraSpecs = [
      {'label': 'العلامة التجارية', 'value': widget.product.brand},
      {'label': 'كود المنتج (SKU)', 'value': widget.product.sku},
      {'label': 'التصنيف الرئيسي', 'value': widget.product.category},
      {'label': 'وزن الكرتونة', 'value': '${widget.product.cartonWeightKg} كجم'},
      {'label': 'عدد الوحدات بالصندوق', 'value': '${widget.product.unitsPerBox} قطعة'},
      {'label': 'موقع الاستلام', 'value': widget.product.pickupLocation},
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header title "المواصفات"
          Text(
            'المواصفات والمعلومات الأساسية',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),

          // List of specifications matching reference image
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: specs.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: isDark ? const Color(0xFF334155) : const Color(0xFFF3F4F6),
            ),
            itemBuilder: (context, index) {
              final spec = specs[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          spec['icon'] as IconData,
                          size: 16,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          spec['label'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      spec['value'] as String,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Extra specifications if expanded
          if (_isExpanded) ...[
            Divider(height: 1, color: isDark ? const Color(0xFF334155) : const Color(0xFFF3F4F6)),
            const SizedBox(height: 10),
            Text(
              'الوصف التفصيلي:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.product.fullDescription,
              style: TextStyle(
                fontSize: 11.5,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            ...extraSpecs.map(
              (spec) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      spec['label']!,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                      ),
                    ),
                    Text(
                      spec['value']!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 8),

          // Expand / Collapse button ("عرض جميع المواصفات")
          Center(
            child: TextButton.icon(
              onPressed: () => setState(() => _isExpanded = !_isExpanded),
              icon: Icon(
                _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
              ),
              label: Text(
                _isExpanded ? 'إخفاء المواصفات الإضافية' : 'عرض جميع المواصفات',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

