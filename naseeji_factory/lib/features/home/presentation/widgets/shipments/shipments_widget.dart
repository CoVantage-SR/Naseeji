import 'package:flutter/material.dart';
import '../../../domain/entities/home_entities.dart';
import '../common/section_header_widget.dart';
import 'shipment_card_widget.dart';

class ShipmentsWidget extends StatelessWidget {
  final List<Shipment> shipments;
  final VoidCallback? onHeaderActionTap;
  final ValueChanged<Shipment> onTrackShipment;

  const ShipmentsWidget({
    super.key,
    required this.shipments,
    required this.onTrackShipment,
    this.onHeaderActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderWidget(
          title: 'شحنات المواد الخام الجارية',
          onActionTap: onHeaderActionTap,
        ),
        const SizedBox(height: 12),
        if (shipments.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text('لا توجد شحنات جارية حالياً.'),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: shipments.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final shipment = shipments[index];
              return ShipmentCardWidget(
                shipment: shipment,
                onTrackTap: () => onTrackShipment(shipment),
              );
            },
          ),
      ],
    );
  }
}
