import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class QuotationCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onAccept;
  final VoidCallback? onCounterOffer;
  final VoidCallback? onViewDetails;

  const QuotationCard({
    super.key,
    required this.data,
    this.onAccept,
    this.onCounterOffer,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final status = data['status'] as String? ?? 'pending';
    final isAccepted = status == 'accepted';
    final statusLabel = isAccepted ? 'مقبول ✓' : 'قيد المراجعة';

    return Container(
      width: 290,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isAccepted 
              ? AppColors.secondary.withValues(alpha: 0.3) 
              : AppColors.primary.withValues(alpha: 0.3), 
          width: 1.5
        ),
        boxShadow: [
          BoxShadow(
            color: (isAccepted ? AppColors.secondary : AppColors.primary).withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isAccepted
                    ? [AppColors.secondary, AppColors.secondary.withValues(alpha: 0.8)]
                    : [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16.5)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                Icon(Icons.request_quote_outlined, color: AppColors.surface, size: 18),
                SizedBox(width: 6),
                Text(
                  'عرض سعر ${data['version'] ?? ''}',
                  style: TextStyle(color: Theme.of(context).colorScheme.surface, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                _Row(label: 'اسم المنتج', value: data['productName'] ?? 'خيوط غزل القطن الفاخر'),
                _Row(label: 'سعر الوحدة', value: '${data['unitPrice'] ?? '--'} ر.س'),
                _Row(label: 'الكمية', value: '${data['quantity'] ?? '--'}'),
                _Row(label: 'السعر الإجمالي', value: data['totalPrice'] != null ? '${data['totalPrice']}' : '${(double.tryParse(data['unitPrice']?.toString() ?? '0') ?? 0.0) * (double.tryParse(data['quantity']?.toString().replaceAll(RegExp(r'[^0-9.]'), '') ?? '0') ?? 0.0)} ر.س'),
                _Row(label: 'مدة التسليم', value: '${data['deliveryDays'] ?? '--'}'),
                _Row(label: 'شروط الدفع', value: '${data['paymentTerms'] ?? '--'}'),
                _Row(label: 'صالح حتى', value: '${data['validUntil'] ?? '--'}'),
              ],
            ),
          ),
          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: SizedBox(
              width: double.infinity,
              height: 36,
              child: OutlinedButton.icon(
                onPressed: onViewDetails,
                icon: Icon(Icons.info_outline, size: 14, color: AppColors.onSurfaceVariant),
                label: Text('عرض التفاصيل', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.outlineVariant),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),

          // Accept & Counter Offer buttons (only if status is pending)
          if (status == 'pending')
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      child: OutlinedButton(
                        onPressed: onCounterOffer,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text('عرض مضاد', style: TextStyle(fontSize: 12, color: AppColors.primary)),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed: onAccept,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text('قبول', style: TextStyle(fontSize: 12, color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              value, 
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: 11, color: AppColors.outline)),
        ],
      ),
    );
  }
}