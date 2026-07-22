import 'package:flutter/material.dart';
import 'package:naseeji_supplier/features/messages/domain/entities/deal_quotation_model.dart';

class QuotationTabWidget extends StatelessWidget {
  final DealQuotationModel quotation;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onCounterOffer;

  const QuotationTabWidget({
    super.key,
    required this.quotation,
    required this.onAccept,
    required this.onReject,
    required this.onCounterOffer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'أحدث عرض سعر (Quotation)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'رقم العرض: ${quotation.quotationId}',
                    style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  quotation.status,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: colorScheme.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Total Price Card
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.85)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('إجمالي قيمة الصفقة المعروضة', style: TextStyle(fontSize: 12, color: Colors.white70)),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      quotation.totalPrice.toStringAsFixed(0),
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(width: 6),
                    Text(quotation.currency, style: const TextStyle(fontSize: 14, color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'سعر الوحدة: ${quotation.unitPrice} ${quotation.currency} • الكمية: ${quotation.quantity} وحدة',
                  style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.9)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Key Terms & Conditions List
          _buildDetailTile(context, title: 'أقل كمية للطلب (MOQ)', value: '${quotation.moq} وحدة', icon: Icons.shopping_bag_outlined),
          const SizedBox(height: 8),
          _buildDetailTile(context, title: 'مدة الإنتاج والتجهيز', value: quotation.productionLeadTime, icon: Icons.timer_outlined),
          const SizedBox(height: 8),
          _buildDetailTile(context, title: 'مدة صلاحية العرض', value: quotation.validityPeriod, icon: Icons.event_available_outlined),
          const SizedBox(height: 8),
          _buildDetailTile(context, title: 'شروط ودفعات التسديد', value: quotation.paymentTerms, icon: Icons.account_balance_wallet_outlined),
          const SizedBox(height: 20),

          // Action Buttons: Accept, Reject, Counter Offer
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onAccept,
                  icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                  label: const Text('قبول العرض'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 44),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onCounterOffer,
                  icon: const Icon(Icons.handshake_outlined, size: 18),
                  label: const Text('عرض مضاد'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 44),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: onReject,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  minimumSize: const Size(0, 44),
                ),
                child: const Text('رفض'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTile(BuildContext context, {required String title, required String value, required IconData icon}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 11, color: colorScheme.outline)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
