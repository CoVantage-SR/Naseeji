import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class QuotationCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const QuotationCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final status = data['status'] as String? ?? 'pending';
    final isAccepted = status == 'accepted';
    final statusLabel = isAccepted ? 'مقبول ✓' : 'قيد المراجعة';

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isAccepted ? AppColors.secondary.withValues(alpha: 0.3) : AppColors.primary.withValues(alpha: 0.3), width: 1.5),
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
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.request_quote_outlined, color: Colors.white, size: 18),
                const SizedBox(width: 6),
                Text(
                  'عرض سعر ${data['version'] ?? ''}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                _Row(label: 'سعر الوحدة', value: '${data['unitPrice'] ?? '--'} ر.س'),
                _Row(label: 'الكمية', value: '${data['quantity'] ?? '--'}'),
                _Row(label: 'مدة التسليم', value: '${data['deliveryDays'] ?? '--'}'),
                _Row(label: 'شروط الدفع', value: '${data['paymentTerms'] ?? '--'}'),
                _Row(label: 'صالح حتى', value: '${data['validUntil'] ?? '--'}'),
              ],
            ),
          ),
          // Buttons (only show for pending)
          if (status == 'pending')
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('عرض مضاد', style: TextStyle(fontSize: 12, color: AppColors.primary)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('قبول', style: TextStyle(fontSize: 12, color: Colors.white)),
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
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.outline)),
        ],
      ),
    );
  }
}
