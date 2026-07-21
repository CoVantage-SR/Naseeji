import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/dashboard_providers.dart';
import '../shared/dashboard_section_title_widget.dart';
import '../shared/dashboard_stat_card_widget.dart';
import '../shared/dashboard_loading_widget.dart';

class BusinessOverviewGridWidget extends ConsumerWidget {
  const BusinessOverviewGridWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DashboardSectionTitleWidget(
          title: 'نظرة عامة على الأعمال',
          subtitle: 'المؤشرات التشغيلية والمالية الفورية',
          icon: Icons.dashboard_customize_outlined,
        ),
        statsAsync.when(
          loading: () => const DashboardLoadingWidget(height: 220),
          error: (err, stack) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('خطأ في تحميل نظرة الأعمال: $err'),
          ),
          data: (stats) {
            return LayoutBuilder(
              builder: (context, constraints) {
                // Responsive grid column count
                int crossAxisCount = 2;
                if (constraints.maxWidth > 900) {
                  crossAxisCount = 4;
                } else if (constraints.maxWidth > 600) {
                  crossAxisCount = 3;
                }

                final List<Map<String, dynamic>> items = [
                  {
                    'title': 'طلبات أسعار جديدة',
                    'value': '${stats.newRfqs}',
                    'icon': Icons.request_quote_outlined,
                    'color': const Color(0xFF0040E0),
                    'route': '/orders',
                    'trend': '+12% هذا الأسبوع',
                    'isPositive': true,
                  },
                  {
                    'title': 'عروض بانتظار الرد',
                    'value': '${stats.waitingQuotations}',
                    'icon': Icons.pending_actions_outlined,
                    'color': const Color(0xFFE65100),
                    'route': '/orders',
                    'trend': 'تحتاج متابعة',
                    'isPositive': false,
                  },
                  {
                    'title': 'طلبات قيد التفاوض',
                    'value': '${stats.ordersUnderNegotiation}',
                    'icon': Icons.handshake_outlined,
                    'color': const Color(0xFF673AB7),
                    'route': '/orders',
                    'trend': 'نشط',
                    'isPositive': true,
                  },
                  {
                    'title': 'طلبات قيد التصنيع',
                    'value': '${stats.ordersInProduction}',
                    'icon': Icons.precision_manufacturing_outlined,
                    'color': const Color(0xFF0288D1),
                    'route': '/orders',
                    'trend': 'جاري العمل',
                    'isPositive': true,
                  },
                  {
                    'title': 'جاهز للشحن',
                    'value': '${stats.readyForShipment}',
                    'icon': Icons.local_shipping_outlined,
                    'color': const Color(0xFF006B5F),
                    'route': '/shipping',
                    'trend': 'بانتظار الناقل',
                    'isPositive': true,
                  },
                  {
                    'title': 'طلبات متأخرة',
                    'value': '${stats.delayedOrders}',
                    'icon': Icons.warning_amber_rounded,
                    'color': const Color(0xFFBA1A1A),
                    'route': '/orders',
                    'trend': 'تنبيه تأخير',
                    'isPositive': false,
                  },
                  {
                    'title': 'طلبات مكتملة',
                    'value': '${stats.completedOrders}',
                    'icon': Icons.check_circle_outline_rounded,
                    'color': const Color(0xFF2E7D32),
                    'route': '/orders',
                    'trend': '+18 هذا الشهر',
                    'isPositive': true,
                  },
                  {
                    'title': 'الإيراد الشهري',
                    'value': '${stats.monthlyRevenue.toStringAsFixed(0)} ج.م',
                    'icon': Icons.monetization_on_outlined,
                    'color': const Color(0xFFD81B60),
                    'route': '/financial',
                    'trend': '+15% مقارنة بالسابق',
                    'isPositive': true,
                  },
                ];

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: constraints.maxWidth > 600 ? 1.4 : 1.25,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return DashboardStatCardWidget(
                      title: item['title'] as String,
                      value: item['value'] as String,
                      icon: item['icon'] as IconData,
                      accentColor: item['color'] as Color,
                      trendText: item['trend'] as String?,
                      isPositiveTrend: item['isPositive'] as bool?,
                      onTap: () => context.push(item['route'] as String),
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}
