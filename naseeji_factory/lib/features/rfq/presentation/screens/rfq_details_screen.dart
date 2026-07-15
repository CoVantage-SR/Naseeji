import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/rfq_provider.dart';
import '../widgets/rfq_details/rfq_details_body.dart';

class RFQDetailsScreen extends ConsumerWidget {
  final String rfqId;

  const RFQDetailsScreen({super.key, required this.rfqId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rfq = ref.watch(rFQNotifierProvider.notifier).getRFQById(rfqId);

    if (rfq == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('طلب عرض السعر غير موجود.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل طلب عرض السعر (RFQ)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تعديل الطلبات متاح للمسودات فقط حالياً.')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: RFQDetailsBody(rfq: rfq),
      ),
    );
  }
}
