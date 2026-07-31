import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_factory/supplier/features/deals/domain/entities/deal_model.dart';
import 'package:naseeji_factory/supplier/features/deals/presentation/controllers/deals_controller.dart';

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
  late final TextEditingController _notesCtrl;

  @override
  void initState() {
    super.initState();
    final neg = widget.deal.negotiation;
    _priceCtrl = TextEditingController(text: (neg?.proposedUnitPrice ?? widget.deal.product.unitPrice).toString());
    _qtyCtrl = TextEditingController(text: (neg?.proposedQuantity ?? widget.deal.product.quantity).toString());
    _daysCtrl = TextEditingController(text: (neg?.proposedProductionDays ?? 5).toString());
    _termsCtrl = TextEditingController(text: neg?.proposedPaymentTerms ?? '50% مقدم + 50% عند الاستلام بالضمين');
    _notesCtrl = TextEditingController(text: neg?.statusText ?? '');
  }

  @override
  void dispose() {
    _priceCtrl.dispose();
    _qtyCtrl.dispose();
    _daysCtrl.dispose();
    _termsCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final neg = widget.deal.negotiation;
    final isNegotiating = widget.deal.status == DealStatus.negotiation || neg != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isNegotiating && neg != null) ...[
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
                        'طلب التعديل المقدم من المصنع (Counter Offer)',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.purple.shade900),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (neg.statusText.isNotEmpty)
                    Text('ملاحظات المصنع: ${neg.statusText}', style: const TextStyle(fontSize: 10.5, color: Colors.black87, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildDetailRow('السعر المقترح من المصنع:', '${neg.proposedUnitPrice} ج.م'),
                  _buildDetailRow('الكمية المقترحة من المصنع:', '${neg.proposedQuantity}'),
                  _buildDetailRow('مدة الإنتاج المطلوبة:', '${neg.proposedProductionDays} أيام'),
                  _buildDetailRow('شروط السداد المقترحة:', neg.proposedPaymentTerms),
                  const SizedBox(height: 12),

                  // ─── THE 4 SUPPLIER BUTTONS ONLY ───────────────────────────
                  Text('خيارات المورد للرد على المصنع:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.purple.shade900)),
                  const SizedBox(height: 8),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _acceptNegotiation,
                      icon: const Icon(Icons.check_circle_rounded, size: 16),
                      label: const Text('1. قبول عرض التعديل (Accept Counter Offer)'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, foregroundColor: Colors.white, minimumSize: const Size(0, 38)),
                    ),
                  ),
                  const SizedBox(height: 6),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم رفض طلب التعديل المقدم من المصنع 🔴'), backgroundColor: Colors.red),
                        );
                      },
                      icon: const Icon(Icons.cancel_rounded, size: 16),
                      label: const Text('2. رفض طلب التعديل (Reject Counter Offer)'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, foregroundColor: Colors.white, minimumSize: const Size(0, 38)),
                    ),
                  ),
                  const SizedBox(height: 6),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _showSendNewVersionDialog,
                      icon: const Icon(Icons.send_rounded, size: 16),
                      label: const Text('3. إرسال عرض سعر جديد (Send Quotation V2)'),
                      style: OutlinedButton.styleFrom(foregroundColor: colorScheme.primary, side: BorderSide(color: colorScheme.primary), minimumSize: const Size(0, 38)),
                    ),
                  ),
                  const SizedBox(height: 6),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم توجيه طلب الاستيضاح إلى المحادثة المباشرة 💬')),
                        );
                      },
                      icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                      label: const Text('4. طلب استيضاح في المحادثة (Ask For Clarification)'),
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.purple.shade900, side: BorderSide(color: Colors.purple.shade300), minimumSize: const Size(0, 38)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ] else ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  Icon(Icons.hourglass_bottom_rounded, color: Colors.orange.shade700, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'في انتظار مراجعة ورد المصنع ⏳',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'المصنع هو الطرف الذي يدرس العرض ويبدأ طلب التعديل (Counter Offer). المورد لا يستطيع بدء تفاوض منفرد.',
                          style: TextStyle(fontSize: 10.5, color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
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
          Text(label, style: const TextStyle(fontSize: 10.5, color: Colors.black87)),
          Text(val, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.purple)),
        ],
      ),
    );
  }

  Future<void> _acceptNegotiation() async {
    final success = await ref.read(dealsControllerProvider.notifier).acceptNegotiation(widget.deal.id);
    if (mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم قبول عرض التعديل وتحويل الصفقة لمرحلة العقد 📜'), backgroundColor: Colors.green),
      );
    }
  }

  void _showSendNewVersionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إرسال عرض سعر جديد (V2)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _priceCtrl, decoration: const InputDecoration(labelText: 'السعر للوحدة (ج.م)')),
              const SizedBox(height: 8),
              TextField(controller: _qtyCtrl, decoration: const InputDecoration(labelText: 'الكمية')),
              const SizedBox(height: 8),
              TextField(controller: _termsCtrl, decoration: const InputDecoration(labelText: 'شروط الدفع')),
              const SizedBox(height: 8),
              TextField(controller: _notesCtrl, decoration: const InputDecoration(labelText: 'ملاحظات العرض الجديد')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إرسال عرض السعر الجديد (V2) بنجاح وفي انتظار رد المصنع 🟢'), backgroundColor: Colors.green),
              );
            },
            child: const Text('إرسال الإصدار الجديد'),
          ),
        ],
      ),
    );
  }
}


