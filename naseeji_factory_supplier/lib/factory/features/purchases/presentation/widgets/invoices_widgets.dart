import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/purchases_provider.dart';
import 'purchases_reusable_widgets.dart';

// ─── Invoices Header Widget ────────────────────────────────────────────────
class InvoicesHeaderWidget extends StatelessWidget {
  final int count;
  const InvoicesHeaderWidget({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الفواتير والمستندات المالية',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              '$count فاتورة في السجل',
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        const Icon(Icons.receipt_long_rounded, color: AppColors.primary, size: 28),
      ],
    );
  }
}

// ─── Invoices List Widget ──────────────────────────────────────────────────
class InvoicesListWidget extends StatelessWidget {
  final List<InvoiceModel> invoices;
  const InvoicesListWidget({super.key, required this.invoices});

  @override
  Widget build(BuildContext context) {
    if (invoices.isEmpty) {
      return const EmptyStateWidget(
        title: 'لا توجد فواتير',
        description: 'سيتم إنشاء الفواتير تلقائياً عند اكتمال الطلبات.',
        icon: Icons.receipt_long_rounded,
      );
    }
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: invoices.length,
      itemBuilder: (context, index) {
        final inv = invoices[index];
        return InvoiceCard(
          invoice: inv,
          onView: () {},
          onDownload: () {},
          onShare: () {},
        );
      },
    );
  }
}



