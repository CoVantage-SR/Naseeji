import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../providers/quality_provider.dart';
import '../widgets/delivery_receipt_widgets.dart';

class DeliveryReceiptScreen extends ConsumerWidget {
  final String orderId;

  const DeliveryReceiptScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(ordersNotifierProvider.notifier).getOrderById(orderId);

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('خطأ')),
        body: const Center(child: Text('الطلب المطلوب غير موجود.')),
      );
    }

    final qualityState = ref.watch(qualityNotifierProvider.select(
      (notifierMap) => notifierMap[orderId] ?? ref.read(qualityNotifierProvider.notifier).getOrCreateState(orderId),
    ));

    final isAllChecked = qualityState.receiptChecklist.values.every((checked) => checked);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تأكيد الاستلام المبدئي'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReceiptHeaderWidget(order: order),
              AppSpacing.hMD,
              OrderSummaryWidget(order: order),
              AppSpacing.hMD,
              ShipmentInformationWidget(order: order),
              AppSpacing.hMD,
              const MediaPreviewWidget(),
              AppSpacing.hMD,
              InspectionChecklistWidget(
                checklist: qualityState.receiptChecklist,
                onItemToggled: (item) {
                  ref.read(qualityNotifierProvider.notifier).updateReceiptChecklist(
                        orderId,
                        item,
                        !(qualityState.receiptChecklist[item] ?? false),
                      );
                },
              ),
              AppSpacing.hMD,
              DeliveryStatusWidget(status: order.status),
              AppSpacing.hLG,
              ActionButtonsWidget(
                onConfirm: () {
                  ref.read(qualityNotifierProvider.notifier).confirmReceipt(orderId);
                  context.push('/orders/$orderId/quality-inspection');
                },
                onReportIssue: () {
                  context.push('/orders/$orderId/issue-report');
                },
                isAllChecked: isAllChecked,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

