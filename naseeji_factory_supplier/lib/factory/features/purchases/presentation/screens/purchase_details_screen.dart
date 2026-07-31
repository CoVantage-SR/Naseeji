import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../providers/purchases_provider.dart';
import '../widgets/purchase_details_widgets.dart';
import '../widgets/purchases_reusable_widgets.dart';

class PurchaseDetailsScreen extends ConsumerWidget {
  final String orderId;
  const PurchaseDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersNotifierProvider);
    final notifier = ref.read(purchasesNotifierProvider.notifier);
    final purchases = notifier.getPurchases(orders);

    final OrderModel? order = () {
      try {
        return orders.firstWhere((o) => o.id == orderId);
      } catch (_) {
        return null;
      }
    }();

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('تفاصيل الشراء')),
        body: const Center(child: Text('لم يتم العثور على الطلب.')),
      );
    }

    final purchase = () {
      try {
        return purchases.firstWhere((p) => p.order.id == orderId);
      } catch (_) {
        return notifier.getPurchases([order]).first;
      }
    }();

    final subtotal = order.finalPrice * 0.82;
    final discount = order.finalPrice * 0.05;
    final shipping = order.finalPrice * 0.08;
    final taxes = order.finalPrice * 0.15;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الشراء'),
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
              PurchaseHeaderWidget(purchase: purchase),
              AppSpacing.hMD,
              SupplierInformationWidget(purchase: purchase),
              AppSpacing.hMD,
              PurchasedProductsWidget(order: order),
              AppSpacing.hMD,
              FinancialCard(
                subtotal: subtotal,
                discount: discount,
                shipping: shipping,
                taxes: taxes,
                total: order.finalPrice,
              ),
              AppSpacing.hMD,
              ShipmentInformationWidget(order: order),
              AppSpacing.hMD,
              const DocumentsWidget(),
              AppSpacing.hMD,
              QuickActionsWidget(
                orderId: orderId,
                onReorder: () => context.push('/purchases/$orderId/reorder'),
                onRateSupplier: () => context.push('/reviews/rate/$orderId'),
                onDownloadInvoice: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('جاري تحميل الفاتورة...')),
                  );
                },
                onOpenChat: () => context.push('/chat'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

