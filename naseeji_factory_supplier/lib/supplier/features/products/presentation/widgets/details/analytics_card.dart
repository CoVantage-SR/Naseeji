import 'package:flutter/material.dart';
import 'package:naseeji_factory/supplier/features/products/domain/entities/product_model.dart';

class AnalyticsCard extends StatelessWidget {
  final ProductModel product;

  const AnalyticsCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final stats = [
      {
        'title': 'عدد المشاهدات',
        'value': '${product.viewsCount}',
        'icon': Icons.visibility_outlined,
        'color': const Color(0xFF2563EB),
        'bgColor': isDark ? const Color(0xFF1E3A8A) : const Color(0xFFEFF6FF),
      },
      {
        'title': 'طلبات RFQ',
        'value': '${product.rfqCount}',
        'icon': Icons.assignment_outlined,
        'color': const Color(0xFF9333EA),
        'bgColor': isDark ? const Color(0xFF2D1B4E) : const Color(0xFFF3E8FF),
      },
      {
        'title': 'عدد الصفقات',
        'value': '${product.dealsCount}',
        'icon': Icons.handshake_outlined,
        'color': const Color(0xFF16A34A),
        'bgColor': isDark ? const Color(0xFF14532D) : const Color(0xFFDCFCE7),
      },
      {
        'title': 'عدد الاتفاقات',
        'value': '${(product.dealsCount * 0.75).round()}',
        'icon': Icons.verified_outlined,
        'color': const Color(0xFF0284C7),
        'bgColor': isDark ? const Color(0xFF0C4A6E) : const Color(0xFFE0F2FE),
      },
      {
        'title': 'مرات الحفظ',
        'value': '${product.savesCount}',
        'icon': Icons.bookmark_border_rounded,
        'color': const Color(0xFFEA580C),
        'bgColor': isDark ? const Color(0xFF7C2D12) : const Color(0xFFFFF7ED),
      },
      {
        'title': 'إجمالي المباع',
        'value': '3,450 ${product.unit}',
        'icon': Icons.shopping_cart_outlined,
        'color': const Color(0xFF4F46E5),
        'bgColor': isDark ? const Color(0xFF1E1B4B) : const Color(0xFFEEF2FF),
      },
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
          Text(
            'الأداء والمبيعات (تحليلات المنتج)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),

          // 2x3 Grid of Compact Stat Cards
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stats.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.15,
            ),
            itemBuilder: (context, index) {
              final item = stats[index];
              final color = item['color'] as Color;
              final bgColor = item['bgColor'] as Color;

              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                      child: Icon(item['icon'] as IconData, size: 14, color: color),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['value'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      item['title'] as String,
                      style: TextStyle(
                        fontSize: 9,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

