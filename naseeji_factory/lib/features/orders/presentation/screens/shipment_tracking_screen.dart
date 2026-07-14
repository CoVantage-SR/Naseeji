import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/orders_provider.dart';
import '../widgets/shipment_tracking_widgets.dart';

class ShipmentTrackingScreen extends ConsumerWidget {
  final String orderId;

  const ShipmentTrackingScreen({super.key, required this.orderId});

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
        title: const Text('تتبع الشحنة'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.description_outlined),
            tooltip: 'وثائق الشحنة',
            onPressed: () => context.push('/orders/$orderId/shipment/details'),
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
              ShipmentHeaderWidget(order: order),
              AppSpacing.hMD,
              EstimatedArrivalWidget(date: order.expectedDeliveryDate),
              AppSpacing.hMD,
              ShipmentProgressWidget(order: order),
              AppSpacing.hMD,
              TrackingTimelineWidget(status: order.status),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
