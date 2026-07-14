import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/orders_provider.dart';
import '../widgets/order_details_widgets.dart';

class OrderDetailsScreen extends ConsumerWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(ordersNotifierProvider.notifier).getOrderById(orderId);

    if (order == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('الطلب المطلوب غير موجود.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل وتتبع الطلب'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.online_prediction_rounded),
            tooltip: 'البث المباشر للطلب',
            onPressed: () => context.push('/orders/${order.id}/live'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OrderHeaderWidget(order: order),
              AppSpacing.hMD,
              OrderProgressWidget(order: order),
              AppSpacing.hMD,
              QuickActionsWidget(order: order),
              AppSpacing.hMD,
              SupplierInformationWidget(order: order),
              AppSpacing.hMD,
              AgreementSummaryWidget(order: order),
              AppSpacing.hMD,
              DeliveryInformationWidget(order: order),
              AppSpacing.hMD,
              PaymentInformationWidget(order: order),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
