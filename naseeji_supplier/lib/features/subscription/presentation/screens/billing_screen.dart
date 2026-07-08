import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/widgets/general_widgets.dart';
import '../controllers/subscription_controllers.dart';
import '../widgets/invoice_card.dart';

class BillingScreen extends ConsumerStatefulWidget {
  const BillingScreen({super.key});

  @override
  ConsumerState<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends ConsumerState<BillingScreen> {
  final _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    if (_couponController.text.isEmpty) return;
    ref.read(billingControllerProvider.notifier).applyCouponCode(_couponController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم تطبيق كوبون التخفيض بنجاح!')),
    );
    _couponController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final billingAsync = ref.watch(billingControllerProvider);
    final invoicesAsync = ref.watch(billingInvoicesControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Text(
            'المركز المالي والفوترة',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.onSurface),
          ),
          centerTitle: true,
        ),
        body: Material(
          color: const Color(0xFFF8F9FF),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Billing Card
                billingAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('خطأ: $e')),
                  data: (billing) {
                    final double subtotal = billing.currentBill - billing.discount;
                    final double total = subtotal + billing.tax;

                    return Container(
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
                            'ملخص الرسوم والمستحقات القادمة',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                          ),
                          const Divider(height: 20, color: AppColors.outlineVariant),
                          _buildPriceRow('قيمة اشتراك الباقة', '${billing.currentBill.toStringAsFixed(0)} ر.س'),
                          if (billing.discount > 0)
                            _buildPriceRow('كود الخصم المطبق (${billing.couponCode})', '-${billing.discount.toStringAsFixed(0)} ر.س'),
                          _buildPriceRow('الضريبة المضافة (15%)', '${billing.tax.toStringAsFixed(2)} ر.س'),
                          const Divider(color: AppColors.outlineVariant),
                          _buildPriceRow('إجمالي الفاتورة القادمة', '${total.toStringAsFixed(2)} ر.س', isBold: true),
                          const SizedBox(height: 16),

                          // Coupon Field
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: _applyCoupon,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0040E0),
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(80, 48),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                ),
                                child: const Text('تطبيق', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: CustomTextField(
                                  controller: _couponController,
                                  labelText: 'كوبون التخفيض',
                                  hintText: 'أدخل الكود',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          PrimaryButton(
                            text: 'سداد الفاتورة الحالية',
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('تم معالجة وسداد الفاتورة بنجاح عبر بطاقتك المحددة!')),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Invoices list
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => context.push('/subscription/invoices'),
                      child: const Text('عرض الكل', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0040E0))),
                    ),
                    const Text(
                      'الفواتير الأخيرة الصادرة',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                invoicesAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('خطأ: $e'),
                  data: (invoices) {
                    return Column(
                      children: invoices.take(3).map((inv) {
                        return InvoiceCard(
                          invoice: inv,
                          onDownload: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('تم تنزيل الفاتورة ${inv.invoiceNumber} كملف PDF بنجاح!')),
                            );
                          },
                          onShare: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('تمت مشاركة رابط الفاتورة ${inv.invoiceNumber} بنجاح!')),
                            );
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isBold = false}) {
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
              color: isBold ? const Color(0xFF0040E0) : AppColors.onSurface,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
