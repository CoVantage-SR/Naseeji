import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/quotations_provider.dart';
import '../providers/rfq_provider.dart';
import '../widgets/approve_offer_widgets.dart';

class ApproveOfferScreen extends ConsumerStatefulWidget {
  final String quoteId;

  const ApproveOfferScreen({super.key, required this.quoteId});

  @override
  ConsumerState<ApproveOfferScreen> createState() => _ApproveOfferScreenState();
}

class _ApproveOfferScreenState extends ConsumerState<ApproveOfferScreen> {
  bool _agreeToTerms = false;

  void _approveQuotation(Quotation quote) {
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى الموافقة على الشروط والأحكام أولاً لمتابعة الاعتماد.')),
      );
      return;
    }

    ref.read(quotationsNotifierProvider.notifier).acceptQuotation(quote.id);
    ref.read(rFQNotifierProvider.notifier).updateRFQStatus(quote.rfqId, 'approved');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          alignment: Alignment.center,
          icon: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 52),
          title: const Text('تم اعتماد العرض بنجاح!'),
          content: Text(
            'لقد قمت بقبول عرض المورد "${quote.supplierName}".\n\n'
            'تم تحويل طلب عرض السعر هذا تلقائياً إلى أمر شراء رسمي برقم:\n'
            'PO-2026-${quote.id.split('-').last}\n\n'
            'سيمر الطلب لخطوات التوريد والتحضير، وسيتم إخطار المورد فوراً لتأكيد الاستلام.',
            textAlign: TextAlign.center,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                context.go('/rfq'); // Return to main RFQ screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
              ),
              child: const Text('الرجوع لطلبات التوريد'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final quotation = ref.watch(quotationsNotifierProvider.notifier).getQuotationById(widget.quoteId);

    if (quotation == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('عرض السعر غير موجود.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('مراجعة واعتماد العرض'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Supplier Info Summary Card
              PrimaryCard(
                child: Row(
                  children: [
                    SupplierAvatar(name: quotation.supplierName, size: 40),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quotation.supplierName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Text(
                            'تقييم المورد: ${quotation.supplierRating} ⭐',
                            style: const TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.hMD,
              // Financial cost totals card
              GrandTotalCardWidget(
                pricePerUnit: quotation.quotedPricePerUnit,
                quantity: 10000, // Dynamic quantity requested from rfq
                shippingCost: 1500.0, // Mock shipping cost
                taxRatePercent: 14.0, // VAT tax rate Egypt
              ),
              AppSpacing.hMD,
              // Terms & Conditions list
              PrimaryCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'شروط التسوية والتوصيل النهائية',
                      style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    const Divider(),
                    const SizedBox(height: 8),
                    _buildConditionRow(Icons.payment_rounded, 'طريقة الدفع', quotation.paymentMethod),
                    const SizedBox(height: 12),
                    _buildConditionRow(Icons.local_shipping_outlined, 'مدة التوصيل الكلية', 'شحن وتجهيز خلال ${quotation.prepTimeDays + quotation.shippingTimeDays} أيام عمل'),
                    const SizedBox(height: 12),
                    _buildConditionRow(Icons.shield_outlined, 'الضمان والتعويضات', quotation.warranty),
                  ],
                ),
              ),
              AppSpacing.hMD,
              // Checkbox and Agreement Text
              CheckboxListTile(
                value: _agreeToTerms,
                onChanged: (val) => setState(() => _agreeToTerms = val ?? false),
                activeColor: AppColors.primary,
                title: const Text(
                  'أقر بموافقتي التامة على الشروط المالية والتسليم الواردة أعلاه والتعامل مع المورد وفق سياسات Naseeji المعتمدة.',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, height: 1.4),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),
              // Action Buttons Row
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
                      onPressed: () => _approveQuotation(quotation),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                      ),
                      child: const Text('تأكيد واعتماد العرض'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConditionRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, height: 1.3)),
            ],
          ),
        ),
      ],
    );
  }
}
