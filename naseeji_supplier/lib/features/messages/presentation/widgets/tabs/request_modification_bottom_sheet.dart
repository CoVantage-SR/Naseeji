import 'package:flutter/material.dart';
import 'package:naseeji_supplier/features/messages/domain/entities/deal_quotation_model.dart';

class RequestModificationBottomSheet extends StatefulWidget {
  final DealQuotationModel currentQuotation;
  final Function({
    required double unitPrice,
    required int quantity,
    required String productionLeadTime,
    required String validityPeriod,
    required String paymentTerms,
    required String deliveryTerms,
    DateTime? expectedDeliveryDate,
    String? notes,
  }) onSubmitNewVersion;

  const RequestModificationBottomSheet({
    super.key,
    required this.currentQuotation,
    required this.onSubmitNewVersion,
  });

  @override
  State<RequestModificationBottomSheet> createState() => _RequestModificationBottomSheetState();
}

class _RequestModificationBottomSheetState extends State<RequestModificationBottomSheet> {
  late final TextEditingController _priceCtrl;
  late final TextEditingController _qtyCtrl;
  late final TextEditingController _leadTimeCtrl;
  late final TextEditingController _validityCtrl;
  late final TextEditingController _paymentCtrl;
  late final TextEditingController _deliveryCtrl;
  late final TextEditingController _notesCtrl;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    final q = widget.currentQuotation;
    _priceCtrl = TextEditingController(text: q.unitPrice.toStringAsFixed(0));
    _qtyCtrl = TextEditingController(text: q.quantity.toString());
    _leadTimeCtrl = TextEditingController(text: q.productionLeadTime);
    _validityCtrl = TextEditingController(text: q.validityPeriod);
    _paymentCtrl = TextEditingController(text: q.paymentTerms);
    _deliveryCtrl = TextEditingController(text: q.deliveryTerms);
    _notesCtrl = TextEditingController(text: q.notes);
    _selectedDate = q.expectedDeliveryDate ?? DateTime.now().add(const Duration(days: 7));
  }

  @override
  void dispose() {
    _priceCtrl.dispose();
    _qtyCtrl.dispose();
    _leadTimeCtrl.dispose();
    _validityCtrl.dispose();
    _paymentCtrl.dispose();
    _deliveryCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final nextVersion = widget.currentQuotation.versionNumber + 1;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.rate_review_outlined, color: colorScheme.primary, size: 20),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'تعديل وإرسال عرض جديد (Version $nextVersion)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'أدخل البيانات المعدلة. سيتم حفظ الإصدار القديم كما هو وإنشاء الإصدار رقم $nextVersion رسمياً.',
                style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _priceCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'السعر للوحدة (ج.م)',
                        hintText: '43',
                        prefixIcon: Icon(Icons.sell_outlined, size: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _qtyCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'الكمية المطلوبة',
                        hintText: '10000',
                        prefixIcon: Icon(Icons.shopping_bag_outlined, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _leadTimeCtrl,
                      decoration: const InputDecoration(
                        labelText: 'مدة الإنتاج والتصنيع',
                        hintText: '٦ أيام عمل',
                        prefixIcon: Icon(Icons.timer_outlined, size: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _validityCtrl,
                      decoration: const InputDecoration(
                        labelText: 'صلاحية العرض',
                        hintText: '١٥ يوم',
                        prefixIcon: Icon(Icons.event_available_outlined, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              TextField(
                controller: _paymentCtrl,
                decoration: const InputDecoration(
                  labelText: 'طريقة وشروط الدفع',
                  hintText: '٥٠٪ مقدم + ٥٠٪ عند الاستلام بالحساب الضامن',
                  prefixIcon: Icon(Icons.payment_outlined, size: 18),
                ),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: _deliveryCtrl,
                decoration: const InputDecoration(
                  labelText: 'طريقة التسليم',
                  hintText: 'توصيل لمقر المصنع بمباشرة',
                  prefixIcon: Icon(Icons.local_shipping_outlined, size: 18),
                ),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: _notesCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'ملاحظات وتوضيحات التعديل (تخضع لفحص الأمان)',
                  hintText: 'تم تقديم خصم خاص 4% بناء على طلب المصنع',
                  prefixIcon: Icon(Icons.note_alt_outlined, size: 18),
                ),
              ),
              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final price = double.tryParse(_priceCtrl.text) ?? widget.currentQuotation.unitPrice;
                    final qty = int.tryParse(_qtyCtrl.text) ?? widget.currentQuotation.quantity;

                    widget.onSubmitNewVersion(
                      unitPrice: price,
                      quantity: qty,
                      productionLeadTime: _leadTimeCtrl.text.trim().isEmpty ? widget.currentQuotation.productionLeadTime : _leadTimeCtrl.text.trim(),
                      validityPeriod: _validityCtrl.text.trim().isEmpty ? widget.currentQuotation.validityPeriod : _validityCtrl.text.trim(),
                      paymentTerms: _paymentCtrl.text.trim().isEmpty ? widget.currentQuotation.paymentTerms : _paymentCtrl.text.trim(),
                      deliveryTerms: _deliveryCtrl.text.trim().isEmpty ? widget.currentQuotation.deliveryTerms : _deliveryCtrl.text.trim(),
                      expectedDeliveryDate: _selectedDate,
                      notes: _notesCtrl.text.trim(),
                    );

                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.send_rounded, size: 18),
                  label: Text('إعتماد وإرسال الإصدار رقم $nextVersion'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 44),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
