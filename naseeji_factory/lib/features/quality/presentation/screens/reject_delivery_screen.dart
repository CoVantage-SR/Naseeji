import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../widgets/reject_delivery/reject_delivery_form.dart';

class RejectDeliveryScreen extends ConsumerWidget {
  final String orderId;

  const RejectDeliveryScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(ordersNotifierProvider.notifier).getOrderById(orderId);

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('خطأ')),
        body: const Center(child: Text('الطلب المطلوب غير موجود.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('رفض استلام الشحنة'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: RejectDeliveryForm(order: order),
      ),
    );
  }
}
