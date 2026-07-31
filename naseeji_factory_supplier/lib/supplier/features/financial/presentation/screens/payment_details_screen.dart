import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import '../../domain/entities/financial_models.dart';
import '../widgets/payment_status_badge.dart';
import '../widgets/escrow_progress_widget.dart';

class PaymentDetailsScreen extends StatelessWidget {
  final String paymentNumber;
  final SupplierPayment? payment;

  const PaymentDetailsScreen({
    super.key,
    required this.paymentNumber,
    this.payment,
  });

  @override
  Widget build(BuildContext context) {
    // Fallback if not passed
    final p = payment ??
        SupplierPayment(
          paymentNumber: paymentNumber,
          factoryName: 'مصنع نسيج الرياض',
          orderNumber: 'ORD-5541',
          amount: 14500.0,
          method: 'مدى',
          status: PaymentStatus.released,
          releaseDate: DateTime.now().subtract(const Duration(hours: 3)),
          receiptUrl: 'https://naseeji.com/receipts/pay-8921.pdf',
        );

    final releaseDateStr = '${p.releaseDate.year}-${p.releaseDate.month.toString().padLeft(2, '0')}-${p.releaseDate.day.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تفاصيل الدفعة المالية',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Voucher card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Color(0xFFDEEBFF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.payment, color: Color(0xFF0052CC), size: 22),
                    ),
                    SizedBox(height: 12),
                    Text(
                      p.paymentNumber,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.outline),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${p.amount.toStringAsFixed(2)} جنيه',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    SizedBox(height: 8),
                    PaymentStatusBadge(status: p.status),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Detail fields
              _buildTitle('بيانات التحويل والتسوية'),
              SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    _buildRow('الجهة المصدرة للدفعة', p.factoryName),
                    const Divider(height: 20),
                    _buildRow('رقم طلب الشراء المرتبط', p.orderNumber),
                    const Divider(height: 20),
                    _buildRow('طريقة تصفية الحساب', p.method),
                    const Divider(height: 20),
                    _buildRow('تاريخ الإفراج الفعلي', releaseDateStr),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Escrow tracker
              _buildTitle('مسار الإفراج الأمني والضمان (Escrow)'),
              SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    EscrowProgressWidget(
                      currentStage: p.status == PaymentStatus.released
                          ? EscrowStage.paymentReleased
                          : (p.status == PaymentStatus.pending
                              ? EscrowStage.moneyHeld
                              : EscrowStage.shipmentDelivered),
                    ),
                    if (p.status == PaymentStatus.pending) ...[
                      SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFAE6),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFB17000).withValues(alpha: 0.2)),
                        ),
                        child: Text(
                          'تنبيه: الأموال محتجزة بحساب الضمان الموحد للمنصة لحين إثبات استلام وتوقيع فحص المطابقة الفنية من المصنع.',
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 10, color: Color(0xFFB17000), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Actions
              if (p.receiptUrl != null)
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('جاري تحميل إيصال الدفعة بصيغة PDF...')),
                    );
                  },
                  icon: const Icon(Icons.download, size: 20),
                  label: Text('تحميل إيصال الدفعة الرسمي'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.right,
      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 13, color: AppColors.outline),
        ),
      ],
    );
  }
}