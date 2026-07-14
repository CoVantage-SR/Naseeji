import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/quotations_provider.dart';
import '../widgets/quotation_details_widgets.dart';

class QuotationDetailsScreen extends ConsumerWidget {
  final String quoteId;

  const QuotationDetailsScreen({super.key, required this.quoteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotation = ref.watch(quotationsNotifierProvider.notifier).getQuotationById(quoteId);
    final isDark = context.theme.brightness == Brightness.dark;

    if (quotation == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('عرض السعر غير موجود.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('عرض السعر الفني'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: 'تاريخ المفاوضات والنسخ السابقة',
            onPressed: () => context.push('/rfq/quotation/${quotation.id}/revisions'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Supplier Profile Preview Header
              Row(
                children: [
                  SupplierAvatar(name: quotation.supplierName, size: 50),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quotation.supplierName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          'تاريخ العرض: ${quotation.offerDate}',
                          style: const TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              AppSpacing.hMD,
              PriceInformationWidget(quotation: quotation),
              AppSpacing.hMD,
              DeliveryInformationWidget(quotation: quotation),
              AppSpacing.hMD,
              PaymentInformationWidget(quotation: quotation),
              AppSpacing.hMD,
              // Supplier Notes
              PrimaryCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ملاحظات المورد الإضافية',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      quotation.supplierNotes,
                      style: const TextStyle(fontSize: 12, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Revision Logs Banner link if available
              if (quotation.revisions.length > 1) ...[
                InkWell(
                  onTap: () => context.push('/rfq/quotation/${quotation.id}/revisions'),
                  borderRadius: AppRadius.rMD,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.05),
                      borderRadius: AppRadius.rMD,
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.history_rounded, color: AppColors.primary, size: 20),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'تم التفاوض على هذا العرض سابقاً. اضغط لعرض التعديلات السابقة.',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              // Action Buttons
              if (quotation.status == 'received' || quotation.status == 'negotiating') ...[
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.push('/rfq/quotation/${quotation.id}/reject'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: AppColors.error),
                          foregroundColor: AppColors.error,
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                        ),
                        child: const Text('رفض العرض'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.push('/rfq/quotation/${quotation.id}/counter'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: AppColors.primary),
                          foregroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                        ),
                        child: const Text('تقديم عرض بديل / تفاوض'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => context.push('/rfq/quotation/${quotation.id}/approve'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                        ),
                        child: const Text('قبول العرض'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
