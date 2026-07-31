// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../controllers/customers_controller.dart';
import '../../domain/entities/customer_model.dart';

class CustomerOrdersScreen extends ConsumerWidget {
  final String customerId;

  const CustomerOrdersScreen({super.key, required this.customerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(customersControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0.5,
          centerTitle: true,
          title: Text('طلبات العميل', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.onSurfaceVariant),
            onPressed: () => context.pop(),
          ),
        ),
        body: stateAsync.when(
          loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (e, _) => Center(child: Text('خطأ: $e')),
          data: (customers) {
            final idx = customers.indexWhere((c) => c.id == customerId);
            if (idx == -1) return Center(child: Text('العميل غير موجود'));
            final customer = customers[idx];

            if (customer.orders.isEmpty) {
              return Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.shopping_bag_outlined, size: 56, color: AppColors.outlineVariant),
                  SizedBox(height: 12),
                  Text('لا توجد طلبات لهذا العميل', style: TextStyle(color: AppColors.outline, fontSize: 13)),
                ]),
              );
            }

            return RefreshIndicator(
              onRefresh: () => ref.read(customersControllerProvider.notifier).refresh(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: customer.orders.length,
                itemBuilder: (_, i) => _buildOrderCard(context, customer.orders[i]),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, CustomerOrder o) {
    Color statusColor = AppColors.primary;
    if (o.status == 'مكتمل') statusColor = Colors.green;
    if (o.status == 'ملغي') statusColor = AppColors.error;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E1EF), width: 0.5),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 8)],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(o.orderNumber, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary)),
                  _badge(o.status, statusColor),
                ]),
                SizedBox(height: 10),
                Divider(height: 1, color: AppColors.surfaceContainerLow),
                SizedBox(height: 10),
                _row('المنتج', o.productName),
                _row('الكمية المطلوبة', '${o.quantity.toStringAsFixed(0)} وحدة'),
                _row('السعر الإجمالي', '${o.totalPrice.toStringAsFixed(2)} ${o.currency}'),
                _row('موعد التسليم', o.deliveryDate),
                _row('حالة الدفع', o.paymentStatus),
                _row('حالة الشحنة', o.shipmentStatus),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _actionBtn('عرض التفاصيل', Icons.visibility_outlined, () => context.push('/orders')),
                SizedBox(width: 8),
                _actionBtn('تتبع الشحنة', Icons.location_on_outlined, () => context.push('/shipping')),
                SizedBox(width: 8),
                _actionBtn('محادثة', Icons.forum_outlined, () => context.push('/messages')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color)),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(fontSize: 11, color: AppColors.outline)),
        Text(value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
      ]),
    );
  }

  Widget _actionBtn(String label, IconData icon, VoidCallback onTap) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 13, color: AppColors.primary),
      label: Text(label, style: TextStyle(fontSize: 9, color: AppColors.primary)),
      style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), tapTargetSize: MaterialTapTargetSize.shrinkWrap, minimumSize: Size.zero),
    );
  }
}


