import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../widgets/issue_report/issue_report_form.dart';

class IssueReportScreen extends ConsumerWidget {
  final String orderId;

  const IssueReportScreen({super.key, required this.orderId});

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
        title: const Text('الإبلاغ عن مشكلة جودة'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: IssueReportForm(order: order),
      ),
    );
  }
}
