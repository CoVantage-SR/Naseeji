import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/quotations_provider.dart';
import '../widgets/quotations_comparison_widgets.dart';

class QuotationsComparisonScreen extends ConsumerWidget {
  final String rfqId;

  const QuotationsComparisonScreen({super.key, required this.rfqId});

  void _showAddQuotationDialog(
    BuildContext context,
    WidgetRef ref,
    List<Quotation> quotations,
    List<String> currentIds,
  ) {
    final available = quotations.where((q) => !currentIds.contains(q.id)).toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          alignment: Alignment.center,
          title: const Text('أضف عرض سعر للمقارنة', style: TextStyle(fontWeight: FontWeight.bold)),
          content: available.isEmpty
              ? const Text('جميع عروض الأسعار المستلمة مضافة بالفعل للمقارنة.')
              : SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: available.length,
                    itemBuilder: (context, index) {
                      final quote = available[index];
                      return ListTile(
                        leading: SupplierAvatar(name: quote.supplierName, size: 32),
                        title: Text(quote.supplierName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        subtitle: Text('${quote.quotedPricePerUnit.toInt()} ج.م / وحدة', style: const TextStyle(fontSize: 10)),
                        onTap: () {
                          ref.read(selectedQuotesComparisonProvider.notifier).toggleComparison(quote.id);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('تراجع'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIds = ref.watch(selectedQuotesComparisonProvider);
    final allQuotations = ref.watch(quotationsNotifierProvider.notifier).getQuotationsForRFQ(rfqId);
    final notifier = ref.read(selectedQuotesComparisonProvider.notifier);

    final selectedQuotes = selectedIds
        .map((id) => allQuotations.firstWhere((q) => q.id == id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('مقارنة عروض الأسعار'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (selectedIds.isNotEmpty)
            TextButton(
              onPressed: () => notifier.clear(),
              child: const Text('مسح الكل', style: TextStyle(color: AppColors.error)),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top comparison slots
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Theme.of(context).cardColor,
              child: Row(
                children: [
                  for (int i = 0; i < 3; i++)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: i < selectedQuotes.length
                            ? ComparisonCardWidget(
                                quotation: selectedQuotes[i],
                                onRemove: () => notifier.toggleComparison(selectedQuotes[i].id),
                              )
                            : ChooseQuotationButtonWidget(
                                onTap: () => _showAddQuotationDialog(context, ref, allQuotations, selectedIds),
                              ),
                      ),
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Comparison Table
            Expanded(
              child: selectedQuotes.isEmpty
                  ? const EmptyState(
                      icon: Icons.compare_arrows_rounded,
                      title: 'ابدأ مقارنة العروض الفنية',
                      description: 'قم بإضافة عرضين على الأقل للمقارنة المباشرة بين الأسعار وفترات التسليم والالتزامات.',
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ComparisonRowWidget(
                            label: 'السعر للوحدة',
                            values: selectedQuotes.map((q) => '${q.quotedPricePerUnit.toInt()} ج.م').toList(),
                            highlightBest: selectedQuotes.map((q) => q.quotedPricePerUnit == selectedQuotes.map((q) => q.quotedPricePerUnit).reduce((a, b) => a < b ? a : b)).toList(),
                          ),
                          ComparisonRowWidget(
                            label: 'الحد الأدنى (MOQ)',
                            values: selectedQuotes.map((q) => '${q.moq} وحدة').toList(),
                          ),
                          ComparisonRowWidget(
                            label: 'زمن التجهيز بالمخازن',
                            values: selectedQuotes.map((q) => '${q.prepTimeDays} أيام').toList(),
                          ),
                          ComparisonRowWidget(
                            label: 'زمن الشحن والتوصيل',
                            values: selectedQuotes.map((q) => '${q.shippingTimeDays} أيام').toList(),
                          ),
                          ComparisonRowWidget(
                            label: 'ضمان الجودة والنعومة',
                            values: selectedQuotes.map((q) => q.warranty.split(' ')[0]).toList(),
                          ),
                          ComparisonRowWidget(
                            label: 'تقييم المورد العام',
                            values: selectedQuotes.map((q) => '${q.supplierRating} ⭐').toList(),
                            highlightBest: selectedQuotes.map((q) => q.supplierRating == selectedQuotes.map((q) => q.supplierRating).reduce((a, b) => a > b ? a : b)).toList(),
                          ),
                          ComparisonRowWidget(
                            label: 'تاريخ تقديم العرض',
                            values: selectedQuotes.map((q) => q.offerDate).toList(),
                          ),
                          AppSpacing.hLG,
                          Row(
                            children: [
                              for (int i = 0; i < selectedQuotes.length; i++)
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: ElevatedButton(
                                      onPressed: () => context.push('/rfq/quotation/${selectedQuotes[i].id}'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                                      ),
                                      child: const Text('اختيار والطلب', style: TextStyle(fontSize: 10)),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
