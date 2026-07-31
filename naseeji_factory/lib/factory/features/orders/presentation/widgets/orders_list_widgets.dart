import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_radius.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/reusable_widgets.dart';
import '../providers/orders_provider.dart';

class OrdersAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const OrdersAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('إدارة وتتبع الطلبات'),
      actions: [
        IconButton(
          icon: const Icon(Icons.history_toggle_off_rounded),
          tooltip: 'سجل الطلبات الأرشيفية',
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class SearchWidget extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const SearchWidget({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return AppSearchBar(
      hintText: 'ابحث برقم الطلب أو اسم المورد...',
      onChanged: onChanged,
      onFilterTap: () {},
    );
  }
}

class FilterWidget extends StatelessWidget {
  final VoidCallback onTap;

  const FilterWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.filter_list_rounded, color: AppColors.primary),
      onPressed: onTap,
    );
  }
}

class StatusTabsWidget extends StatelessWidget {
  final TabController tabController;
  final List<Map<String, String>> tabs;

  const StatusTabsWidget({
    super.key,
    required this.tabController,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      isScrollable: true,
      labelColor: AppColors.primary,
      unselectedLabelColor: Colors.grey,
      indicatorColor: AppColors.primary,
      tabs: tabs.map((t) => Tab(text: t['label'])).toList(),
    );
  }
}

class OrdersListWidget extends StatelessWidget {
  final List<OrderModel> orders;

  const OrdersListWidget({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const EmptyState(
        icon: Icons.assignment_outlined,
        title: 'لا توجد طلبات تطابق الفلترة',
        description: 'جرب تعديل حالة البحث أو التحقق من التبويبات الأخرى.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: orders.length,
      separatorBuilder: (context, index) => AppSpacing.hMD,
      itemBuilder: (context, index) {
        return OrderCardWidget(order: orders[index]);
      },
    );
  }
}

class OrderCardWidget extends StatelessWidget {
  final OrderModel order;

  const OrderCardWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;

    switch (order.status) {
      case 'new':
        statusColor = AppColors.info;
        statusText = 'طلب جديد مؤكد';
        break;
      case 'preparing':
        statusColor = AppColors.secondary;
        statusText = 'قيد التجهيز والإنتاج';
        break;
      case 'readyToShip':
        statusColor = AppColors.warning;
        statusText = 'جاهز للشحن';
        break;
      case 'shipping':
        statusColor = Colors.purple;
        statusText = 'جاري الشحن الآن';
        break;
      case 'delivered':
        statusColor = AppColors.success;
        statusText = 'تم التسليم والاعتماد';
        break;
      case 'cancelled':
      default:
        statusColor = AppColors.error;
        statusText = 'ملغي / نزاع مفتوح';
        break;
    }

    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'أمر الشراء: ${order.id}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    'طلب عرض السعر: ${order.rfqId}',
                    style: const TextStyle(color: Colors.grey, fontSize: 9),
                  ),
                ],
              ),
              StatusChip(label: statusText, color: statusColor),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            children: [
              SupplierAvatar(name: order.supplierName, size: 36),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.productName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    Text(
                      'المورد: ${order.supplierName} • الكمية: ${order.quantity} وحدة',
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'القيمة الإجمالية: ${order.finalPrice.toInt()} ج.م',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primary),
              ),
              Text(
                'تاريخ الطلب: ${order.orderDate}',
                style: const TextStyle(color: Colors.grey, fontSize: 9),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('نسبة تقدم الطلب', style: TextStyle(color: Colors.grey, fontSize: 9)),
                  Text('${order.progressPercentage.toInt()}%', style: TextStyle(fontWeight: FontWeight.bold, color: statusColor, fontSize: 10)),
                ],
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: order.progressPercentage / 100.0,
                color: statusColor,
                backgroundColor: Colors.grey.shade200,
                borderRadius: AppRadius.rRound,
                minHeight: 6,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'التسليم المتوقع: ${order.expectedDeliveryDate}',
                style: const TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () => context.push('/orders/${order.id}'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text('عرض التفاصيل والتتبع', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FloatingSearchButtonWidget extends StatelessWidget {
  final VoidCallback onTap;

  const FloatingSearchButtonWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      onPressed: onTap,
      child: const Icon(Icons.search_rounded),
    );
  }
}
