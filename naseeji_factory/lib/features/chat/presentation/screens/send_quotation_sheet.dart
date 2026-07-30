import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../providers/chat_provider.dart';
import '../widgets/quotation_sheet_widgets.dart';

class SendQuotationSheet extends ConsumerStatefulWidget {
  final String conversationId;

  const SendQuotationSheet({super.key, required this.conversationId});

  @override
  ConsumerState<SendQuotationSheet> createState() => _SendQuotationSheetState();
}

class _SendQuotationSheetState extends ConsumerState<SendQuotationSheet> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _moqController = TextEditingController();
  final _prepController = TextEditingController();
  final _shippingController = TextEditingController();
  final _paymentController = TextEditingController();
  final _warrantyController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _expiryDate = DateTime.now().add(const Duration(days: 30));

  @override
  void dispose() {
    _priceController.dispose();
    _moqController.dispose();
    _prepController.dispose();
    _shippingController.dispose();
    _paymentController.dispose();
    _warrantyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _expiryDate = picked;
      });
    }
  }

  void _sendQuotation() {
    if (_formKey.currentState!.validate()) {
      ref.read(messagesNotifierProvider.notifier).sendMessage(
            widget.conversationId,
            'عرض سعر مقترح بقيمة ${_priceController.text} ج.م',
            type: 'quotation',
            quotationPrice: double.tryParse(_priceController.text) ?? 100.0,
            quotationMoq: int.tryParse(_moqController.text) ?? 500,
            quotationPrepDays: int.tryParse(_prepController.text) ?? 7,
            quotationShippingDays: int.tryParse(_shippingController.text) ?? 2,
            quotationPayment: _paymentController.text.trim(),
            quotationWarranty: _warrantyController.text.trim(),
            quotationExpiry: _expiryDate != null
                ? '${_expiryDate!.year}/${_expiryDate!.month}/${_expiryDate!.day}'
                : 'غير محدد',
            quotationNotes: _notesController.text.trim(),
            quotationVersion: 1,
          );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const QuotationHeaderWidget(
                title: 'تقديم عرض سعر جديد',
                subtitle: 'املأ تفاصيل الأسعار وفترات التسليم لإرسالها كبطاقة عرض للمفاوضة.',
              ),
              AppSpacing.hMD,
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'سعر الوحدة المعروض (ج.م)',
                  prefixIcon: Icon(Icons.money_rounded),
                ),
                validator: (val) => val == null || val.isEmpty ? 'يرجى إدخال السعر' : null,
              ),
              AppSpacing.hMD,
              TextFormField(
                controller: _moqController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'الحد الأدنى للطلب (MOQ)',
                  prefixIcon: Icon(Icons.shopping_bag_outlined),
                ),
                validator: (val) => val == null || val.isEmpty ? 'يرجى تحديد الحد الأدنى للطلب' : null,
              ),
              AppSpacing.hMD,
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _prepController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'زمن التجهيز (أيام)'),
                      validator: (val) => val == null || val.isEmpty ? 'مطلوب' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _shippingController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'زمن الشحن (أيام)'),
                      validator: (val) => val == null || val.isEmpty ? 'مطلوب' : null,
                    ),
                  ),
                ],
              ),
              AppSpacing.hMD,
              TextFormField(
                controller: _paymentController,
                decoration: const InputDecoration(
                  labelText: 'شروط السداد والدفع',
                  hintText: 'مثال: 30% مقدم والباقي عند الاستلام',
                  prefixIcon: Icon(Icons.payment_rounded),
                ),
              ),
              AppSpacing.hMD,
              TextFormField(
                controller: _warrantyController,
                decoration: const InputDecoration(
                  labelText: 'شهادة ضمان الجودة الممنوحة',
                  prefixIcon: Icon(Icons.shield_outlined),
                ),
              ),
              AppSpacing.hMD,
              InkWell(
                onTap: () => _selectExpiryDate(context),
                borderRadius: AppRadius.rMD,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: AppRadius.rMD,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.calendar_today_rounded, color: Colors.grey, size: 20),
                          SizedBox(width: 12),
                          Text('تاريخ انتهاء صلاحية العرض'),
                        ],
                      ),
                      Text(
                        _expiryDate != null
                            ? '${_expiryDate!.year}/${_expiryDate!.month}/${_expiryDate!.day}'
                            : 'اختر التاريخ',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ),
              AppSpacing.hMD,
              TextFormField(
                controller: _notesController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'ملاحظات إضافية للمشتري',
                  prefixIcon: Icon(Icons.notes_rounded),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _sendQuotation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                ),
                child: const Text('إرسال عرض السعر للدردشة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
