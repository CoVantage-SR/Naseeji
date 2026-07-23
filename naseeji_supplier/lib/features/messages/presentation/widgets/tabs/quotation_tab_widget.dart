import 'package:flutter/material.dart';
import 'package:naseeji_supplier/features/messages/domain/entities/deal_quotation_model.dart';
import 'negotiation_tab_widget.dart';

class QuotationTabWidget extends StatelessWidget {
  final DealQuotationModel quotation;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onCounterOffer;

  const QuotationTabWidget({
    super.key,
    required this.quotation,
    required this.onAccept,
    required this.onReject,
    required this.onCounterOffer,
  });

  @override
  Widget build(BuildContext context) {
    return NegotiationTabWidget(
      latestQuotation: quotation,
      quotationHistory: [quotation],
      onAccept: onAccept,
      onReject: onReject,
      onSubmitNewVersion: ({
        required double unitPrice,
        required int quantity,
        required String productionLeadTime,
        required String validityPeriod,
        required String paymentTerms,
        required String deliveryTerms,
        DateTime? expectedDeliveryDate,
        String? notes,
      }) {
        onCounterOffer();
      },
    );
  }
}
