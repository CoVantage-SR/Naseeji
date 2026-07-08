import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/financial_models.dart';
import 'payment_status_badge.dart';

class TransactionCard extends StatelessWidget {
  final FinancialTransaction transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isNegative = transaction.amount < 0;
    final amountText = '${isNegative ? "" : "+"}${transaction.amount.toStringAsFixed(2)} ${transaction.currency}';
    final amountColor = isNegative ? const Color(0xFFBA1A1A) : const Color(0xFF00875A);

    // Date formatting helper
    final dateStr = '${transaction.createdDate.year}-${transaction.createdDate.month.toString().padLeft(2, '0')}-${transaction.createdDate.day.toString().padLeft(2, '0')}';

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          context.push('/finance/transactions/${transaction.id}', extra: transaction);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Navigation / Detail chevron
              const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: AppColors.outline,
              ),
              const Spacer(),
              // Amount and Status
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    amountText,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: amountColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  PaymentStatusBadge(status: transaction.status),
                ],
              ),
              const SizedBox(width: 16),
              // Transaction info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _typeLabel(transaction.type),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transaction.factoryName.isNotEmpty
                          ? transaction.factoryName
                          : 'رقم الطلب: ${transaction.orderNumber}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.outline,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dateStr,
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Type Icon indicator
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isNegative
                      ? const Color(0xFFFFEBE6)
                      : const Color(0xFFE3FCEF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isNegative ? Icons.arrow_downward : Icons.arrow_upward,
                  color: isNegative ? const Color(0xFFDE350B) : const Color(0xFF00875A),
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _typeLabel(TransactionType type) {
    switch (type) {
      case TransactionType.paymentReceived:
        return 'دفعة مستلمة';
      case TransactionType.paymentPending:
        return 'دفعة معلقة بالضمان';
      case TransactionType.withdrawal:
        return 'عملية سحب';
      case TransactionType.refund:
        return 'مبلغ مسترد لعميل';
      case TransactionType.platformCommission:
        return 'عمولة منصة نسيجي';
      case TransactionType.advertisingFee:
        return 'رسوم إعلانية';
      case TransactionType.subscriptionFee:
        return 'اشتراك باقة';
      case TransactionType.manualAdjustment:
        return 'تعديل يدوي للحساب';
      case TransactionType.tax:
        return 'ضريبة القيمة المضافة';
      case TransactionType.shippingFee:
        return 'رسوم شحن توريد';
    }
  }
}
