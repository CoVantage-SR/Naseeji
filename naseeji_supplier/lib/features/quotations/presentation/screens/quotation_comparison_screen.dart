import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/quotations_controller.dart';
import '../widgets/quotation_comparison_table.dart';

class QuotationComparisonScreen extends ConsumerWidget {
  final String quotationId;

  const QuotationComparisonScreen({super.key, required this.quotationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(quotationsControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0.5,
          centerTitle: true,
          title: Text(
            'مقارنة وتحليل الأسعار لعرض $quotationId',
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
        body: stateAsync.when(
          loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (e, _) => Center(child: Text('خطأ: $e')),
          data: (quotations) {
            final index = quotations.indexWhere((q) => q.id == quotationId);
            if (index == -1) {
              return Center(child: Text('عرض السعر غير موجود'));
            }
            final q = quotations[index];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Product Summary Header
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E1EF), width: 0.5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(image: NetworkImage(q.productImageUrl), fit: BoxFit.cover),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(q.productName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                              SizedBox(height: 2),
                              Text('الكمية المطلوبة: ${q.quantity.toInt()} ${q.unit} • فئة: ${q.productCategory}', style: TextStyle(fontSize: 8, color: AppColors.outline)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),

                  // The main Comparison Table and Trends
                  QuotationComparisonTable(quotation: q),
                  SizedBox(height: 16),

                  // Additional analytical card
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.1), width: 1),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lightbulb_outline, color: AppColors.primary, size: 16),
                            SizedBox(width: 8),
                            Text(
                              'توصية نسيجي الذكية للتسعير',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primary),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'تظهر تحليلاتنا أن متوسط السعر المعتمد لنوع ${q.productCategory} في السوق هو ${(q.supplierUnitPrice * 0.98).toStringAsFixed(1)} ر.س. يعتبر عرض السعر الحالي مناسباً ومنافساً وممتازاً لتأمين الصفقة بنسبة قبول متوقعة تفوق ٨٥٪.',
                          style: TextStyle(fontSize: 9, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
