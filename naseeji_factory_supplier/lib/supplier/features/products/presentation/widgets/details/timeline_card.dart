import 'package:flutter/material.dart';
import 'package:naseeji_factory/supplier/features/products/domain/entities/product_model.dart';

class TimelineCard extends StatelessWidget {
  final ProductModel product;

  const TimelineCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final events = [
      {
        'title': 'تم إنشاء المنتج',
        'date': '${product.createdAt.day}/${product.createdAt.month}/${product.createdAt.year}',
        'icon': Icons.add_circle_outline_rounded,
        'color': const Color(0xFF2563EB),
      },
      {
        'title': 'تم نشر المنتج',
        'date': '${product.createdAt.add(const Duration(days: 1)).day}/${product.createdAt.month}/${product.createdAt.year}',
        'icon': Icons.publish_rounded,
        'color': const Color(0xFF16A34A),
      },
      {
        'title': 'تم تعديل المنتج',
        'date': '${product.updatedAt.day}/${product.updatedAt.month}/${product.updatedAt.year}',
        'icon': Icons.edit_note_rounded,
        'color': const Color(0xFF9333EA),
      },
      {
        'title': 'آخر تحديث للمخزون',
        'date': product.formattedLastUpdated,
        'icon': Icons.update_rounded,
        'color': const Color(0xFF0284C7),
      },
      {
        'title': 'آخر طلب RFQ استلام',
        'date': 'منذ 3 أيام',
        'icon': Icons.assignment_turned_in_outlined,
        'color': const Color(0xFFEA580C),
      },
      {
        'title': 'آخر صفقة ناجحة',
        'date': 'منذ أسبوع',
        'icon': Icons.check_circle_outline_rounded,
        'color': const Color(0xFF16A34A),
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
            'التسلسل الزمني وسجل الأحداث',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: events.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final event = events[index];
              final isLast = index == events.length - 1;
              final color = event['color'] as Color;

              return Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(event['icon'] as IconData, size: 13, color: color),
                      ),
                      if (!isLast)
                        Container(
                          width: 1.5,
                          height: 12,
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      event['title'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                    ),
                  ),
                  Text(
                    event['date'] as String,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}


