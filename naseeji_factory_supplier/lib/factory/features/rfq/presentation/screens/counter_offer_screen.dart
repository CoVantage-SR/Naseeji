import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quotations_provider.dart';
import '../widgets/counter_offer/counter_offer_form.dart';

class CounterOfferScreen extends ConsumerWidget {
  final String quoteId;

  const CounterOfferScreen({super.key, required this.quoteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotation = ref.watch(quotationsNotifierProvider.notifier).getQuotationById(quoteId);

    if (quotation == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('العرض غير موجود.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('تقديم عرض سعر بديل (Counter Offer)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: CounterOfferForm(quotation: quotation),
      ),
    );
  }
}

