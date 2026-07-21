import 'package:flutter/material.dart';
import '../../domain/entities/product_model.dart';

class ProductStatusBadge extends StatelessWidget {
  final ProductStatus status;

  const ProductStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String text;

    switch (status) {
      case ProductStatus.published:
        bg = const Color(0xFFE8F5E9);
        fg = const Color(0xFF2E7D32);
        text = 'منشور';
        break;
      case ProductStatus.hidden:
        bg = const Color(0xFFFFF3E0);
        fg = const Color(0xFFE65100);
        text = 'مخفي';
        break;
      case ProductStatus.draft:
        bg = const Color(0xFFE3F2FD);
        fg = const Color(0xFF1565C0);
        text = 'مسودة';
        break;
      case ProductStatus.outOfStock:
        bg = const Color(0xFFFFEBEE);
        fg = const Color(0xFFC62828);
        text = 'منتهي';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: fg,
        ),
      ),
    );
  }
}
