import 'package:flutter/material.dart';

// Custom Painter for Double Mesh Infinity Blue NASEEJI Logo
class NaseejiInfinityLogo extends StatelessWidget {
  final double size;

  const NaseejiInfinityLogo({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: const _InfinityLogoPainter(),
      ),
    );
  }
}

class _InfinityLogoPainter extends CustomPainter {
  const _InfinityLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rect = Rect.fromLTWH(0, 0, w, h);

    final paintStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.22
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);

    final path1 = Path();
    path1.moveTo(w * 0.2, h * 0.5);
    path1.cubicTo(w * 0.05, h * 0.1, w * 0.5, h * 0.1, w * 0.5, h * 0.5);
    path1.cubicTo(w * 0.5, h * 0.9, w * 0.95, h * 0.9, w * 0.8, h * 0.5);
    canvas.drawPath(path1, paintStroke);

    // Inner Loop Accent
    final paintAccent = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.16
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        colors: [Color(0xFF60A5FA), Color(0xFF3B82F6)],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ).createShader(rect);

    final path2 = Path();
    path2.moveTo(w * 0.8, h * 0.5);
    path2.cubicTo(w * 0.95, h * 0.1, w * 0.5, h * 0.1, w * 0.5, h * 0.5);
    path2.cubicTo(w * 0.5, h * 0.9, w * 0.05, h * 0.9, w * 0.2, h * 0.5);
    canvas.drawPath(path2, paintAccent);
  }

  @override
  bool shouldRepaint(covariant _InfinityLogoPainter oldDelegate) => false;
}

// Factory Illustration Custom Painter
class FactoryIllustrationPainter extends CustomPainter {
  final bool isDark;
  final ColorScheme? colorScheme;

  const FactoryIllustrationPainter({
    required this.isDark,
    this.colorScheme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final buildingColor = colorScheme?.surfaceContainerHighest ??
        (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1));
    final roofColor = colorScheme?.outlineVariant ??
        (isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8));
    final accentColor = colorScheme?.primary ??
        (isDark ? const Color(0xFF3B82F6) : const Color(0xFF2563EB));

    final buildingPaint = Paint()
      ..color = buildingColor
      ..style = PaintingStyle.fill;

    final roofPaint = Paint()
      ..color = roofColor
      ..style = PaintingStyle.fill;

    final accentPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill;

    // Factory main building body
    final buildingRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.35, h * 0.3, w * 0.55, h * 0.6),
      const Radius.circular(6),
    );
    canvas.drawRRect(buildingRect, buildingPaint);

    // Factory Sawtooth Roof
    final pathRoof = Path();
    pathRoof.moveTo(w * 0.35, h * 0.3);
    pathRoof.lineTo(w * 0.45, h * 0.15);
    pathRoof.lineTo(w * 0.45, h * 0.3);
    pathRoof.lineTo(w * 0.55, h * 0.15);
    pathRoof.lineTo(w * 0.55, h * 0.3);
    pathRoof.lineTo(w * 0.65, h * 0.15);
    pathRoof.lineTo(w * 0.65, h * 0.3);
    pathRoof.close();
    canvas.drawPath(pathRoof, roofPaint);

    // Factory Silos Chimneys
    canvas.drawRect(Rect.fromLTWH(w * 0.72, h * 0.15, w * 0.05, h * 0.3), roofPaint);
    canvas.drawRect(Rect.fromLTWH(w * 0.8, h * 0.1, w * 0.05, h * 0.35), roofPaint);

    // Truck / Transport Vehicle Outline
    final truckRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.1, h * 0.55, w * 0.3, h * 0.35),
      const Radius.circular(4),
    );
    canvas.drawRRect(truckRect, accentPaint);

    // Truck Wheels
    final wheelPaint = Paint()..color = isDark ? Colors.black : const Color(0xFF1E293B);
    canvas.drawCircle(Offset(w * 0.18, h * 0.9), h * 0.08, wheelPaint);
    canvas.drawCircle(Offset(w * 0.32, h * 0.9), h * 0.08, wheelPaint);
  }

  @override
  bool shouldRepaint(covariant FactoryIllustrationPainter oldDelegate) {
    return oldDelegate.isDark != isDark || oldDelegate.colorScheme != colorScheme;
  }
}

// Google Multi-color Logo Custom Painter
class GoogleLogoPainterWidget extends StatelessWidget {
  final double size;

  const GoogleLogoPainterWidget({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: const _GoogleLogoPainter(),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  const _GoogleLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);
    final radius = w / 2;

    final paintRed = Paint()..color = const Color(0xFFEA4335);
    final paintBlue = Paint()..color = const Color(0xFF4285F4);
    final paintYellow = Paint()..color = const Color(0xFFFBBC05);
    final paintGreen = Paint()..color = const Color(0xFF34A853);

    // Draw Google 4 Color Arcs
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -0.5,
      1.5,
      true,
      paintRed,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      1.0,
      1.2,
      true,
      paintYellow,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      2.2,
      1.2,
      true,
      paintGreen,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.4,
      1.5,
      true,
      paintBlue,
    );

    // Inner White Hole
    final innerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius * 0.6, innerPaint);

    // Blue Bar in Center
    canvas.drawRect(
      Rect.fromLTWH(w * 0.45, h * 0.38, w * 0.5, h * 0.24),
      paintBlue,
    );
  }

  @override
  bool shouldRepaint(covariant _GoogleLogoPainter oldDelegate) => false;
}
