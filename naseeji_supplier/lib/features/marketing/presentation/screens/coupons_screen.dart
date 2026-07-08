import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/widgets/general_widgets.dart';
import '../controllers/marketing_controllers.dart';
import '../widgets/coupon_card.dart';
import '../../domain/entities/marketing_models.dart';

class CouponsScreen extends ConsumerStatefulWidget {
  const CouponsScreen({super.key});

  @override
  ConsumerState<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends ConsumerState<CouponsScreen> {
  final _codeController = TextEditingController();
  final _discountController = TextEditingController();
  final _maxDiscountController = TextEditingController(text: '1000');
  final _limitController = TextEditingController(text: '100');

  String _discountType = 'percentage';

  @override
  void dispose() {
    _codeController.dispose();
    _discountController.dispose();
    _maxDiscountController.dispose();
    _limitController.dispose();
    super.dispose();
  }

  void _submitCoupon() {
    if (_codeController.text.isEmpty || _discountController.text.isEmpty) return;

    final discVal = double.tryParse(_discountController.text) ?? 0.0;
    final maxDisc = double.tryParse(_maxDiscountController.text) ?? 1000.0;
    final limit = int.tryParse(_limitController.text) ?? 100;

    final coupon = B2BDiscountCoupon(
      id: '',
      code: _codeController.text.toUpperCase(),
      discountType: _discountType,
      discountValue: discVal,
      maxDiscount: maxDisc,
      usageLimit: limit,
      usageCount: 0,
      perCustomerLimit: 1,
      expirationDate: DateTime.now().add(const Duration(days: 30)),
      eligibleProducts: ['الكل'],
      active: true,
    );

    ref.read(couponsControllerProvider.notifier).createCoupon(coupon);

    _codeController.clear();
    _discountController.clear();
    _maxDiscountController.clear();
    _limitController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إنشاء وتفعيل كوبون الخصم B2B بنجاح!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final couponsAsync = ref.watch(couponsControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Text(
            'كوبونات الخصم B2B',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.onSurface),
          ),
          centerTitle: true,
        ),
        body: Material(
          color: const Color(0xFFF8F9FF),
          child: couponsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('خطأ: $e')),
            data: (coupons) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Create coupon form
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
                            'توليد كوبون خصم B2B جديد للمصانع',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Divider(color: AppColors.outlineVariant),
                          ),
                          CustomTextField(
                            controller: _codeController,
                            labelText: 'كود الكوبون الإعلاني (أحرف إنجليزية ورقمية)',
                            hintText: 'مثال: WINTERFABRIC20',
                          ),
                          const SizedBox(height: 12),
                          const Text('نوع التخفيض المطبق', style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _discountType,
                            items: const [
                              DropdownMenuItem(value: 'percentage', child: Text('خصم بنسبة مئوية (%)', style: TextStyle(fontSize: 12))),
                              DropdownMenuItem(value: 'fixed', child: Text('خصم بقيمة مالية ثابتة (ر.س)', style: TextStyle(fontSize: 12))),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _discountType = val);
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
                                  controller: _maxDiscountController,
                                  labelText: 'الحد الأقصى للخصم (ر.س)',
                                  hintText: 'مثال: 1000',
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomTextField(
                                  controller: _discountController,
                                  labelText: 'قيمة الخصم',
                                  hintText: 'مثال: 15',
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            controller: _limitController,
                            labelText: 'الحد الأقصى للاستخدامات الكلية للمصانع',
                            hintText: 'مثال: 100',
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 20),
                          PrimaryButton(
                            onPressed: _submitCoupon,
                            text: 'إنشاء الكوبون ونشره بالمنصة',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Active coupons list
                    const Text(
                      'كوبونات الخصم النشطة الحالية',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 12),
                    ...coupons.map((coupon) {
                      return CouponCard(
                        coupon: coupon,
                        onToggleStatus: (val) {
                          ref.read(couponsControllerProvider.notifier).updateCouponStatus(coupon.id, val);
                        },
                      );
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
