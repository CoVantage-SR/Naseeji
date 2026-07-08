import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/financial_controllers.dart';
import '../../domain/entities/financial_models.dart';
import '../widgets/invoice_card.dart';

class InvoicesScreen extends ConsumerWidget {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoicesAsync = ref.watch(financialInvoicesControllerProvider);

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'نظام الفواتير الماليّة',
            style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
            onPressed: () => context.pop(),
          ),
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.outline,
            tabs: [
              Tab(text: 'الكل'),
              Tab(text: 'المدفوعة'),
              Tab(text: 'قيد الاستحقاق'),
              Tab(text: 'المتأخرة'),
              Tab(text: 'الملغاة'),
            ],
          ),
        ),
        body: Container(
          color: const Color(0xFFF8F9FF),
          child: invoicesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
            error: (err, stack) => Center(child: Text('خطأ: $err')),
            data: (invoices) {
              return TabBarView(
                children: [
                  _buildInvoiceList(context, invoices),
                  _buildInvoiceList(context, invoices.where((i) => i.status == InvoiceStatus.paid).toList()),
                  _buildInvoiceList(context, invoices.where((i) => i.status == InvoiceStatus.pending).toList()),
                  _buildInvoiceList(context, invoices.where((i) => i.status == InvoiceStatus.overdue).toList()),
                  _buildInvoiceList(context, invoices.where((i) => i.status == InvoiceStatus.cancelled).toList()),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceList(BuildContext context, List<SupplierInvoice> list) {
    if (list.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد فواتير مطابقة في هذا القسم',
          style: TextStyle(color: AppColors.outline),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final invoice = list[index];

        return InvoiceCard(
          invoice: invoice,
          onDownload: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('تحميل الفاتورة ${invoice.invoiceNumber} بصيغة PDF...')),
            );
          },
          onShare: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('مشاركة الفاتورة ${invoice.invoiceNumber}...')),
            );
          },
        );
      },
    );
  }
}
