import 'package:flutter/material.dart';
import '../../../../../../../core/constants/app_colors.dart';

class MiniChartWidget extends StatelessWidget {
  final List<double> dataPoints;
  final double height;

  const MiniChartWidget({
    super.key,
    required this.dataPoints,
    this.height = 60.0,
  });

  @override
  Widget build(BuildContext context) {
    if (dataPoints.isEmpty) return SizedBox(height: height);

    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _MiniChartPainter(
          dataPoints: dataPoints,
          lineColor: AppColors.primary,
          fillColor: AppColors.primary.withValues(alpha: 0.15),
        ),
      ),
    );
  }
}

class _MiniChartPainter extends CustomPainter {
  final List<double> dataPoints;
  final Color lineColor;
  final Color fillColor;

  _MiniChartPainter({
    required this.dataPoints,
    required this.lineColor,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.length < 2) return;

    final paintLine = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final paintFill = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final maxVal = dataPoints.reduce((a, b) => a > b ? a : b);
    final minVal = dataPoints.reduce((a, b) => a < b ? a : b);
    final range = maxVal - minVal == 0 ? 1.0 : maxVal - minVal;

    final widthStep = size.width / (dataPoints.length - 1);

    final path = Path();
    final fillPath = Path();

    // Start coordinates
    final double firstX = 0;
    final double firstY = size.height - ((dataPoints[0] - minVal) / range) * (size.height - 10) - 5;

    path.moveTo(firstX, firstY);
    fillPath.moveTo(firstX, size.height);
    fillPath.lineTo(firstX, firstY);

    for (int i = 1; i < dataPoints.length; i++) {
      final double x = i * widthStep;
      final double y = size.height - ((dataPoints[i] - minVal) / range) * (size.height - 10) - 5;

      // Draw smooth curve using cubic or quadratic bezier, or simple line segment
      final double prevX = (i - 1) * widthStep;
      final double prevY = size.height - ((dataPoints[i - 1] - minVal) / range) * (size.height - 10) - 5;
      final double controlX1 = prevX + widthStep / 2;
      final double controlY1 = prevY;
      final double controlX2 = prevX + widthStep / 2;
      final double controlY2 = y;

      path.cubicTo(controlX1, controlY1, controlX2, controlY2, x, y);
      fillPath.cubicTo(controlX1, controlY1, controlX2, controlY2, x, y);
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Draw the gradient fill
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    paintFill.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [fillColor, fillColor.withValues(alpha: 0.0)],
    ).createShader(rect);

    canvas.drawPath(fillPath, paintFill);
    canvas.drawPath(path, paintLine);
  }

  @override
  bool shouldRepaint(covariant _MiniChartPainter oldDelegate) {
    return oldDelegate.dataPoints != dataPoints;
  }
}
