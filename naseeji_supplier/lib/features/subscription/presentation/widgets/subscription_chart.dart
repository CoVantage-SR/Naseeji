import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class SubscriptionChart extends StatelessWidget {
  final String title;
  final List<double> values;
  final List<String> labels;
  final String chartType; // 'bar', 'donut', 'line'

  const SubscriptionChart({
    super.key,
    required this.title,
    required this.values,
    required this.labels,
    this.chartType = 'bar',
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 16),
            if (chartType == 'donut')
              _buildDonutChart()
            else if (chartType == 'line')
              _buildLineChart()
            else
              _buildBarChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    final double maxValue = values.isNotEmpty ? values.reduce((a, b) => a > b ? a : b) : 1.0;

    return SizedBox(
      height: 130,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(values.length, (index) {
          final val = values[index];
          final label = labels[index];
          final hPercent = maxValue > 0 ? (val / maxValue) : 0.0;

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                val.toStringAsFixed(0),
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              SizedBox(height: 4),
              Container(
                height: hPercent * 80 + 4,
                width: 24,
                decoration: BoxDecoration(
                  color: Color(0xFF0040E0),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ),
              SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(fontSize: 9, color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildLineChart() {
    final double maxValue = values.isNotEmpty ? values.reduce((a, b) => a > b ? a : b) : 1.0;

    return SizedBox(
      height: 130,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(values.length, (index) {
          final val = values[index];
          final label = labels[index];
          final hPercent = maxValue > 0 ? (val / maxValue) : 0.0;

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                val.toStringAsFixed(1),
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              SizedBox(height: 4),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: hPercent * 80 + 4,
                    width: 2,
                    color: const Color(0xFF006B5F).withValues(alpha: 0.3),
                  ),
                  Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      color: Color(0xFF006B5F),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(fontSize: 9, color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDonutChart() {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: CustomPaint(
            size: const Size(100, 100),
            painter: _DonutChartPainter(values: values),
          ),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          alignment: WrapAlignment.center,
          children: List.generate(values.length, (idx) {
            final color = _getSegmentColor(idx);
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${labels[idx]} (${(values[idx] * 100).toStringAsFixed(0)}%)',
                  style: TextStyle(fontSize: 9, color: Theme.of(context).colorScheme.onSurface),
                ),
                SizedBox(width: 4),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  static Color _getSegmentColor(int index) {
    const colors = [
      Color(0xFF0040E0),
      Color(0xFF006B5F),
      Color(0xFFFF9800),
      Color(0xFF9C27B0),
      Color(0xFFE91E63),
    ];
    return colors[index % colors.length];
  }
}

class _DonutChartPainter extends CustomPainter {
  final List<double> values;

  _DonutChartPainter({required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    final double total = values.fold(0, (sum, val) => sum + val);
    double startAngle = -3.14 / 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = radius * 0.35;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true;

    for (int i = 0; i < values.length; i++) {
      final double sweepAngle = total > 0 ? (values[i] / total) * 3.14 * 2 : 0;
      paint.color = SubscriptionChart._getSegmentColor(i);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
