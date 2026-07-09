import 'package:flutter/material.dart';

class SupplierTipCard extends StatelessWidget {
  const SupplierTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F6F3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFB2DFDB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'نصيحة للموردين',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004D40),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'استخدام أسماء وصفية دقيقة مثل "قطن جيزة 86 طويل التيلة" يساعد المصانع الذكية في العثور على منتجاتك بشكل أسرع في نتائج البحث المتقدمة.',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF00796B),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Icon(Icons.lightbulb_outline, color: Color(0xFF00796B)),
        ],
      ),
    );
  }
}
