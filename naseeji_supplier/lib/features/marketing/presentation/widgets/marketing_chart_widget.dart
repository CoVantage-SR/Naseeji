import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class MarketingChartWidget extends StatelessWidget {
  final String title;
  final List<double> values;
  final List<String> labels;
  final String chartType; // 'bar', 'double_bar', 'donut'
  final List<double>? secondaryValues; // Used in double_bar
  final List<Color>? donutColors; // Used in donut

  const MarketingChartWidget({
    super.key,
    required this.title,
    required this.values,
    required this.labels,
    this.chartType = 'bar',
    this.secondaryValues,
    this.donutColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
          ),
          const SizedBox(height: 20),
          if (chartType == 'bar') _buildBarChart(context),
          if (chartType == 'double_bar') _buildDoubleBarChart(context),
          if (chartType == 'donut') _buildDonutChart(context),
        ],
      ),
    );
  }

  Widget _buildBarChart(BuildContext context) {
    if (values.isEmpty) return const SizedBox(height: 150, child: Center(child: Text('لا توجد بيانات')));
    final double maxValue = values.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(values.length, (index) {
          final val = values[index];
          final label = labels[index];
          final heightPercent = maxValue > 0 ? (val / maxValue) : 0.0;

          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  val.toStringAsFixed(val % 1 == 0 ? 0 : 1),
                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: 4),
                Container(
                  height: heightPercent * 100 + 4,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0040E0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: const TextStyle(fontSize: 8, color: AppColors.onSurfaceVariant),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDoubleBarChart(BuildContext context) {
    if (values.isEmpty || secondaryValues == null || secondaryValues!.isEmpty) {
      return const SizedBox(height: 150, child: Center(child: Text('لا توجد بيانات')));
    }
    final double maxVal1 = values.reduce((a, b) => a > b ? a : b);
    final double maxVal2 = secondaryValues!.reduce((a, b) => a > b ? a : b);
    final double overallMax = maxVal1 > maxVal2 ? maxVal1 : maxVal2;

    return SizedBox(
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(values.length, (index) {
          final val1 = values[index];
          final val2 = secondaryValues![index];
          final label = labels[index];
          final hPercent1 = overallMax > 0 ? (val1 / overallMax) : 0.0;
          final hPercent2 = overallMax > 0 ? (val2 / overallMax) : 0.0;

          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${val1.toStringAsFixed(0)}/${val2.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        height: hPercent1 * 90 + 4,
                        margin: const EdgeInsets.only(left: 2),
                        decoration: const BoxDecoration(
                          color: Color(0xFF0040E0),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: hPercent2 * 90 + 4,
                        margin: const EdgeInsets.only(right: 2),
                        decoration: const BoxDecoration(
                          color: Color(0xFF006B5F),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: const TextStyle(fontSize: 8, color: AppColors.onSurfaceVariant),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDonutChart(BuildContext context) {
    if (values.isEmpty) return const SizedBox(height: 150, child: Center(child: Text('لا توجد بيانات')));
    final total = values.fold<double>(0, (sum, val) => sum + val);

    final colors = donutColors ?? [
      const Color(0xFF0040E0),
      const Color(0xFF006B5F),
      const Color(0xFFFF9800),
      const Color(0xFFE91E63),
      const Color(0xFF9C27B0),
      const Color(0xFF607D8B),
    ];

    return Row(
      children: [
        // Legend on the left
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(values.length, (idx) {
              final val = values[idx];
              final label = labels[idx];
              final percent = total > 0 ? (val / total * 100) : 0.0;
              final color = colors[idx % colors.length];

              return Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${percent.toStringAsFixed(1)}% ($label)',
                      style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 16),
        // Donut circle container on the right
        Expanded(
          flex: 2,
          child: Center(
            child: SizedBox(
              width: 90,
              height: 90,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _DonutChartPainter(values: values, colors: colors),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.pie_chart_outline_outlined, color: AppColors.outline, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;

  _DonutChartPainter({required this.values, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final double total = values.fold<double>(0, (sum, val) => sum + val);
    if (total == 0) return;

    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    double startAngle = -3.1415926535 / 2; // Start from top
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    for (int i = 0; i < values.length; i++) {
      final sweepAngle = (values[i] / total) * 2 * 3.1415926535;
      paint.color = colors[i % colors.length];
      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
