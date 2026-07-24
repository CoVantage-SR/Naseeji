import 'package:flutter/material.dart';
import 'package:naseeji_supplier/features/messages/domain/entities/deal_quotation_model.dart';
import 'offer_status_badge_widget.dart';

class NegotiationCardWidget extends StatelessWidget {
  final DealQuotationModel quotation;
  final bool isLatest;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onRequestModification;
  final VoidCallback? onCopyOffer;

  const NegotiationCardWidget({
    super.key,
    required this.quotation,
    this.isLatest = true,
    this.onAccept,
    this.onReject,
    this.onRequestModification,
    this.onCopyOffer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final formattedTotal = '${quotation.totalPrice.toStringAsFixed(0)} ${quotation.currency}';
    final formattedUnit = '${quotation.unitPrice.toStringAsFixed(1)} ${quotation.currency}/كجم';
    final formattedDate = '${quotation.createdAt.day}/${quotation.createdAt.month}/${quotation.createdAt.year}';

    return Card(
      elevation: isLatest ? 1.5 : 0.5,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isLatest
              ? colorScheme.primary.withValues(alpha: 0.4)
              : colorScheme.outlineVariant.withValues(alpha: 0.3),
          width: isLatest ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Version Badge + Status + Date
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: quotation.createdByRole == 'المصنع' ? Colors.purple.shade700 : colorScheme.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    quotation.createdByRole == 'المصنع'
                        ? 'طلب تعديل المصنع V${quotation.versionNumber}'
                        : 'عرض المورد V${quotation.versionNumber}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OfferStatusBadgeWidget(status: quotation.offerStatus),
                const Spacer(),
                Text(
                  formattedDate,
                  style: TextStyle(fontSize: 10, color: colorScheme.outline),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Notice Banner for Counter Offer
            if (quotation.createdByRole == 'المصنع' || quotation.offerStatus == OfferStatus.counterOffer) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.purple.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.edit_note_rounded, color: Colors.purple, size: 18),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'قام المصنع بطلب تعديل العرض وشروطه كما هو موضح أدناه:',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Price & Quantity Hero Box
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: quotation.createdByRole == 'المصنع'
                    ? Colors.purple.shade50.withValues(alpha: 0.5)
                    : colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: quotation.createdByRole == 'المصنع'
                      ? Colors.purple.shade200
                      : colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'إجمالي قيمة العرض',
                          style: TextStyle(fontSize: 10, color: colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          formattedTotal,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: quotation.createdByRole == 'المصنع' ? Colors.purple.shade800 : colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 28,
                    width: 1,
                    color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'سعر الوحدة والكمية',
                          style: TextStyle(fontSize: 10, color: colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$formattedUnit • ${quotation.quantity} كجم',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Key Specification Rows
            _buildDetailRow(context, icon: Icons.timer_outlined, label: 'مدة الإنتاج والتصنيع', value: quotation.productionLeadTime),
            _buildDetailRow(context, icon: Icons.event_available_outlined, label: 'مدة صلاحية العرض', value: quotation.validityPeriod),
            _buildDetailRow(context, icon: Icons.payment_outlined, label: 'شروط وطريقة الدفع', value: quotation.paymentTerms),
            _buildDetailRow(context, icon: Icons.local_shipping_outlined, label: 'طريقة التسليم', value: quotation.deliveryTerms),
            if (quotation.expectedDeliveryDate != null)
              _buildDetailRow(
                context,
                icon: Icons.calendar_today_outlined,
                label: 'التسليم المتوقع',
                value: '${quotation.expectedDeliveryDate!.day}/${quotation.expectedDeliveryDate!.month}/${quotation.expectedDeliveryDate!.year}',
              ),

            if (quotation.notes.isNotEmpty) ...[
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: quotation.createdByRole == 'المصنع'
                      ? Colors.purple.shade50
                      : colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'ملاحظات المصنع للتعديل: ${quotation.notes}',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontStyle: FontStyle.italic,
                    color: quotation.createdByRole == 'المصنع' ? Colors.purple.shade900 : colorScheme.onSurfaceVariant,
                    fontWeight: quotation.createdByRole == 'المصنع' ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ),
            ],

            // Action Buttons for Latest Version
            if (isLatest) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  if (onAccept != null && quotation.offerStatus != OfferStatus.accepted)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onAccept,
                        icon: const Icon(Icons.check_circle_outline, size: 15),
                        label: const Text('قبول العرض', style: TextStyle(fontSize: 11)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 36),
                        ),
                      ),
                    ),
                  if (onAccept != null && quotation.offerStatus != OfferStatus.accepted) const SizedBox(width: 6),

                  if (onRequestModification != null)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onRequestModification,
                        icon: const Icon(Icons.edit_note_rounded, size: 15),
                        label: const Text('طلب تعديل / إصدار جديد', style: TextStyle(fontSize: 10.5)),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 36),
                        ),
                      ),
                    ),
                  if (onRequestModification != null) const SizedBox(width: 6),

                  if (onReject != null && quotation.offerStatus != OfferStatus.accepted)
                    IconButton(
                      onPressed: onReject,
                      icon: const Icon(Icons.cancel_outlined, color: Colors.red, size: 20),
                      tooltip: 'رفض العرض',
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, {required IconData icon, required String label, required String value}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 13, color: colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: TextStyle(fontSize: 10.5, color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 10.5, color: colorScheme.onSurface, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
