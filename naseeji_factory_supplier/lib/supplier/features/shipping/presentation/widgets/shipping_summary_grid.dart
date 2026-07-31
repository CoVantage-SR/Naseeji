import 'package:flutter/material.dart';
import '../../domain/entities/shipment.dart';
import 'shipping_summary_card.dart';

class ShippingSummaryGrid extends StatelessWidget {
  final List<Shipment> shipments;

  const ShippingSummaryGrid({super.key, required this.shipments});

  @override
  Widget build(BuildContext context) {
    final pending = shipments.where((s) => s.status == ShipmentStatus.ready).length;
    final ready = shipments.where((s) => s.status == ShipmentStatus.loaded).length;
    final transit = shipments.where((s) => s.status == ShipmentStatus.pickedUp || s.status == ShipmentStatus.inTransit || s.status == ShipmentStatus.arrived).length;
    final delivered = shipments.where((s) => s.status == ShipmentStatus.delivered || s.status == ShipmentStatus.paymentPending || s.status == ShipmentStatus.completed).length;
    final delayed = shipments.where((s) => s.issueReported != null && s.status != ShipmentStatus.completed).length;
    const cancelled = 0; // Mock count

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1.55,
      children: [
        ShippingSummaryCard(label: 'معلقة شحن', value: '$pending', color: Colors.blue),
        ShippingSummaryCard(label: 'جاهزة للتحميل', value: '$ready', color: Colors.indigo),
        ShippingSummaryCard(label: 'في الطريق', value: '$transit', color: Colors.orange),
        ShippingSummaryCard(label: 'تم تسليمها', value: '$delivered', color: Colors.green),
        ShippingSummaryCard(label: 'تأخير وبلاغات', value: '$delayed', color: Colors.red),
        ShippingSummaryCard(label: 'ملغية', value: '$cancelled', color: Colors.grey),
      ],
    );
  }
}


