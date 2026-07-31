import 'package:flutter/material.dart';
import '../../../domain/entities/home_entities.dart';
import '../common/section_header_widget.dart';
import 'order_card_widget.dart';

class CurrentOrdersWidget extends StatelessWidget {
  final List<CurrentOrder> orders;
  final VoidCallback? onHeaderActionTap;
  final ValueChanged<CurrentOrder> onTrackOrder;

  const CurrentOrdersWidget({
    super.key,
    required this.orders,
    required this.onTrackOrder,
    this.onHeaderActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderWidget(
          title: 'الطلبات الجارية',
          onActionTap: onHeaderActionTap,
        ),
        const SizedBox(height: 12),
        if (orders.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text('لا توجد طلبات جارية حالياً.'),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orders.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final order = orders[index];
              return OrderCardWidget(
                order: order,
                onTrackTap: () => onTrackOrder(order),
              );
            },
          ),
      ],
    );
  }
}

