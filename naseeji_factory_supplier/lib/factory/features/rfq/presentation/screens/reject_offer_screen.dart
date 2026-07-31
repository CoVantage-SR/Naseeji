// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/quotations_provider.dart';
import '../widgets/reject_offer_widgets.dart';

class RejectOfferScreen extends ConsumerStatefulWidget {
  final String quoteId;

  const RejectOfferScreen({super.key, required this.quoteId});

  @override
  ConsumerState<RejectOfferScreen> createState() => _RejectOfferScreenState();
}

class _RejectOfferScreenState extends ConsumerState<RejectOfferScreen> {
  final _commentController = TextEditingController();
  String _selectedReason = 'ارتفاع السعر المعروض (High Price)';

  final List<String> _rejectionReasons = const [
    'ارتفاع السعر المعروض (High Price)',
    'طول مدة التوصيل وتجهيز الطلب (Long Delivery Time)',
    'عدم مطابقة مواصفات الجودة المطلوبة (Low Quality)',
    'تم اختيار مورد بديل بنجاح (Selected Another Supplier)',
    'أسباب أخرى فنية أو لوجستية (Other)',
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitRejection() {
    ref.read(quotationsNotifierProvider.notifier).rejectQuotation(
          widget.quoteId,
          _selectedReason,
          _commentController.text.trim(),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم رفض عرض السعر المقدم وتحديث سجل الطلبات.')),
    );

    context.go('/rfq'); // Return to main RFQs list
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
        title: const Text('رفض عرض المورد'),
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
              RejectionHeaderWidget(supplierName: quotation.supplierName),
              AppSpacing.hMD,
              // Reason Selector Card
              PrimaryCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'أسباب الرفض الرئيسية',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
                    ),
                    const SizedBox(height: 8),
                    for (final reason in _rejectionReasons)
                      RadioListTile<String>(
                        title: Text(reason, style: const TextStyle(fontSize: 12)),
                        value: reason,
                        groupValue: _selectedReason,
                        activeColor: AppColors.primary,
                        onChanged: (val) => setState(() => _selectedReason = val ?? ''),
                        contentPadding: EdgeInsets.zero,
                      ),
                  ],
                ),
              ),
              AppSpacing.hMD,
              // Comments Field
              TextField(
                controller: _commentController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'تفاصيل وملاحظات إضافية (اختياري)',
                  hintText: 'اكتب هنا أي تفاصيل أو شروط خاصة لم يتم استيفاؤها لتوضيح سبب الرفض للمورد...',
                  prefixIcon: Icon(Icons.rate_review_outlined),
                ),
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
                      onPressed: _submitRejection,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                      ),
                      child: const Text('تأكيد رفض عرض السعر'),
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
}



