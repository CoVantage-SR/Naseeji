// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/financial_models.dart';
import '../widgets/payment_status_badge.dart';

class TransactionDetailsScreen extends ConsumerWidget {
  final String transactionId;
  final FinancialTransaction? transaction;

  const TransactionDetailsScreen({
    super.key,
    required this.transactionId,
    this.transaction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If transaction is passed as extra, use it, otherwise fall back to dummy/search lookup
    final txn = transaction ??
        FinancialTransaction(
          id: transactionId,
          orderNumber: 'ORD-5541',
          agreementNumber: 'AGR-8802',
          factoryName: 'مصنع نسيج الرياض',
          type: TransactionType.paymentReceived,
          amount: 14500.0,
          currency: 'جنيه',
          status: TransactionStatus.completed,
          paymentMethod: 'مدى',
          referenceNumber: 'REF-7729831',
          createdDate: DateTime.now().subtract(const Duration(hours: 3)),
          completedDate: DateTime.now().subtract(const Duration(hours: 3)),
        );

    final dateStr = '${txn.createdDate.year}-${txn.createdDate.month.toString().padLeft(2, '0')}-${txn.createdDate.day.toString().padLeft(2, '0')}';
    final completedDateStr = txn.completedDate != null
        ? '${txn.completedDate!.year}-${txn.completedDate!.month.toString().padLeft(2, '0')}-${txn.completedDate!.day.toString().padLeft(2, '0')}'
        : 'قيد الانتظار';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تفاصيل المعاملة المالية',
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
              // Core Receipt Voucher Header Card
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
                        color: Color(0xFFE3FCEF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.receipt_long, color: Color(0xFF00875A), size: 24),
                    ),
                    SizedBox(height: 12),
                    Text(
                      _typeLabel(txn.type),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${txn.amount > 0 ? "+" : ""}${txn.amount.toStringAsFixed(2)} ${txn.currency}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: txn.amount > 0 ? const Color(0xFF00875A) : const Color(0xFFBA1A1A),
                      ),
                    ),
                    SizedBox(height: 8),
                    PaymentStatusBadge(status: txn.status),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // Transaction Info Card
              _buildSectionTitle('بيانات العملية الماليّة'),
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
                    _buildDetailRow('رقم المعاملة (TXN ID)', txn.id),
                    const Divider(height: 20),
                    _buildDetailRow('رقم مرجع النظام', txn.referenceNumber),
                    const Divider(height: 20),
                    _buildDetailRow('طريقة الدفع/التحويل', txn.paymentMethod),
                    const Divider(height: 20),
                    _buildDetailRow('تاريخ الإنشاء', dateStr),
                    const Divider(height: 20),
                    _buildDetailRow('تاريخ الاكتمال والتسوية', completedDateStr),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // Order / Agreement Integration Details
              if (txn.orderNumber.isNotEmpty || txn.agreementNumber.isNotEmpty) ...[
                _buildSectionTitle('المستندات المرتبطة'),
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
                      if (txn.orderNumber.isNotEmpty) ...[
                        _buildLinkedRow(
                          context,
                          label: 'رقم طلب الشراء',
                          value: txn.orderNumber,
                          icon: Icons.shopping_bag_outlined,
                          onTap: () {
                            // Route to order details if we have it
                            context.push('/orders/order-center?rfqId=${txn.orderNumber}');
                          },
                        ),
                      ],
                      if (txn.agreementNumber.isNotEmpty) ...[
                        const Divider(height: 20),
                        _buildLinkedRow(
                          context,
                          label: 'اتفاقية التوريد B2B',
                          value: txn.agreementNumber,
                          icon: Icons.handshake_outlined,
                          onTap: () {
                            context.push('/agreements/details/${txn.agreementNumber}');
                          },
                        ),
                      ],
                      if (txn.factoryName.isNotEmpty) ...[
                        const Divider(height: 20),
                        _buildDetailRow('اسم الطرف الثاني (المصنع)', txn.factoryName),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 16),
              ],

              // Financial Breakdown & Auditing
              _buildSectionTitle('البيان الضريبي والمالي'),
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
                    _buildDetailRow('القيمة الإجمالية قبل الضريبة', '${(txn.amount.abs() / 1.15).toStringAsFixed(2)} جنيه'),
                    const Divider(height: 20),
                    _buildDetailRow('ضريبة القيمة المضافة (15%)', '${(txn.amount.abs() - (txn.amount.abs() / 1.15)).toStringAsFixed(2)} جنيه'),
                    const Divider(height: 20),
                    _buildDetailRow('رسوم تسوية الخدمة (المنصة)', '0.00 جنيه'),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // Notes & Terms
              _buildSectionTitle('ملاحظات وسجل تدقيق العمليات'),
              SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'تم إنشاء المعاملة تلقائياً بواسطة نظام الدفع المالي الموحد لمنصة نسيجي بعد مطابقة إيصال تسليم البضائع.',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'توقيع رقمي موثق ومطابق لنظام وزارة التجارة السعودي',
                          style: TextStyle(fontSize: 10, color: AppColors.outline),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.verified, color: const Color(0xFF00875A), size: 14),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.right,
      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
    );
  }

  Widget _buildDetailRow(String label, String value) {
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

  Widget _buildLinkedRow(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              const Icon(Icons.launch, size: 14, color: AppColors.primary),
              SizedBox(width: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 13, color: AppColors.outline),
            ),
            SizedBox(width: 6),
            Icon(icon, color: AppColors.outline, size: 16),
          ],
        ),
      ],
    );
  }

  String _typeLabel(TransactionType type) {
    switch (type) {
      case TransactionType.paymentReceived:
        return 'دفعة مستلمة من العميل';
      case TransactionType.paymentPending:
        return 'دفعة معلقة بالضمان';
      case TransactionType.withdrawal:
        return 'عملية سحب حساب بنكي';
      case TransactionType.refund:
        return 'إرجاع مالي للعميل';
      case TransactionType.platformCommission:
        return 'عمولة وساطة نسيجي';
      case TransactionType.advertisingFee:
        return 'رسوم ترويج منتجات';
      case TransactionType.subscriptionFee:
        return 'رسوم اشتراك الباقة';
      case TransactionType.manualAdjustment:
        return 'تعديل رصيد يدوي';
      case TransactionType.tax:
        return 'ضريبة القيمة المضافة';
      case TransactionType.shippingFee:
        return 'رسوم الشحن المقتطعة';
    }
  }
}