import 'package:flutter/material.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import '../../domain/entities/financial_models.dart';
import 'payment_status_badge.dart';

class WithdrawalCard extends StatelessWidget {
  final WithdrawalRequest request;
  final Function(String)? onCancel;

  const WithdrawalCard({
    super.key,
    required this.request,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = '${request.createdDate.year}-${request.createdDate.month.toString().padLeft(2, '0')}-${request.createdDate.day.toString().padLeft(2, '0')}';
    final amountStr = '${request.amount.toStringAsFixed(2)} جنيه';

    return Card(
      color: Theme.of(context).colorScheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
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
                PaymentStatusBadge(status: request.status),
                Text(
                  request.id,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.outline,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  amountStr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  request.method,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'المستفيد: ${request.accountHolder}',
                    style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'البنك: ${request.bankName}',
                    style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'الآيبان: ${request.iban}',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            if (request.notes != null && request.notes!.isNotEmpty) ...[
              SizedBox(height: 10),
              Text(
                'ملاحظات: ${request.notes}',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 11, color: AppColors.outline, fontStyle: FontStyle.italic),
              ),
            ],
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (request.status == WithdrawalStatus.pending && onCancel != null)
                  TextButton.icon(
                    onPressed: () => onCancel!(request.id),
                    icon: const Icon(Icons.cancel_outlined, size: 16, color: Color(0xFFBA1A1A)),
                    label: Text(
                      'إلغاء الطلب',
                      style: TextStyle(color: Color(0xFFBA1A1A), fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                  )
                else
                  const SizedBox.shrink(),
                Text(
                  'تاريخ الطلب: $dateStr',
                  style: TextStyle(fontSize: 10, color: AppColors.outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
