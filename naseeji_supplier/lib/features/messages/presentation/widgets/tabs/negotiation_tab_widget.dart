import 'package:flutter/material.dart';
import 'package:naseeji_supplier/features/messages/domain/entities/deal_quotation_model.dart';
import 'negotiation_card_widget.dart';
import 'offer_history_widget.dart';
import 'request_modification_bottom_sheet.dart';

class NegotiationTabWidget extends StatelessWidget {
  final DealQuotationModel latestQuotation;
  final List<DealQuotationModel> quotationHistory;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final Function({
    required double unitPrice,
    required int quantity,
    required String productionLeadTime,
    required String validityPeriod,
    required String paymentTerms,
    required String deliveryTerms,
    DateTime? expectedDeliveryDate,
    String? notes,
  }) onSubmitNewVersion;

  const NegotiationTabWidget({
    super.key,
    required this.latestQuotation,
    required this.quotationHistory,
    required this.onAccept,
    required this.onReject,
    required this.onSubmitNewVersion,
  });

  void _showModificationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => RequestModificationBottomSheet(
        currentQuotation: latestQuotation,
        onSubmitNewVersion: onSubmitNewVersion,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Title
          Row(
            children: [
              Icon(Icons.handshake_outlined, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'مركز إدارة المفاوضات وعروض الأسعار',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.5,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _showModificationBottomSheet(context),
                icon: const Icon(Icons.add_circle_outline, size: 14),
                label: const Text('إصدار جديد', style: TextStyle(fontSize: 11)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  minimumSize: const Size(0, 32),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Current Latest Offer Card
          NegotiationCardWidget(
            quotation: latestQuotation,
            isLatest: true,
            onAccept: onAccept,
            onReject: onReject,
            onRequestModification: () => _showModificationBottomSheet(context),
          ),

          // Version History (Previous Versions)
          OfferHistoryWidget(quotationHistory: quotationHistory),
        ],
      ),
    );
  }
}
