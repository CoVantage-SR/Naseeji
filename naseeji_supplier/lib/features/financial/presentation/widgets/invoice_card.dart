import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/financial_models.dart';
import 'payment_status_badge.dart';

class InvoiceCard extends StatelessWidget {
  final SupplierInvoice invoice;
  final VoidCallback? onDownload;
  final VoidCallback? onShare;

  const InvoiceCard({
    super.key,
    required this.invoice,
    this.onDownload,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final issueDateStr = '${invoice.invoiceDate.year}-${invoice.invoiceDate.month.toString().padLeft(2, '0')}-${invoice.invoiceDate.day.toString().padLeft(2, '0')}';
    final dueDateStr = '${invoice.dueDate.year}-${invoice.dueDate.month.toString().padLeft(2, '0')}-${invoice.dueDate.day.toString().padLeft(2, '0')}';
    final totalStr = '${invoice.grandTotal.toStringAsFixed(2)} ر.س';

    return Card(
      color: Colors.white,
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
                PaymentStatusBadge(status: invoice.status),
                Text(
                  invoice.invoiceNumber,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  totalStr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  invoice.factoryName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'تاريخ الاستحقاق: $dueDateStr',
                  style: const TextStyle(fontSize: 11, color: AppColors.outline),
                ),
                Text(
                  'تاريخ الفاتورة: $issueDateStr',
                  style: const TextStyle(fontSize: 11, color: AppColors.outline),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.outlineVariant),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.push('/finance/invoices/${invoice.invoiceNumber}', extra: invoice);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text(
                      'التفاصيل والبنود',
                      style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                if (onDownload != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: onDownload,
                    icon: const Icon(Icons.download, size: 20, color: AppColors.outline),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFF8F9FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
                if (onShare != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: onShare,
                    icon: const Icon(Icons.share, size: 20, color: AppColors.outline),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFF8F9FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
