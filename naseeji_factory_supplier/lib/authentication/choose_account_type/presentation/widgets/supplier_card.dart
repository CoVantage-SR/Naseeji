import 'package:flutter/material.dart';
import 'account_type_card.dart';

class SupplierCard extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const SupplierCard({
    super.key,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AccountTypeCard(
      title: 'مورد',
      description:
          'إذا كنت مورد منتجات أو خامات أو خدمات وترغب في عرضها على المصانع والشركات',
      buttonText: 'اختر مورد',
      icon: Icons.inventory_2_outlined,
      illustration: CustomPaint(
        painter: _SupplierIllustrationPainter(isDark: isDark),
        child: Container(),
      ),
      isSelected: isSelected,
      onTap: onTap,
    );
  }
}

class _SupplierIllustrationPainter extends CustomPainter {
  final bool isDark;

  _SupplierIllustrationPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final shelfPaint = Paint()
      ..color = isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)
      ..style = PaintingStyle.fill;

    final rollPaint1 = Paint()..color = const Color(0xFF3B82F6);
    final rollPaint2 = Paint()..color = const Color(0xFF10B981);
    final rollPaint3 = Paint()..color = const Color(0xFFF59E0B);

    // Shelf Rack
    canvas.drawRect(Rect.fromLTWH(w * 0.1, h * 0.2, w * 0.8, h * 0.1), shelfPaint);
    canvas.drawRect(Rect.fromLTWH(w * 0.1, h * 0.6, w * 0.8, h * 0.1), shelfPaint);

    // Fabric Rolls on shelf
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.15, h * 0.08, w * 0.2, h * 0.12), const Radius.circular(4)),
      rollPaint1,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.4, h * 0.08, w * 0.2, h * 0.12), const Radius.circular(4)),
      rollPaint2,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.65, h * 0.08, w * 0.2, h * 0.12), const Radius.circular(4)),
      rollPaint3,
    );

    // Box Containers
    final boxPaint = Paint()
      ..color = isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8);
    canvas.drawRect(Rect.fromLTWH(w * 0.2, h * 0.45, w * 0.25, h * 0.15), boxPaint);
    canvas.drawRect(Rect.fromLTWH(w * 0.55, h * 0.45, w * 0.25, h * 0.15), boxPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
