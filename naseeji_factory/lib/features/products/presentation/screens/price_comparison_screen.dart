import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/comparison_provider.dart';
import '../widgets/price_comparison_widgets.dart';

class PriceComparisonScreen extends ConsumerWidget {
  const PriceComparisonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotations = ref.watch(priceQuotationsProvider);

    // Find best offer (lowest finalPrice)
    PriceQuotation? bestOffer;
    if (quotations.isNotEmpty) {
      bestOffer = quotations.reduce((a, b) => a.finalPrice < b.finalPrice ? a : b);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('مقارنة الأسعار والعروض'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'مقارنة التكلفة وعروض الأسعار المستلمة',
                    style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'الأسعار النهائية تشمل خصومات المورد وتكاليف الشحن الموزعة على الحد الأدنى للطلب.',
                    style: context.textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: quotations.isEmpty
                  ? const Center(child: Text('لا توجد عروض أسعار مقارنة حالياً.'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: quotations.length,
                      separatorBuilder: (context, index) => AppSpacing.hMD,
                      itemBuilder: (context, index) {
                        final quote = quotations[index];
                        final isBest = bestOffer?.supplierId == quote.supplierId;

                        return QuotationCardWidget(
                          quotation: quote,
                          isBestOffer: isBest,
                          onChoose: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('تم اختيار عرض ${quote.supplierName} لإنشاء الفاتورة للإنتاج.'),
                              ),
                            );
                            context.push('/request-product?id=prod_1');
                          },
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
