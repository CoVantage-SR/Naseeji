import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/orders_provider.dart';
import '../widgets/live_status_widgets.dart';

class LiveOrderStatusScreen extends ConsumerWidget {
  final String orderId;

  const LiveOrderStatusScreen({super.key, required this.orderId});

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
        title: const Text('البث المباشر لحالة الطلب'),
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
              LiveStatusHeaderWidget(order: order),
              AppSpacing.hMD,
              CurrentStatusCardWidget(order: order),
              AppSpacing.hMD,
              const CountdownWidget(remainingDays: 6),
              AppSpacing.hMD,
              const LatestUpdatesWidget(
                updateText: 'تم الانتهاء من فحص جودة خط اللف على البكر ومطابقته لكثافة الشد المعتمدة من الاستشاري الفني.',
              ),
              AppSpacing.hMD,
              const LatestMediaWidget(),
              AppSpacing.hMD,
              TimelinePreviewWidget(order: order),
              AppSpacing.hMD,
              QuickActionsWidget(order: order),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}


