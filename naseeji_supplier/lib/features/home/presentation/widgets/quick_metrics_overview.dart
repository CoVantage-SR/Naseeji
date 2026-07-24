import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuickMetricsOverviewWidget extends StatelessWidget {
  const QuickMetricsOverviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.4,
        children: [
          // 1. Published Products Card
          _MetricCard(
            title: 'منتج منشور',
            value: '18',
            subtitle: 'نشط',
            icon: Icons.inventory_2_outlined,
            iconColor: const Color(0xFFF97316),
            onTap: () => context.push('/products'),
          ),

          // 2. Ongoing Deals Card
          _MetricCard(
            title: 'صفقات جارية',
            value: '8',
            subtitle: 'قيد التنفيذ',
            icon: Icons.handshake_outlined,
            iconColor: const Color(0xFF9333EA),
            onTap: () => context.push('/deals'),
          ),

          // 3. New RFQs Card
          _MetricCard(
            title: 'طلبات عروض سعر',
            value: '24',
            subtitle: 'جديدة',
            icon: Icons.description_outlined,
            iconColor: const Color(0xFF2563EB),
            onTap: () => context.push('/orders'),
          ),

          // 4. Total Sales Card
          _MetricCard(
            title: 'إجمالي المبيعات',
            value: '125,400',
            subtitle: '↑ +18% عن الشهر الماضي',
            isGreenSubtitle: true,
            icon: Icons.attach_money_rounded,
            iconColor: const Color(0xFF16A34A),
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
  final VoidCallback onTap;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    this.isGreenSubtitle = false,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.015),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Row: Icon (Left) & Title (Right)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 18),
                ),
                const Spacer(),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),

            // Value Text
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),

            // Subtitle Status Text
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isGreenSubtitle ? FontWeight.bold : FontWeight.normal,
                color: isGreenSubtitle ? const Color(0xFF16A34A) : colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }
}
