import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/quotations_provider.dart';
import '../widgets/received_quotations_widgets.dart';

class ReceivedQuotationsScreen extends ConsumerStatefulWidget {
  final String rfqId;

  const ReceivedQuotationsScreen({super.key, required this.rfqId});

  @override
  ConsumerState<ReceivedQuotationsScreen> createState() => _ReceivedQuotationsScreenState();
}

class _ReceivedQuotationsScreenState extends ConsumerState<ReceivedQuotationsScreen> {
  String _activeSort = 'price';

  @override
  Widget build(BuildContext context) {
    final quotations = ref.watch(quotationsNotifierProvider.notifier).getQuotationsForRFQ(widget.rfqId);
    final selectedIdsForCompare = ref.watch(selectedQuotesComparisonProvider);
    final comparisonNotifier = ref.read(selectedQuotesComparisonProvider.notifier);

    // Apply Sorting
    var sortedQuotes = List<Quotation>.from(quotations);
    if (_activeSort == 'price') {
      sortedQuotes.sort((a, b) => a.quotedPricePerUnit.compareTo(b.quotedPricePerUnit));
    } else if (_activeSort == 'delivery') {
      sortedQuotes.sort((a, b) => (a.prepTimeDays + a.shippingTimeDays).compareTo(b.prepTimeDays + b.shippingTimeDays));
    } else if (_activeSort == 'rating') {
      sortedQuotes.sort((a, b) => b.supplierRating.compareTo(a.supplierRating));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('العروض المستلمة'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (selectedIdsForCompare.isNotEmpty)
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.compare_arrows_rounded),
                  tooltip: 'مقارنة العروض المحددة',
                  onPressed: () => context.push('/rfq/${widget.rfqId}/compare-quotations'),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                    child: Text(
                      selectedIdsForCompare.length.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'عروض الأسعار المتاحة لطلبك المالي',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'قم باختيار عرض وتأكيده للتحويل لأمر شراء، أو قارن العروض لتحديد الأفضل.',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                  ),
                ],
              ),
            ),
            SortWidget(
              activeSort: _activeSort,
              onSortChanged: (sort) {
                setState(() {
                  _activeSort = sort;
                });
              },
            ),
            const Divider(height: 16),
            Expanded(
              child: sortedQuotes.isEmpty
                  ? const Center(child: Text('لم يتم استلام أي عروض أسعار لهذا الطلب بعد.'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: sortedQuotes.length,
                      separatorBuilder: (context, index) => AppSpacing.hMD,
                      itemBuilder: (context, index) {
                        final quote = sortedQuotes[index];
                        final isCompared = selectedIdsForCompare.contains(quote.id);

                        return QuotationCardWidget(
                          quotation: quote,
                          isSelectedForComparison: isCompared,
                          onCompareToggle: () {
                            if (!isCompared && selectedIdsForCompare.length >= 3) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('الحد الأقصى للمقارنة هو ٣ عروض أسعار فقط!')),
                              );
                              return;
                            }
                            comparisonNotifier.toggleComparison(quote.id);
                          },
                          onViewDetails: () => context.push('/rfq/quotation/${quote.id}'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}


