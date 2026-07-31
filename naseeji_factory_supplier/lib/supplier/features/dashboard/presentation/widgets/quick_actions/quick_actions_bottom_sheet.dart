import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuickActionsBottomSheet extends StatelessWidget {
  const QuickActionsBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const QuickActionsBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<Map<String, dynamic>> actions = [
      {
        'title': 'إضافة منتج',
        'subtitle': 'إدراج قماش أو خيوط جديدة للمعرض',
        'icon': Icons.add_circle_outline_rounded,
        'color': const Color(0xFF0040E0),
        'route': '/add-product',
      },
      {
        'title': 'إنشاء إعلان',
        'subtitle': 'ترويج منتج في أعلى نتائج البحث',
        'icon': Icons.campaign_outlined,
        'color': const Color(0xFFE65100),
        'route': '/subscription/addons',
      },
      {
        'title': 'رفع الكتالوج',
        'subtitle': 'تحديث كتالوج عينات الأقمشة',
        'icon': Icons.upload_file_rounded,
        'color': const Color(0xFF006B5F),
        'route': '/products',
      },
      {
        'title': 'إنشاء طلب سعر',
        'subtitle': 'تقديم عرض تسعير مباشر لمشتري',
        'icon': Icons.request_quote_outlined,
        'color': const Color(0xFF673AB7),
        'route': '/orders',
      },
      {
        'title': 'المركز المالي',
        'subtitle': 'سحب الأرباح ومتابعة رصيد الضمان',
        'icon': Icons.account_balance_wallet_outlined,
        'color': const Color(0xFF2E7D32),
        'route': '/financial',
      },
      {
        'title': 'التحليلات والتقارير',
        'subtitle': 'عرض تقارير المبيعات ونسب القبول',
        'icon': Icons.insights_outlined,
        'color': const Color(0xFFD81B60),
        'route': '/analytics',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header Title
            Row(
              children: [
                Icon(
                  Icons.bolt_rounded,
                  color: colorScheme.primary,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  'الإجراءات والعمليات السريعة',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Action Items Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.2,
              ),
              itemCount: actions.length,
              itemBuilder: (context, index) {
                final action = actions[index];
                final Color color = action['color'] as Color;

                return InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push(action['route'] as String);
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: color.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            action['icon'] as IconData,
                            color: color,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                action['title'] as String,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                action['subtitle'] as String,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

