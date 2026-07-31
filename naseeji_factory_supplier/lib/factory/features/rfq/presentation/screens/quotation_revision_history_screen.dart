import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/quotations_provider.dart';
import '../widgets/quotation_revision_history_widgets.dart';

class QuotationRevisionHistoryScreen extends ConsumerWidget {
  final String quoteId;

  const QuotationRevisionHistoryScreen({super.key, required this.quoteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotation = ref.watch(quotationsNotifierProvider.notifier).getQuotationById(quoteId);

    if (quotation == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('عرض السعر غير موجود.')),
      );
    }

    final revisions = quotation.revisions.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل المراجعات والمفاوضات'),
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
                    'تاريخ التعديلات المتبادلة لعرض ${quotation.supplierName}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'تاريخ تفاوض الأسعار والكميات والملاحظات المقترحة بين المصنع والمورد.',
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: revisions.isEmpty
                  ? const Center(child: Text('لا توجد مراجعات سابقة مسجلة.'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: revisions.length,
                      separatorBuilder: (context, index) => AppSpacing.hMD,
                      itemBuilder: (context, index) {
                        final rev = revisions[index];
                        return RevisionCardWidget(revision: rev);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}


