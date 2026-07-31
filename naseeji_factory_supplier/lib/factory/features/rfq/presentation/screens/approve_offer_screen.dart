import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quotations_provider.dart';
import '../widgets/approve_offer/approve_offer_form.dart';

class ApproveOfferScreen extends ConsumerWidget {
  final String quoteId;

  const ApproveOfferScreen({super.key, required this.quoteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotation = ref.watch(quotationsNotifierProvider.notifier).getQuotationById(quoteId);

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
        child: ApproveOfferForm(quotation: quotation),
      ),
    );
  }
}

