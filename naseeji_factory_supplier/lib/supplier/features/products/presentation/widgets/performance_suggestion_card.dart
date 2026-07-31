import 'package:flutter/material.dart';
import '../../domain/entities/product_model.dart';

class PerformanceSuggestionCard extends StatelessWidget {
  final List<ProductModel> products;

  const PerformanceSuggestionCard({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final lowPerformingProduct = products.firstWhere(
      (p) => p.viewsCount > 300 && p.rfqCount == 0,
      orElse: () => products.firstWhere((p) => p.viewsCount > 100 && p.rfqCount < 3, orElse: () => products.first),
    );

    final isWeak = lowPerformingProduct.viewsCount > 300 && lowPerformingProduct.rfqCount == 0;

    if (isWeak) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF3C7),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.4)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb_outline_rounded, color: Color(0xFFD97706), size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'اقتراح تحسين الأداء',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'منتج "${lowPerformingProduct.name}" حصل على ${lowPerformingProduct.viewsCount} مشاهدة بدون أي طلب عرض سعر (RFQ).',
                    style: const TextStyle(fontSize: 9.5, color: Color(0xFF451A03), height: 1.3),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildChip(theme, '• تحسين الصور'),
                      const SizedBox(width: 4),
                      _buildChip(theme, '• تعديل السعر'),
                      const SizedBox(width: 4),
                      _buildChip(theme, '• إضافة مواصفات أكثر'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF22C55E).withValues(alpha: 0.4)),
      ),
      child: const Row(
        children: [
          Icon(Icons.emoji_events_outlined, color: Color(0xFF15803D), size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'أداء ممتاز! منتجاتك حققت أعلى معدل طلبات عروض أسعار وزيارات من المصانع هذا الأسبوع 🎉',
              style: TextStyle(fontSize: 10, color: Color(0xFF14532D), fontWeight: FontWeight.w600, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(ThemeData theme, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 8.5, color: Colors.amber.shade900, fontWeight: FontWeight.bold),
      ),
    );
  }
}



