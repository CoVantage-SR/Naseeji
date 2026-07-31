import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/chat_provider.dart';
import '../widgets/quotation_sheet_widgets.dart';

class EditQuotationSheet extends ConsumerStatefulWidget {
  final String conversationId;
  final Message quoteMessage;

  const EditQuotationSheet({
    super.key,
    required this.conversationId,
    required this.quoteMessage,
  });

  @override
  ConsumerState<EditQuotationSheet> createState() => _EditQuotationSheetState();
}

class _EditQuotationSheetState extends ConsumerState<EditQuotationSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _priceController;
  late TextEditingController _moqController;
  late TextEditingController _prepController;
  late TextEditingController _shippingController;
  late TextEditingController _paymentController;
  late TextEditingController _warrantyController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(text: (widget.quoteMessage.quotationPrice?.toInt() ?? 100).toString());
    _moqController = TextEditingController(text: (widget.quoteMessage.quotationMoq ?? 500).toString());
    _prepController = TextEditingController(text: (widget.quoteMessage.quotationPrepDays ?? 7).toString());
    _shippingController = TextEditingController(text: (widget.quoteMessage.quotationShippingDays ?? 2).toString());
    _paymentController = TextEditingController(text: widget.quoteMessage.quotationPayment ?? '');
    _warrantyController = TextEditingController(text: widget.quoteMessage.quotationWarranty ?? '');
    _notesController = TextEditingController(text: widget.quoteMessage.quotationNotes ?? '');
  }

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

  void _updateQuotation() {
    if (_formKey.currentState!.validate()) {
      final currentVersion = widget.quoteMessage.quotationVersion ?? 1;

      // Simulate a counter revision offer from supplier/factory
      ref.read(messagesNotifierProvider.notifier).receiveSupplierQuotation(
            widget.conversationId,
            price: double.tryParse(_priceController.text) ?? 100.0,
            moq: int.tryParse(_moqController.text) ?? 500,
            prepDays: int.tryParse(_prepController.text) ?? 7,
            shippingDays: int.tryParse(_shippingController.text) ?? 2,
            payment: _paymentController.text.trim(),
            warranty: _warrantyController.text.trim(),
            expiry: widget.quoteMessage.quotationExpiry ?? 'غير محدد',
            notes: _notesController.text.trim(),
            version: currentVersion + 1,
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
              QuotationHeaderWidget(
                title: 'تعديل وتفاوض عرض السعر (إصدار #${(widget.quoteMessage.quotationVersion ?? 1) + 1})',
                subtitle: 'قم بتعديل الأسعار أو شروط التسليم لتقديم نسخة جديدة للمفاوضة.',
              ),
              AppSpacing.hMD,
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'سعر الوحدة المقترح الجديد (ج.م)',
                  prefixIcon: Icon(Icons.money_rounded),
                ),
                validator: (val) => val == null || val.isEmpty ? 'يرجى إدخال السعر' : null,
              ),
              AppSpacing.hMD,
              TextFormField(
                controller: _moqController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'الحد الأدنى المقترح (MOQ)',
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
                      decoration: const InputDecoration(labelText: 'زمن التجهيز المقترح'),
                      validator: (val) => val == null || val.isEmpty ? 'مطلوب' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _shippingController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'زمن الشحن المقترح'),
                      validator: (val) => val == null || val.isEmpty ? 'مطلوب' : null,
                    ),
                  ),
                ],
              ),
              AppSpacing.hMD,
              TextFormField(
                controller: _paymentController,
                decoration: const InputDecoration(
                  labelText: 'شروط السداد والدفع المعدلة',
                  prefixIcon: Icon(Icons.payment_rounded),
                ),
              ),
              AppSpacing.hMD,
              TextFormField(
                controller: _warrantyController,
                decoration: const InputDecoration(
                  labelText: 'الضمان المطلوب',
                  prefixIcon: Icon(Icons.shield_outlined),
                ),
              ),
              AppSpacing.hMD,
              TextFormField(
                controller: _notesController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'مبررات التعديل وملاحظات إضافية',
                  prefixIcon: Icon(Icons.notes_rounded),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _updateQuotation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                ),
                child: const Text('إرسال التعديلات وجولة تفاوض جديدة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

