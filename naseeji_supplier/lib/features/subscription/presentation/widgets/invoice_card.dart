import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/subscription_models.dart';

class InvoiceCard extends StatelessWidget {
  final SubscriptionInvoice invoice;
  final VoidCallback onDownload;
  final VoidCallback onShare;

  const InvoiceCard({
    super.key,
    required this.invoice,
    required this.onDownload,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = '${invoice.createdDate.year}/${invoice.createdDate.month.toString().padLeft(2, '0')}/${invoice.createdDate.day.toString().padLeft(2, '0')}';
    
    final bool isPaid = invoice.status == 'مدفوعة' || invoice.status == 'Paid';

    return Card(
      elevation: 0.5,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPaid ? const Color(0xFF006B5F).withValues(alpha: 0.1) : const Color(0xFFFF9800).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    invoice.status,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isPaid ? const Color(0xFF006B5F) : const Color(0xFFFF9800),
                    ),
                  ),
                ),
                Text(
                  invoice.invoiceNumber,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                ),
              ],
            ),
            SizedBox(height: 12),
            const Divider(color: AppColors.outlineVariant),
            SizedBox(height: 8),

            _buildDetailRow('الباقة / الخدمة المشحونة', invoice.planName),
            _buildDetailRow('تاريخ الفاتورة', dateStr),
            _buildDetailRow('الضريبة (15%)', '${invoice.vat.toStringAsFixed(2)} جنيه'),
            if (invoice.discount > 0)
              _buildDetailRow('الخصم المطبق', '-${invoice.discount.toStringAsFixed(0)} جنيه'),
            _buildDetailRow('المبلغ الإجمالي', '${invoice.amount.toStringAsFixed(0)} جنيه'),

            SizedBox(height: 8),
            const Divider(color: AppColors.outlineVariant),
            SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.share_outlined, color: AppColors.onSurfaceVariant, size: 20),
                  onPressed: onShare,
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.download_for_offline_outlined, color: Color(0xFF0040E0), size: 20),
                  onPressed: onDownload,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurface),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}