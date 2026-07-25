import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuickMetricsOverviewWidget extends StatelessWidget {
  const QuickMetricsOverviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 2.7,
        children: [
          // 1. Published Products Card
          _MetricCard(
            title: 'منتج منشور',
            value: '18',
            subtitle: 'نشط',
            icon: Icons.inventory_2_outlined,
            iconColor: const Color(0xFFEA580C),
            bgColor: const Color(0xFFFFF7ED),
            borderColor: const Color(0xFFFFEDD5),
            onTap: () => context.push('/products'),
          ),

          // 2. Ongoing Deals Card
          _MetricCard(
            title: 'صفقات جارية',
            value: '8',
            subtitle: 'قيد التنفيذ',
            icon: Icons.handshake_outlined,
            iconColor: const Color(0xFF9333EA),
            bgColor: const Color(0xFFFAF5FF),
            borderColor: const Color(0xFFF3E8FF),
            onTap: () => context.push('/deals'),
          ),

          // 3. New RFQs Card
          _MetricCard(
            title: 'طلبات الأسعار',
            value: '24',
            subtitle: 'جديدة',
            icon: Icons.description_outlined,
            iconColor: const Color(0xFF2563EB),
            bgColor: const Color(0xFFEFF6FF),
            borderColor: const Color(0xFFDBEAFE),
            onTap: () => context.push('/orders'),
          ),

          // 4. Total Sales Card
          _MetricCard(
            title: 'إجمالي المبيعات',
            value: '125,400',
            subtitle: '↑ 18%+',
            isGreenSubtitle: true,
            icon: Icons.attach_money_rounded,
            iconColor: const Color(0xFF16A34A),
            bgColor: const Color(0xFFF0FDF4),
            borderColor: const Color(0xFFDCFCE7),
            onTap: () => context.push('/analytics'),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final bool isGreenSubtitle;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    this.isGreenSubtitle = false,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isDark ? const Color(0xFF334155) : borderColor),
          boxShadow: [
            BoxShadow(
              color: iconColor.withValues(alpha: isDark ? 0.1 : 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Container (Left)
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: isDark ? const Color(0xFF334155) : borderColor),
              ),
              child: Icon(icon, color: isDark ? iconColor.withValues(alpha: 0.9) : iconColor, size: 16),
            ),

            const SizedBox(width: 8),

            // Main Details (Right - RTL)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      if (isGreenSubtitle)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: const Color(0xFF16A34A).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 8.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF16A34A),
                            ),
                          ),
                        )
                      else
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 8.5,
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                          ),
                        ),
                      const Spacer(),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 1),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                      letterSpacing: -0.2,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
