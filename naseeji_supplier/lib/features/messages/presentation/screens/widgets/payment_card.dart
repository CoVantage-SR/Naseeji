import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class PaymentCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const PaymentCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final status = data['status'] as String? ?? 'pending';
    final isReleased = status == 'released';
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade600, width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.amber.shade700,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              children: [
                if (isReleased)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('تم الإصدار ✓', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                const Spacer(),
                const Icon(Icons.payments_outlined, color: Colors.white, size: 18),
                const SizedBox(width: 6),
                const Text('تفاصيل الدفع', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${data['amount'] ?? '--'} ر.س',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber.shade800),
                    ),
                    const Text('المبلغ الإجمالي', style: TextStyle(fontSize: 11, color: AppColors.outline)),
                  ],
                ),
                const SizedBox(height: 8),
                _Row(label: 'حالة الدفع', value: '${data['status'] ?? '--'}'),
                _Row(label: 'تاريخ الإصدار', value: '${data['releaseDate'] ?? '--'}'),
                _Row(label: 'رقم المعاملة', value: '${data['transactionRef'] ?? '--'}'),
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
