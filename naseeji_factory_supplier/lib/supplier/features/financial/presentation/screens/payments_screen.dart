import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import '../controllers/financial_controllers.dart';
import '../../domain/entities/financial_models.dart';
import '../widgets/payment_status_badge.dart';

class PaymentsScreen extends ConsumerWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentsAsync = ref.watch(financialPaymentsControllerProvider);

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'الدفعات والتسويات الماليّة',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
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
              Tab(text: 'معلقة بالضمان'),
              Tab(text: 'جاري المعالجة'),
              Tab(text: 'مفرج عنها'),
              Tab(text: 'فاشلة'),
              Tab(text: 'مستردة'),
            ],
          ),
        ),
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: paymentsAsync.when(
            loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
            error: (err, stack) => Center(child: Text('خطأ: $err')),
            data: (payments) {
              return TabBarView(
                children: [
                  _buildPaymentList(context, payments),
                  _buildPaymentList(context, payments.where((p) => p.status == PaymentStatus.pending).toList()),
                  _buildPaymentList(context, payments.where((p) => p.status == PaymentStatus.processing).toList()),
                  _buildPaymentList(context, payments.where((p) => p.status == PaymentStatus.released).toList()),
                  _buildPaymentList(context, payments.where((p) => p.status == PaymentStatus.failed).toList()),
                  _buildPaymentList(context, payments.where((p) => p.status == PaymentStatus.refunded).toList()),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentList(BuildContext context, List<SupplierPayment> list) {
    if (list.isEmpty) {
      return Center(
        child: Text(
          'لا توجد دفعات حالية في هذا القسم',
          style: TextStyle(color: AppColors.outline),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final payment = list[index];
        final releaseDateStr = '${payment.releaseDate.year}-${payment.releaseDate.month.toString().padLeft(2, '0')}-${payment.releaseDate.day.toString().padLeft(2, '0')}';

        return Card(
          color: Theme.of(context).colorScheme.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
          ),
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PaymentStatusBadge(status: payment.status),
                    Text(
                      payment.paymentNumber,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.outline),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${payment.amount.toStringAsFixed(2)} جنيه',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    Text(
                      payment.factoryName,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'تاريخ الاستحقاق/الإفراج: $releaseDateStr',
                      style: TextStyle(fontSize: 11, color: AppColors.outline),
                    ),
                    Text(
                      'رقم طلب الشراء: ${payment.orderNumber}',
                      style: TextStyle(fontSize: 11, color: AppColors.outline),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                const Divider(height: 1, color: AppColors.outlineVariant),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          context.push('/finance/payments/${payment.paymentNumber}', extra: payment);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: Text(
                          'عرض تفاصيل الدفعة',
                          style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    if (payment.receiptUrl != null) ...[
                      SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('تحميل إيصال الدفعة ${payment.paymentNumber}...')),
                          );
                        },
                        icon: const Icon(Icons.download_done, color: Color(0xFF00875A), size: 18),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFE3FCEF),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
