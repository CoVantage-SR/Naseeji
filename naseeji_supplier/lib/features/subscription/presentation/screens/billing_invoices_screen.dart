import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/subscription_controllers.dart';
import '../widgets/invoice_card.dart';

class BillingInvoicesScreen extends ConsumerWidget {
  const BillingInvoicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoicesAsync = ref.watch(billingInvoicesControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Text(
            'سجل الفواتير الضريبية B2B',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.onSurface),
          ),
          centerTitle: true,
        ),
        body: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: invoicesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('خطأ: $e')),
            data: (invoices) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: invoices.length,
                itemBuilder: (context, index) {
                  final inv = invoices[index];
                  return InvoiceCard(
                    invoice: inv,
                    onDownload: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('تم تنزيل الفاتورة ${inv.invoiceNumber} كملف PDF بنجاح!')),
                      );
                    },
                    onShare: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('تمت مشاركة رابط الفاتورة ${inv.invoiceNumber} بنجاح!')),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
