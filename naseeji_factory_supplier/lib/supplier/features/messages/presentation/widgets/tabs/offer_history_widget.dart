import 'package:flutter/material.dart';
import 'package:naseeji_factory/supplier/features/messages/domain/entities/deal_quotation_model.dart';
import 'negotiation_card_widget.dart';

class OfferHistoryWidget extends StatefulWidget {
  final List<DealQuotationModel> quotationHistory;

  const OfferHistoryWidget({
    super.key,
    required this.quotationHistory,
  });

  @override
  State<OfferHistoryWidget> createState() => _OfferHistoryWidgetState();
}

class _OfferHistoryWidgetState extends State<OfferHistoryWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (widget.quotationHistory.length <= 1) {
      return const SizedBox.shrink();
    }

    final previousVersions = widget.quotationHistory.sublist(0, widget.quotationHistory.length - 1).reversed.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.history_rounded, size: 16, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'سجل الإصدارات والتعديلات السابقة (${previousVersions.length} إصدار سليم)',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                Icon(
                  _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),

        if (_isExpanded) ...[
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: previousVersions.length,
            itemBuilder: (context, index) {
              final item = previousVersions[index];
              return NegotiationCardWidget(
                quotation: item,
                isLatest: false,
              );
            },
          ),
        ],
      ],
    );
  }
}



