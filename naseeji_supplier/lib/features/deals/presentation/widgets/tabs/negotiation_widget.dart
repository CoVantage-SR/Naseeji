import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/deal_model.dart';
import '../controllers/deals_controller.dart';

class NegotiationWidget extends ConsumerStatefulWidget {
  final DealModel deal;

  const NegotiationWidget({super.key, required this.deal});

  @override
  ConsumerState<NegotiationWidget> createState() => _NegotiationWidgetState();
}

class _NegotiationWidgetState extends ConsumerState<NegotiationWidget> {
  late final TextEditingController _priceCtrl;
  late final TextEditingController _qtyCtrl;
  late final TextEditingController _daysCtrl;
  late final TextEditingController _termsCtrl;
  late final TextEditingController _statusCtrl;

  @override
  void initState() {
    super.initState();
    final neg = widget.deal.negotiation;
    _priceCtrl = TextEditingController(text: (neg?.proposedUnitPrice ?? widget.deal.product.unitPrice).toString());
    _qtyCtrl = TextEditingController(text: (neg?.proposedQuantity ?? widget.deal.product.quantity).toString());
    _daysCtrl = TextEditingController(text: (neg?.proposedProductionDays ?? 5).toString());
    _termsCtrl = TextEditingController(text: neg?.proposedPaymentTerms ?? '40% مقدم، 60% عند الجودة');
    _statusCtrl = TextEditingController(text: neg?.statusText ?? '');
  }

  @override
  void dispose() {
    _priceCtrl.dispose();
    _qtyCtrl.dispose();
    _daysCtrl.dispose();
    _termsCtrl.dispose();
    _statusCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final neg = widget.deal.negotiation;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (neg != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.handshake_outlined, color: Colors.purple, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'عرض التفاوض المقابل من المصنع',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.purple.shade900),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(neg.statusText, style: const TextStyle(fontSize: 10.5, color: Colors.black87, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildDetailRow('السعر المقترح:', '${neg.proposedUnitPrice} ج.م'),
                  _buildDetailRow('الكمية المقترحة:', '${neg.proposedQuantity}'),
                  _buildDetailRow('أيام الإنتاج المقترحة:', '${neg.proposedProductionDays} أيام'),
                  _buildDetailRow('شروط السداد المقترحة:', neg.proposedPaymentTerms),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _acceptNegotiation,
                          icon: const Icon(Icons.check_circle_outline, size: 16),
                          label: const Text('قبول التفاوض واعتماد العقد'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],

          // Submit Counter Offer Form
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.swap_horiz_rounded, size: 16, color: colorScheme.primary),
                    const SizedBox(width: 6),
                    Text(
                      'تقديم عرض تعديل مقابل (Counter Offer)',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _priceCtrl,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 11),
                        decoration: const InputDecoration(labelText: 'السعر المقترح (ج.م)', contentPadding: EdgeInsets.all(8)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _qtyCtrl,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 11),
                        decoration: const InputDecoration(labelText: 'الكمية المقترحة', contentPadding: EdgeInsets.all(8)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _daysCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 11),
                  decoration: const InputDecoration(labelText: 'مدة الإنتاج (أيام)', contentPadding: EdgeInsets.all(8)),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _termsCtrl,
                  style: const TextStyle(fontSize: 11),
                  decoration: const InputDecoration(labelText: 'طريقة وشروط الدفع', contentPadding: EdgeInsets.all(8)),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _statusCtrl,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 11),
                  decoration: const InputDecoration(
                    labelText: 'سبب أو تفاصيل التعديل (ممنوع أي رقم هاتف أو رابط)',
                    contentPadding: EdgeInsets.all(8),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _submitCounterOffer,
                    icon: const Icon(Icons.send_rounded, size: 16),
                    label: const Text('إرسال العرض المقابل للمصنع'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.black87)),
          Text(val, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.purple)),
        ],
      ),
    );
  }

  Future<void> _acceptNegotiation() async {
    final success = await ref.read(dealsControllerProvider.notifier).acceptNegotiation(widget.deal.id);
    if (mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم قبول التفاوض وتحويل الصفقة لمرحلة توقيع الاتفاق 📜'), backgroundColor: Colors.green),
      );
    }
  }

  Future<void> _submitCounterOffer() async {
    final price = double.tryParse(_priceCtrl.text) ?? widget.deal.product.unitPrice;
    final qty = int.tryParse(_qtyCtrl.text) ?? widget.deal.product.quantity;
    final days = int.tryParse(_daysCtrl.text) ?? 5;

    final success = await ref.read(dealsControllerProvider.notifier).submitCounterOffer(
          dealId: widget.deal.id,
          proposedUnitPrice: price,
          proposedQuantity: qty,
          proposedProductionDays: days,
          proposedPaymentTerms: _termsCtrl.text,
          proposedDeliveryDate: '2026-03-10',
          statusText: _statusCtrl.text,
        );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إرسال العرض المقابل للمصنع 🤝'), backgroundColor: Colors.purple),
        );
      } else {
        final err = ref.read(dealsControllerProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err?.toString().replaceAll('Exception: ', '') ?? 'تعذر إرسال العرض'), backgroundColor: Colors.red),
        );
      }
    }
  }
}
