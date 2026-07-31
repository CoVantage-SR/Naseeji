import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/orders_provider.dart';
import '../widgets/order_timeline_widgets.dart';

class OrderTimelineScreen extends ConsumerWidget {
  final String orderId;

  const OrderTimelineScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timelineItems = ref.watch(timelineNotifierProvider)[orderId] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('المخطط الزمني للطلب'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TimelineHeaderWidget(orderId: orderId),
              AppSpacing.hMD,
              TimelineWidget(items: timelineItems),
            ],
          ),
        ),
      ),
    );
  }
}
