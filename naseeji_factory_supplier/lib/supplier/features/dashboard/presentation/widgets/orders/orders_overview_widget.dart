import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/dashboard_providers.dart';
import '../shared/dashboard_card.dart';
import '../shared/dashboard_section_title.dart';
import '../shared/loading_widget.dart';

class OrdersOverviewWidget extends ConsumerWidget {
  const OrdersOverviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardSectionTitle(
          title: 'ملخص وحالة الطلبات',
          subtitle: 'متابعة مراحل الإنتاج والتجهيز والشحن',
          icon: Icons.shopping_bag_rounded,
          actionText: 'إدارة الطلبات',
          onActionTap: () => context.push('/orders'),
        ),
        ordersAsync.when(
          loading: () => const LoadingWidget(height: 140),
          error: (err, stack) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('خطأ في تحميل ملخص الطلبات: $err'),
          ),
          data: (orders) {
            return DashboardCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Text(
                    'لديك ${orders.length} طلبات جارية تنفذ حالياً',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
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


