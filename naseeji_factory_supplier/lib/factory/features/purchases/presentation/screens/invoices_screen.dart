import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../providers/purchases_provider.dart';
import '../widgets/invoices_widgets.dart';
import '../widgets/purchase_history_widgets.dart';

class InvoicesScreen extends ConsumerStatefulWidget {
  const InvoicesScreen({super.key});

  @override
  ConsumerState<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends ConsumerState<InvoicesScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(ordersNotifierProvider);
    final notifier = ref.read(purchasesNotifierProvider.notifier);
    final purchases = notifier.getPurchases(orders);
    var invoices = notifier.getInvoices(purchases);

    if (_searchQuery.isNotEmpty) {
      invoices = invoices.where((inv) {
        final q = _searchQuery.toLowerCase();
        return inv.invoiceNumber.toLowerCase().contains(q) ||
            inv.supplierName.toLowerCase().contains(q) ||
            inv.orderId.toLowerCase().contains(q);
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('الفواتير'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InvoicesHeaderWidget(count: invoices.length),
              AppSpacing.hMD,
              SearchWidget(
                onChanged: (val) => setState(() => _searchQuery = val),
                hint: 'بحث في الفواتير...',
              ),
              AppSpacing.hMD,
              InvoicesListWidget(invoices: invoices),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

