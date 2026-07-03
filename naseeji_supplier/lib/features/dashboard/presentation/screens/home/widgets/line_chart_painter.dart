import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class LineChartPainter extends CustomPainter {
  final List<double> data;

  LineChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paintLine = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final paintFill = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primary.withValues(alpha: 0.25),
          AppColors.primary.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final stepX = size.width / (data.length - 1);
    
    final maxVal = data.reduce((a, b) => a > b ? a : b);
    final minVal = data.reduce((a, b) => a < b ? a : b);
    final range = maxVal - minVal == 0 ? 1 : maxVal - minVal;

    double getX(int index) => index * stepX;
    double getY(double val) {
      final normalized = (val - minVal) / range;
      return size.height - (normalized * (size.height - 20) + 10);
    }

    path.moveTo(getX(0), getY(data[0]));
    for (int i = 1; i < data.length; i++) {
      path.lineTo(getX(i), getY(data[i]));
    }

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, paintFill);
    canvas.drawPath(path, paintLine);

    final paintCircle = Paint()..color = AppColors.primary;
    for (int i = 0; i < data.length; i += 2) {
      canvas.drawCircle(Offset(getX(i), getY(data[i])), 4, paintCircle);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
