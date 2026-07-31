import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import 'package:naseeji_factory/core/widgets/general_widgets.dart';
import '../controllers/subscription_controllers.dart';
import '../../domain/entities/subscription_models.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final SubscriptionPlan? plan;
  final BillingCycle? cycle;
  final AddonItem? addon;

  const CheckoutScreen({
    super.key,
    this.plan,
    this.cycle,
    this.addon,
  });

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _couponController = TextEditingController();
  final _addressController = TextEditingController(text: 'المنطقة الصناعية الثانية، الرياض، المملكة العربية السعودية');
  
  double _discount = 0.0;
  String? _appliedCoupon;

  @override
  void dispose() {
    _couponController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _applyCouponCode(double basePrice) {
    if (_couponController.text.toUpperCase() == 'NASEEJI20') {
      setState(() {
        _discount = basePrice * 0.20; // 20% discount
        _appliedCoupon = 'NASEEJI20';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تطبيق خصم 20% بنجاح!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('كود الخصم غير صالح.')),
      );
    }
    _couponController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final double basePrice = widget.addon != null
        ? widget.addon!.price
        : (widget.plan != null
            ? (widget.cycle == BillingCycle.yearly ? widget.plan!.price * 12 * 0.8 : widget.plan!.price)
            : 0.0);

    final String name = widget.addon != null
        ? widget.addon!.name
        : (widget.plan != null
            ? '${widget.plan!.name} (${widget.cycle == BillingCycle.yearly ? "سنوي" : "شهري"})'
            : 'باقة مجهولة');

    final double subtotal = basePrice - _discount;
    final double vat = subtotal * 0.15;
    final double grandTotal = subtotal + vat;

    final methodsAsync = ref.watch(paymentMethodsControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0.5,
          title: Text(
            'مراجعة وتأكيد الشراء',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
          ),
          centerTitle: true,
        ),
        body: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Order Summary card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'ملخص تفاصيل الفاتورة',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                      ),
                      const Divider(height: 20, color: AppColors.outlineVariant),
                      _buildSummaryRow('الباقة / الخدمة المطلوبة', name),
                      _buildSummaryRow('السعر الأساسي', '${basePrice.toStringAsFixed(0)} جنيه'),
                      if (_discount > 0)
                        _buildSummaryRow('كود الخصم المطبق ($_appliedCoupon)', '-${_discount.toStringAsFixed(0)} جنيه'),
                      _buildSummaryRow('الضريبة المضافة (15% VAT)', '${vat.toStringAsFixed(2)} جنيه'),
                      const Divider(color: AppColors.outlineVariant),
                      _buildSummaryRow('المبلغ الإجمالي المستحق', '${grandTotal.toStringAsFixed(2)} جنيه', isBold: true),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // Coupon field
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('هل لديك كوبون تخفيض للمنشأة؟', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () => _applyCouponCode(basePrice),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0040E0),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(80, 48),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            child: Text('تطبيق', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: CustomTextField(
                              controller: _couponController,
                              labelText: 'كوبون خصم المنصة B2B',
                              hintText: 'مثال: NASEEJI20',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // Payment Method Card
                methodsAsync.when(
                  loading: () => Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('خطأ: $e'),
                  data: (methods) {
                    final defaultMethod = methods.firstWhere((m) => m.isDefault, orElse: () => methods.first);

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () => context.push('/subscription/methods'),
                                child: Text('تغيير', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0040E0))),
                              ),
                              Text(
                                'وسيلة الدفع المختارة',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                              ),
                            ],
                          ),
                          const Divider(height: 16, color: AppColors.outlineVariant),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    defaultMethod.name,
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                                  ),
                                  Text(
                                    defaultMethod.details,
                                    style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant),
                                  ),
                                ],
                              ),
                              SizedBox(width: 12),
                              const Icon(Icons.credit_card, color: Color(0xFF0040E0), size: 20),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 16),

                // Billing Address Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'عنوان الفاتورة للمحاسبة الضريبية',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                      ),
                      const Divider(height: 20, color: AppColors.outlineVariant),
                      CustomTextField(
                        controller: _addressController,
                        labelText: 'العنوان الوطني أو السجل التجاري للشركة',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                PrimaryButton(
                  text: 'شراء وتأكيد عملية الفوترة',
                  onPressed: () {
                    // Trigger actual purchase changes in provider
                    if (widget.addon != null) {
                      ref.read(addonsStoreControllerProvider.notifier).buyAddon(widget.addon!.id);
                    } else if (widget.plan != null && widget.cycle != null) {
                      ref.read(activeSubscriptionControllerProvider.notifier).upgrade(widget.plan!.id, widget.cycle!);
                    }

                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('نجاح العملية', textAlign: TextAlign.right),
                        content: Text('تمت عملية الشراء وتفعيل الباقة بنجاح وصدرت الفاتورة المالية.', textAlign: TextAlign.right),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              context.go('/subscription');
                            },
                            child: Text('حسناً'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 14 : 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? const Color(0xFF0040E0) : Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}


