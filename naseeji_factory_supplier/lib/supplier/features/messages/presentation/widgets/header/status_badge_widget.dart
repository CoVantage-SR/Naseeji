import 'package:flutter/material.dart';
import 'package:naseeji_factory/supplier/features/messages/domain/entities/deal_status_enum.dart';

class StatusBadgeWidget extends StatelessWidget {
  final DealStatus status;

  const StatusBadgeWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData icon;

    switch (status) {
      case DealStatus.newRfq:
        bg = Colors.amber.shade50;
        fg = Colors.amber.shade900;
        icon = Icons.new_releases_outlined;
        break;
      case DealStatus.negotiating:
        bg = Colors.orange.shade50;
        fg = Colors.orange.shade900;
        icon = Icons.handshake_outlined;
        break;
      case DealStatus.awaitingResponse:
        bg = Colors.blue.shade50;
        fg = Colors.blue.shade900;
        icon = Icons.mark_unread_chat_alt_outlined;
        break;
      case DealStatus.agreed:
        bg = Colors.green.shade50;
        fg = Colors.green.shade900;
        icon = Icons.task_alt_rounded;
        break;
      case DealStatus.inProduction:
        bg = Colors.purple.shade50;
        fg = Colors.purple.shade900;
        icon = Icons.precision_manufacturing_outlined;
        break;
      case DealStatus.readyForShipment:
        bg = Colors.teal.shade50;
        fg = Colors.teal.shade900;
        icon = Icons.local_shipping_outlined;
        break;
      case DealStatus.delivering:
        bg = Colors.indigo.shade50;
        fg = Colors.indigo.shade900;
        icon = Icons.drive_eta_outlined;
        break;
      case DealStatus.qualityInspection:
        bg = Colors.yellow.shade100;
        fg = Colors.yellow.shade900;
        icon = Icons.biotech_outlined;
        break;
      case DealStatus.paymentPending:
        bg = Colors.lightGreen.shade50;
        fg = Colors.lightGreen.shade900;
        icon = Icons.payments_outlined;
        break;
      case DealStatus.completed:
        bg = Colors.green.shade50;
        fg = Colors.green.shade900;
        icon = Icons.verified_rounded;
        break;
      case DealStatus.cancelled:
      case DealStatus.rejected:
      case DealStatus.expired:
        bg = Colors.red.shade50;
        fg = Colors.red.shade900;
        icon = Icons.cancel_outlined;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: fg.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 4),
          Text(
            status.arabicLabel,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: fg),
          ),
        ],
      ),
    );
  }
}

