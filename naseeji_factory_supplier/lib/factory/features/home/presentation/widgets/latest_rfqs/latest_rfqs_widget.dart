import 'package:flutter/material.dart';
import '../../../domain/entities/home_entities.dart';
import '../common/section_header_widget.dart';
import 'rfq_card_widget.dart';

class LatestRFQsWidget extends StatelessWidget {
  final List<LatestRFQ> rfqs;
  final VoidCallback? onHeaderActionTap;
  final ValueChanged<LatestRFQ> onViewRfq;
  final ValueChanged<LatestRFQ> onContinueRfq;

  const LatestRFQsWidget({
    super.key,
    required this.rfqs,
    required this.onViewRfq,
    required this.onContinueRfq,
    this.onHeaderActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderWidget(
          title: 'آخر طلبات عروض الأسعار (RFQs)',
          onActionTap: onHeaderActionTap,
        ),
        const SizedBox(height: 12),
        if (rfqs.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text('لا توجد طلبات عروض أسعار جديدة حالياً.'),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rfqs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final rfq = rfqs[index];
              return RFQCardWidget(
                rfq: rfq,
                onViewTap: () => onViewRfq(rfq),
                onContinueTap: () => onContinueRfq(rfq),
              );
            },
          ),
      ],
    );
  }
}



