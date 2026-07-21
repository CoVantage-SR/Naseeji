import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/dashboard_providers.dart';
import '../shared/dashboard_card_widget.dart';
import '../shared/dashboard_section_title_widget.dart';
import '../shared/dashboard_loading_widget.dart';

class OrdersOverviewWidget extends ConsumerWidget {
  const OrdersOverviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersOverviewProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardSectionTitleWidget(
          title: 'ملخص وحالة الطلبات',
          subtitle: 'متابعة مراحل الإنتاج والتجهيز والشحن',
          icon: Icons.shopping_bag_rounded,
          actionText: 'إدارة الطلبات',
          onActionTap: () => context.push('/orders'),
        ),
        ordersAsync.when(
          loading: () => const DashboardLoadingWidget(height: 180),
          error: (err, stack) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('خطأ في تحميل ملخص الطلبات: $err'),
          ),
          data: (orders) {
            final List<Map<String, dynamic>> stages = [
              {
                'title': 'قيد التجهيز',
                'count': orders.preparing,
                'icon': Icons.inventory_2_outlined,
                'color': const Color(0xFF0288D1),
              },
              {
                'title': 'جاهز للاستلام',
                'count': orders.readyForPickup,
                'icon': Icons.unarchive_outlined,
                'color': const Color(0xFF009688),
              },
              {
                'title': 'بانتظار اللوجستيات',
                'count': orders.waitingLogistics,
                'icon': Icons.transfer_within_a_station_rounded,
                'color': const Color(0xFFE65100),
              },
              {
                'title': 'جاري الشحن',
                'count': orders.shipping,
                'icon': Icons.local_shipping_outlined,
                'color': const Color(0xFF673AB7),
              },
              {
                'title': 'تم التوصيل',
                'count': orders.delivered,
                'icon': Icons.mark_unread_chat_space_rounded,
                'color': const Color(0xFF006B5F),
              },
              {
                'title': 'مكتمل ومستلم',
                'count': orders.completed,
                'icon': Icons.check_circle_outline_rounded,
                'color': const Color(0xFF2E7D32),
              },
              {
                'title': 'طلبات متأخرة',
                'count': orders.delayed,
                'icon': Icons.warning_amber_rounded,
                'color': const Color(0xFFBA1A1A),
              },
            ];

            return DashboardCardWidget(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final int crossCount = constraints.maxWidth > 600 ? 4 : 2;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossCount,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2.2,
                        ),
                        itemCount: stages.length,
                        itemBuilder: (context, index) {
                          final stage = stages[index];
                          final Color color = stage['color'] as Color;

                          return InkWell(
                            onTap: () => context.push('/orders'),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: color.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    stage['icon'] as IconData,
                                    color: color,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          stage['title'] as String,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          '${stage['count']}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
