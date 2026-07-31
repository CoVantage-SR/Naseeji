import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'quick_action_fab.dart';

class QuickShortcutsAndChartWidget extends StatelessWidget {
  const QuickShortcutsAndChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── 1. Right Card (RTL): Sales Performance Chart ─────────────────
          Expanded(
            child: Container(
              height: 226,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.015),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Header: Title (Right) & Month Filter Pill (Left)
                  Row(
                    children: [
                      // Title (Right in RTL)
                      const Text(
                        'أداء المبيعات',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),

                      // Month Filter Dropdown Pill (Left in RTL)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withValues(
                              alpha: 0.4,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check_rounded,
                              size: 10,
                              color: Color(0xFF2563EB),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              'هذا الشهر',
                              style: TextStyle(
                                fontSize: 9.5,
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 14,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Sales Revenue Amount (Right Aligned RTL)
                  const Text(
                    '125,400 ج.م',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.2,
                    ),
                  ),

                  // Subtitle & Trend Tag (Right Aligned RTL)
                  Row(
                    children: const [
                      Text(
                        'إجمالي المبيعات',
                        style: TextStyle(fontSize: 9.5, color: Colors.grey),
                      ),
                      SizedBox(width: 4),
                      Text(
                        '↑ 18%+ عن الشهر الماضي',
                        style: TextStyle(
                          fontSize: 9.5,
                          color: Color(0xFF16A34A),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Chart Visualization with Y-Axis Labels & Ascending Curve
                  Expanded(
                    child: Row(
                      children: [
                        // Y-Axis Labels (Left)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '160K',
                              style: TextStyle(
                                fontSize: 7.5,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '120K',
                              style: TextStyle(
                                fontSize: 7.5,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '80K',
                              style: TextStyle(
                                fontSize: 7.5,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '40K',
                              style: TextStyle(
                                fontSize: 7.5,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '0',
                              style: TextStyle(
                                fontSize: 7.5,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 6),

                        // Ascending Curve Chart Canvas
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: CustomPaint(
                                    painter: _SalesChartPainter(
                                      lineColor: const Color(0xFF2563EB),
                                      fillColor: const Color(0xFF2563EB),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 4),

                              // X-Axis Dates (1 مايو on Left -> 31 مايو on Right)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    '1 مايو',
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '10 مايو',
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '20 مايو',
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '31 مايو',
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 10),

          // ─── 2. Left Card (RTL): Quick Shortcuts ───────────────────────────
          Expanded(
            child: Container(
              height: 226,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.015),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'اختصارات سريعة',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 4,
                      childAspectRatio: 0.72,
                      children: [
                        // Row 1 (RTL): الصفقات, الطلبات, المنتجات
                        _ShortcutTileItem(
                          title: 'الصفقات',
                          icon: Icons.handshake_outlined,
                          iconColor: const Color(0xFF9333EA),
                          bgColor: const Color(0xFFFAF5FF),
                          onTap: () => context.push('/deals'),
                        ),
                        _ShortcutTileItem(
                          title: 'الطلبات',
                          icon: Icons.description_outlined,
                          iconColor: const Color(0xFF16A34A),
                          bgColor: const Color(0xFFF0FDF4),
                          onTap: () => context.push('/orders'),
                        ),
                        _ShortcutTileItem(
                          title: 'المنتجات',
                          icon: Icons.article_outlined,
                          iconColor: const Color(0xFF2563EB),
                          bgColor: const Color(0xFFEFF6FF),
                          onTap: () => context.push('/products'),
                        ),

                        // Row 2 (RTL): التقارير, المحادثات, المزيد
                        _ShortcutTileItem(
                          title: 'التقارير',
                          icon: Icons.bar_chart_rounded,
                          iconColor: const Color(0xFFEA580C),
                          bgColor: const Color(0xFFFFF7ED),
                          onTap: () => context.push('/analytics'),
                        ),
                        _ShortcutTileItem(
                          title: 'المحادثات',
                          icon: Icons.chat_bubble_outline_rounded,
                          iconColor: const Color(0xFF2563EB),
                          bgColor: const Color(0xFFEFF6FF),
                          onTap: () => context.push('/messages'),
                        ),
                        _ShortcutTileItem(
                          title: 'المزيد',
                          icon: Icons.grid_view_rounded,
                          iconColor: const Color(0xFF475569),
                          bgColor: const Color(0xFFF8FAFC),
                          onTap: () =>
                              QuickActionFab.showQuickActionsBottomSheet(
                                context,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShortcutTileItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final VoidCallback onTap;

  const _ShortcutTileItem({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isDark ? iconColor.withValues(alpha: 0.2) : bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: isDark ? iconColor.withValues(alpha: 0.9) : iconColor, size: 22),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _SalesChartPainter extends CustomPainter {
  final Color lineColor;
  final Color fillColor;

  _SalesChartPainter({required this.lineColor, required this.fillColor});

  @override
  void paint(Canvas canvas, Size size) {
    // Horizontal light grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.12)
      ..strokeWidth = 0.8;

    for (int i = 0; i <= 4; i++) {
      double y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Ascending sales points: Starts low at 1 مايو (left) and grows UPWARDS to 160K at 31 مايو (right)
    final points = [
      Offset(0, size.height * 0.82), // 1 مايو (Bottom Left - Low)
      Offset(size.width * 0.2, size.height * 0.68),
      Offset(size.width * 0.4, size.height * 0.52),
      Offset(size.width * 0.65, size.height * 0.35),
      Offset(size.width * 0.82, size.height * 0.20),
      Offset(size.width, size.height * 0.08), // 31 مايو (Top Right - High 160K)
    ];

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      final controlPoint1 = Offset(p1.dx + (p2.dx - p1.dx) / 2, p1.dy);
      final controlPoint2 = Offset(p1.dx + (p2.dx - p1.dx) / 2, p2.dy);
      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        p2.dx,
        p2.dy,
      );
    }

    // Gradient area fill under curve
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          lineColor.withValues(alpha: 0.3),
          lineColor.withValues(alpha: 0.01),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    // Blue Line Paint
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);

    // Point Dots on curve
    final dotPaint = Paint()..color = lineColor;
    final dotInnerPaint = Paint()..color = Colors.white;

    for (final pt in points) {
      canvas.drawCircle(pt, 3.0, dotPaint);
      canvas.drawCircle(pt, 1.2, dotInnerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


