import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/quotations_provider.dart';
import '../widgets/counter_offer_widgets.dart';

class CounterOfferScreen extends ConsumerStatefulWidget {
  final String quoteId;

  const CounterOfferScreen({super.key, required this.quoteId});

  @override
  ConsumerState<CounterOfferScreen> createState() => _CounterOfferScreenState();
}

class _CounterOfferScreenState extends ConsumerState<CounterOfferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _qtyController = TextEditingController();
  final _termsController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _deliveryDate = DateTime.now().add(const Duration(days: 20));

  @override
  void initState() {
    super.initState();
    final q = ref.read(quotationsNotifierProvider.notifier).getQuotationById(widget.quoteId);
    if (q != null) {
      _priceController.text = (q.quotedPricePerUnit - 5.0).toInt().toString(); // Default counter offer suggestion
      _qtyController.text = q.moq.toString();
      _termsController.text = q.paymentMethod;
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    _qtyController.dispose();
    _termsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deliveryDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _deliveryDate = picked;
      });
    }
  }

  void _submitCounterOffer() {
    if (_formKey.currentState!.validate()) {
      ref.read(quotationsNotifierProvider.notifier).sendCounterOffer(
            widget.quoteId,
            price: double.tryParse(_priceController.text) ?? 100.0,
            quantity: int.tryParse(_qtyController.text) ?? 500,
            deliveryDate: _deliveryDate != null
                ? '${_deliveryDate!.year}/${_deliveryDate!.month}/${_deliveryDate!.day}'
                : 'غير محدد',
            paymentTerms: _termsController.text.trim(),
            notes: _notesController.text.trim(),
          );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إرسال العرض البديل للمورد بنجاح! سيتم إشعارك عند الرد.')),
      );

      // Return back to quotations
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final quotation = ref.watch(quotationsNotifierProvider.notifier).getQuotationById(widget.quoteId);

    if (quotation == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('العرض غير موجود.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('تقديم عرض سعر بديل (Counter Offer)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                OriginalOfferWidget(
                  originalPrice: quotation.quotedPricePerUnit,
                  originalQuantity: quotation.moq,
                  originalDeliveryDate: quotation.validUntil,
                ),
                AppSpacing.hMD,
                // Form Fields
                PrimaryCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'شروط العرض البديل المقترحة',
                        style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'السعر المستهدف للوحدة (ج.م)',
                          prefixIcon: Icon(Icons.money_rounded),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) return 'يرجى تحديد السعر';
                          if (double.tryParse(val) == null) return 'الرقم غير صالح';
                          return null;
                        },
                      ),
                      AppSpacing.hMD,
                      TextFormField(
                        controller: _qtyController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'الكمية المطلوبة المعدلة',
                          prefixIcon: Icon(Icons.numbers_rounded),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) return 'يرجى تحديد الكمية';
                          if (int.tryParse(val) == null) return 'الرقم غير صالح';
                          return null;
                        },
                      ),
                      AppSpacing.hMD,
                      InkWell(
                        onTap: () => _selectDate(context),
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
                                  Text('تاريخ التسليم المطلوب المفضل'),
                                ],
                              ),
                              Text(
                                _deliveryDate != null
                                    ? '${_deliveryDate!.year}/${_deliveryDate!.month}/${_deliveryDate!.day}'
                                    : 'اختر التاريخ',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AppSpacing.hMD,
                      TextFormField(
                        controller: _termsController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'طريقة الدفع المقترحة',
                          prefixIcon: Icon(Icons.payment_rounded),
                        ),
                      ),
                      AppSpacing.hMD,
                      TextFormField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'رسالة إضافية ومبررات التعديل للمورد',
                          hintText: 'اكتب هنا أي شروحات إضافية للمورد لدعم عرضك البديل...',
                          prefixIcon: Icon(Icons.chat_bubble_outline_rounded),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Actions Row
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: AppColors.primary),
                          foregroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                        ),
                        child: const Text('تراجع / إلغاء'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submitCounterOffer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                        ),
                        child: const Text('إرسال العرض البديل'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
