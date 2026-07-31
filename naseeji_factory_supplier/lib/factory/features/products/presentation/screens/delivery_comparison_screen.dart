import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/comparison_provider.dart';
import '../widgets/delivery_comparison_widgets.dart';

class DeliveryComparisonScreen extends ConsumerWidget {
  const DeliveryComparisonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveryItems = ref.watch(deliveryComparisonItemsProvider);

    // Find fastest offer (lowest totalEstimatedTime)
    DeliveryComparisonItem? fastestItem;
    if (deliveryItems.isNotEmpty) {
      fastestItem = deliveryItems.reduce((a, b) => a.totalEstimatedTime < b.totalEstimatedTime ? a : b);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('مقارنة مواعيد الشحن'),
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
                    'مقارنة سرعة التوصيل وجدول التسليم',
                    style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'الجدول يوضح زمن تجهيز المواد الخام في مخازن المورد وزمن الشحن الكلي المتوقع للوصول.',
                    style: context.textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: deliveryItems.isEmpty
                  ? const Center(child: Text('لا توجد بيانات مقارنة شحن حالياً.'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: deliveryItems.length,
                      separatorBuilder: (context, index) => AppSpacing.hMD,
                      itemBuilder: (context, index) {
                        final item = deliveryItems[index];
                        final isFastest = fastestItem?.supplierId == item.supplierId;

                        return DeliveryCardWidget(
                          item: item,
                          isFastest: isFastest,
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



