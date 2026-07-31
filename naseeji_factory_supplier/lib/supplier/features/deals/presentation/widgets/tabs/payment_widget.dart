import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_factory/supplier/features/deals/domain/entities/deal_model.dart';
import 'package:naseeji_factory/supplier/features/deals/presentation/controllers/deals_controller.dart';

class PaymentWidget extends ConsumerWidget {
  final DealModel deal;

  const PaymentWidget({super.key, required this.deal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final pay = deal.payment;

    final isCompleted = deal.status == DealStatus.completed;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCompleted ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isCompleted ? Colors.green : Colors.amber),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isCompleted ? Icons.account_balance_rounded : Icons.account_balance_wallet_outlined,
                      color: isCompleted ? Colors.green.shade800 : Colors.amber.shade900,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'حالة مستحقات الصفقة والمحفظة',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isCompleted ? Colors.green.shade900 : Colors.amber.shade900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'المبلغ الإجمالي: ${pay?.totalAmount ?? deal.product.totalPrice} ${pay?.currency ?? 'ج.م'}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'حالة التحويل: ${pay?.paymentStatus ?? 'مجمدة بالحساب الضامن نسيجي Escrow'}',
                  style: TextStyle(fontSize: 10.5, color: isCompleted ? Colors.green.shade900 : Colors.amber.shade900, fontWeight: FontWeight.bold),
                ),
                if (pay?.transferDate != null)
                  Text(
                    'تاريخ التحويل للحساب: ${pay!.transferDate!.day}/${pay.transferDate!.month}/${pay.transferDate!.year}',
                    style: TextStyle(fontSize: 9.5, color: colorScheme.outline),
                  ),
                const SizedBox(height: 12),

                if (!isCompleted)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _releasePayment(context, ref),
                      icon: const Icon(Icons.download_done_rounded, size: 16),
                      label: const Text('الإفراج عن الدفعة وتحويلها للمحفظة'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, foregroundColor: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Guarantee badge
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                Icon(Icons.shield_outlined, color: colorScheme.primary, size: 24),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ضمان المعاملة نسيجي B2B Escrow', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      SizedBox(height: 2),
                      Text('جميع المستحقات محمية ومضمونة حتى تمام قبول الفحص المعملي واستلام الشحنة.', style: TextStyle(fontSize: 9.5, height: 1.3)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _releasePayment(BuildContext context, WidgetRef ref) async {
    final success = await ref.read(dealsControllerProvider.notifier).releasePayment(deal.id);
    if (context.mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إكمال الصفقة وتحويل المستحقات كاملة لحسابك! 🥳💰'), backgroundColor: Colors.green),
      );
    }
  }
}


