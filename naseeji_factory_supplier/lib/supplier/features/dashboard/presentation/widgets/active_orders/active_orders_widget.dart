import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/dashboard_providers.dart';
import '../shared/dashboard_section_title.dart';
import '../shared/order_progress_card.dart';
import '../shared/loading_widget.dart';
import '../shared/empty_state_widget.dart';
import '../shared/error_state_widget.dart';

class ActiveOrdersWidget extends ConsumerWidget {
  const ActiveOrdersWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardSectionTitle(
          title: 'الطلبات النشطة وقيد التنفيذ',
          subtitle: 'متابعة مراحل ومراحل تقدم طلبات الشراء الحالية',
          icon: Icons.shopping_bag_rounded,
          actionText: 'عرض الكل',
          onActionTap: () => context.push('/orders'),
        ),
        ordersAsync.when(
          loading: () => const LoadingWidget(height: 160),
          error: (err, stack) => ErrorStateWidget(
            message: 'خطأ في تحميل الطلبات النشطة: $err',
            onRetry: () => ref.invalidate(ordersProvider),
          ),
          data: (orders) {
            if (orders.isEmpty) {
              return const EmptyStateWidget(
                title: 'لا توجد طلبات نشطة حالياً',
                description: 'ستظهر الطلبات المؤكدة وقيد التصنيع أو الشحن هنا.',
                icon: Icons.assignment_outlined,
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orders.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final order = orders[index];
                return OrderProgressCard(order: order);
              },
            );
          },
        ),
      ],
    );
  }
}



