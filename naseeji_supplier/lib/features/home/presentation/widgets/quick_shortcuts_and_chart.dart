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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Card: Sales Performance Chart Mockup
          Expanded(
            child: Container(
              height: 210,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.keyboard_arrow_down, size: 12),
                            Text('هذا الشهر', style: TextStyle(fontSize: 9.5)),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'أداء المبيعات',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '125,400 ج.م',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    '↑ +18% عن الشهر الماضي',
                    style: TextStyle(fontSize: 9.5, color: Color(0xFF16A34A), fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),

                  // Mock Graph Curve Visual
                  Container(
                    height: 70,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF2563EB).withValues(alpha: 0.25),
                          const Color(0xFF2563EB).withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('1 مايو', style: TextStyle(fontSize: 8, color: Colors.grey)),
                          Text('10 مايو', style: TextStyle(fontSize: 8, color: Colors.grey)),
                          Text('20 مايو', style: TextStyle(fontSize: 8, color: Colors.grey)),
                          Text('31 مايو', style: TextStyle(fontSize: 8, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Right Card: Quick Shortcuts Grid (RTL Grid)
          Expanded(
            child: Container(
              height: 210,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'اختصارات سريعة',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.9,
                      children: [
                        _ShortcutItem(
                          title: 'الصفقات',
                          icon: Icons.handshake_outlined,
                          color: Colors.purple,
                          onTap: () => context.push('/deals'),
                        ),
                        _ShortcutItem(
                          title: 'الطلبات',
                          icon: Icons.description_outlined,
                          color: Colors.green,
                          onTap: () => context.push('/orders'),
                        ),
                        _ShortcutItem(
                          title: 'المنتجات',
                          icon: Icons.inventory_2_outlined,
                          color: Colors.blue,
                          onTap: () => context.push('/products'),
                        ),
                        _ShortcutItem(
                          title: 'المزيد',
                          icon: Icons.grid_view_rounded,
                          color: Colors.grey.shade700,
                          onTap: () => QuickActionFab.showQuickActionsBottomSheet(context),
                        ),
                        _ShortcutItem(
                          title: 'المحادثات',
                          icon: Icons.chat_outlined,
                          color: Colors.blue.shade800,
                          onTap: () => context.push('/messages'),
                        ),
                        _ShortcutItem(
                          title: 'التقارير',
                          icon: Icons.insert_chart_outlined_rounded,
                          color: Colors.orange.shade800,
                          onTap: () => context.push('/analytics'),
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

class _ShortcutItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ShortcutItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 3),
            Text(
              title,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
