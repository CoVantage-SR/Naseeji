import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/supplier/features/deals/domain/entities/deal_model.dart';
import 'package:naseeji_factory/supplier/features/deals/presentation/controllers/deals_controller.dart';

class QuotationWidget extends ConsumerStatefulWidget {
  final DealModel deal;

  const QuotationWidget({super.key, required this.deal});

  @override
  ConsumerState<QuotationWidget> createState() => _QuotationWidgetState();
}

class _QuotationWidgetState extends ConsumerState<QuotationWidget> {
  late final TextEditingController _priceCtrl;
  late final TextEditingController _daysCtrl;
  late final TextEditingController _termsCtrl;
  late final TextEditingController _notesCtrl;

  @override
  void initState() {
    super.initState();
    final quote = widget.deal.quotation;
    _priceCtrl = TextEditingController(text: (quote?.unitPrice ?? widget.deal.product.unitPrice).toString());
    _daysCtrl = TextEditingController(text: (quote?.productionDays ?? 7).toString());
    _termsCtrl = TextEditingController(text: quote?.paymentTerms ?? '50% مقدم بالضمان، 50% عند قبول الجودة');
    _notesCtrl = TextEditingController(text: quote?.notes ?? '');
  }

  @override
  void dispose() {
    _priceCtrl.dispose();
    _daysCtrl.dispose();
    _termsCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final quote = widget.deal.quotation;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner to open direct Deal Chat between both parties
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF006B5F).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF006B5F).withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.chat_rounded, color: Color(0xFF006B5F), size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'المحادثات والتفاوض المباشر',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF006B5F)),
                      ),
                      Text(
                        'تواصل مباشرة مع المصنع وتابع التعديلات المباشرة داخل الصفقة.',
                        style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => context.push('/messages/chat?dealId=${widget.deal.id}'),
                  icon: const Icon(Icons.forum_rounded, size: 14),
                  label: const Text('فتح الشات', style: TextStyle(fontSize: 11)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006B5F),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 34),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          if (quote != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: Colors.blue, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'تم تقديم عرض السعر برقم ${quote.quoteId}',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow('سعر الوحدة المقدم:', '${quote.unitPrice} ${quote.currency} / ${widget.deal.product.unit}'),
                  _buildDetailRow('مدة التصنيع والتحضير:', '${quote.productionDays} أيام عمل'),
                  _buildDetailRow('شروط الدفع:', quote.paymentTerms),
                  _buildDetailRow('الإجمالي:', '${quote.totalPrice} ${quote.currency}'),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],

          // Form to send / edit quote
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
                    Icon(Icons.send_rounded, size: 16, color: colorScheme.primary),
                    const SizedBox(width: 6),
                    Text(
                      quote == null ? 'إنشاء وإرسال عرض السعر' : 'تعديل عرض السعر الحالي',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: _priceCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 11.5),
                  decoration: InputDecoration(
                    labelText: 'سعر الوحدة (ج.م)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _daysCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 11.5),
                  decoration: InputDecoration(
                    labelText: 'مدة الإنتاج والتسليم بالـ (أيام)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _termsCtrl,
                  style: const TextStyle(fontSize: 11.5),
                  decoration: InputDecoration(
                    labelText: 'شروط وسداد الدفع',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _notesCtrl,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 11.5),
                  decoration: InputDecoration(
                    labelText: 'ملاحظات وتفاصيل التوريد (ممنوع وسيلة تواصل خارجية)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _submitQuote,
                    icon: const Icon(Icons.send_rounded, size: 16),
                    label: Text(quote == null ? 'إرسال عرض السعر للمصنع' : 'تحديث عرض السعر'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
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

  Widget _buildDetailRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 10.5, color: Colors.black87)),
          Text(val, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.blue)),
        ],
      ),
    );
  }

  Future<void> _submitQuote() async {
    final price = double.tryParse(_priceCtrl.text) ?? widget.deal.product.unitPrice;
    final days = int.tryParse(_daysCtrl.text) ?? 7;

    final success = await ref.read(dealsControllerProvider.notifier).sendQuotation(
          dealId: widget.deal.id,
          unitPrice: price,
          quantity: widget.deal.product.quantity,
          productionDays: days,
          paymentTerms: _termsCtrl.text,
          notes: _notesCtrl.text,
        );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إرسال عرض السعر بنجاح للمصنع 🚀'), backgroundColor: Colors.green),
        );
        // Automatically navigate to Deal Chat
        context.push('/messages/chat?dealId=${widget.deal.id}');
      } else {
        final err = ref.read(dealsControllerProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err?.toString().replaceAll('Exception: ', '') ?? 'تعذر إرسال عرض السعر'), backgroundColor: Colors.red),
        );
      }
    }
  }
}

