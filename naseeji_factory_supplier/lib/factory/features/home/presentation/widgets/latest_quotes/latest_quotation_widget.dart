import 'package:flutter/material.dart';
import '../../../domain/entities/home_entities.dart';
import '../common/section_header_widget.dart';
import 'quotation_card_widget.dart';

class LatestQuotationWidget extends StatelessWidget {
  final List<LatestQuotation> quotations;
  final VoidCallback? onHeaderActionTap;
  final ValueChanged<LatestQuotation> onCompareQuotation;
  final ValueChanged<LatestQuotation> onApproveQuotation;
  final ValueChanged<LatestQuotation> onRejectQuotation;

  const LatestQuotationWidget({
    super.key,
    required this.quotations,
    required this.onCompareQuotation,
    required this.onApproveQuotation,
    required this.onRejectQuotation,
    this.onHeaderActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderWidget(
          title: 'آخر العروض المستلمة',
          onActionTap: onHeaderActionTap,
        ),
        const SizedBox(height: 12),
        if (quotations.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text('لا توجد عروض أسعار جديدة مستلمة حالياً.'),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: quotations.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final quote = quotations[index];
              return QuotationCardWidget(
                quotation: quote,
                onCompareTap: () => onCompareQuotation(quote),
                onApproveTap: () => onApproveQuotation(quote),
                onRejectTap: () => onRejectQuotation(quote),
              );
            },
          ),
      ],
    );
  }
}


