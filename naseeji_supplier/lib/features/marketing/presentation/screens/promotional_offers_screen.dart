import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/widgets/general_widgets.dart';
import '../controllers/marketing_controllers.dart';
import '../widgets/offer_card.dart';
import '../../domain/entities/marketing_models.dart';

class PromotionalOffersScreen extends ConsumerStatefulWidget {
  const PromotionalOffersScreen({super.key});

  @override
  ConsumerState<PromotionalOffersScreen> createState() => _PromotionalOffersScreenState();
}

class _PromotionalOffersScreenState extends ConsumerState<PromotionalOffersScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _discountController = TextEditingController();
  final _minQtyController = TextEditingController(text: '100');

  OfferType _selectedType = OfferType.percentageDiscount;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _discountController.dispose();
    _minQtyController.dispose();
    super.dispose();
  }

  void _submitOffer() {
    if (_titleController.text.isEmpty || _discountController.text.isEmpty) return;

    final discValue = double.tryParse(_discountController.text) ?? 0.0;
    final minQty = int.tryParse(_minQtyController.text) ?? 100;

    final offer = PromotionalOffer(
      id: 'OFF-${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text,
      type: _selectedType,
      discountValue: discValue,
      minQuantity: minQty,
      active: true,
      reach: 0,
      conversions: 0,
      description: _descController.text,
    );

    ref.read(promotionalOffersControllerProvider.notifier).createOffer(offer);

    _titleController.clear();
    _descController.clear();
    _discountController.clear();
    _minQtyController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إنشاء العرض الترويجي B2B بنجاح!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final offersAsync = ref.watch(promotionalOffersControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Text(
            'العروض الترويجية B2B',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.onSurface),
          ),
          centerTitle: true,
        ),
        body: Material(
          color: const Color(0xFFF8F9FF),
          child: offersAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('خطأ: $e')),
            data: (offers) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Create Offer Form
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'إنشاء عرض ترويجي جديد للمصانع',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Divider(color: AppColors.outlineVariant),
                          ),
                          CustomTextField(
                            controller: _titleController,
                            labelText: 'عنوان العرض الترويجي الموجه للمشتري',
                            hintText: 'مثال: خصم مصانع ملابس الصيف على طلبيات الكتان',
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            controller: _descController,
                            labelText: 'تفاصيل وشروط العرض',
                            hintText: 'مثال: يسري العرض للمصانع عند طلب أكثر من 1000 ياردة',
                            maxLines: 2,
                          ),
                          const SizedBox(height: 12),
                          const Text('نوع العرض الترويجي B2B', style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<OfferType>(
                            value: _selectedType,
                            items: const [
                              DropdownMenuItem(value: OfferType.percentageDiscount, child: Text('نسبة مئوية (%)', style: TextStyle(fontSize: 12))),
                              DropdownMenuItem(value: OfferType.fixedDiscount, child: Text('خصم ثابت (ر.س)', style: TextStyle(fontSize: 12))),
                              DropdownMenuItem(value: OfferType.freeShipping, child: Text('شحن مجاني عند الطلب الكبير', style: TextStyle(fontSize: 12))),
                              DropdownMenuItem(value: OfferType.vipPricing, child: Text('أسعار VIP حصرية', style: TextStyle(fontSize: 12))),
                              DropdownMenuItem(value: OfferType.buyMoreSaveMore, child: Text('اشترِ أكثر ووفر (Buy More Save More)', style: TextStyle(fontSize: 12))),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedType = val);
                            },
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: _minQtyController,
                                  labelText: 'الحد الأدنى للكمية المطلوبة',
                                  hintText: 'مثال: 500',
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomTextField(
                                  controller: _discountController,
                                  labelText: 'قيمة الخصم / التوفير',
                                  hintText: 'مثال: 15',
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          PrimaryButton(
                            onPressed: _submitOffer,
                            text: 'حفظ ونشر العرض الترويجي',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Active promotional offers list
                    const Text(
                      'العروض الترويجية الحالية',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 12),
                    ...offers.map((offer) {
                      return OfferCard(offer: offer);
                    }),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
