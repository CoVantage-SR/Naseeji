import 'package:flutter/material.dart';

enum QuotationStatusType {
  sent, // تم الإرسال
  awaitingResponse, // بانتظار الرد
  negotiating, // قيد التفاوض
  accepted, // تم قبول العرض
  rejected, // تم رفض العرض
  counterOfferSent, // تم إرسال عرض مضاد
}

extension QuotationStatusTypeExtension on QuotationStatusType {
  String get arabicLabel {
    switch (this) {
      case QuotationStatusType.sent:
        return 'تم الإرسال';
      case QuotationStatusType.awaitingResponse:
        return 'بانتظار الرد';
      case QuotationStatusType.negotiating:
        return 'قيد التفاوض';
      case QuotationStatusType.accepted:
        return 'تم قبول العرض';
      case QuotationStatusType.rejected:
        return 'تم رفض العرض';
      case QuotationStatusType.counterOfferSent:
        return 'تم إرسال عرض مضاد';
    }
  }
}

class QuotationStatusBadgeWidget extends StatelessWidget {
  final QuotationStatusType status;

  const QuotationStatusBadgeWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData icon;

    switch (status) {
      case QuotationStatusType.sent:
        bg = Colors.blue.shade50;
        fg = Colors.blue.shade900;
        icon = Icons.send_rounded;
        break;
      case QuotationStatusType.awaitingResponse:
        bg = Colors.amber.shade50;
        fg = Colors.amber.shade900;
        icon = Icons.hourglass_top_rounded;
        break;
      case QuotationStatusType.negotiating:
        bg = Colors.orange.shade50;
        fg = Colors.orange.shade900;
        icon = Icons.handshake_outlined;
        break;
      case QuotationStatusType.accepted:
        bg = Colors.green.shade50;
        fg = Colors.green.shade900;
        icon = Icons.check_circle_rounded;
        break;
      case QuotationStatusType.rejected:
        bg = Colors.red.shade50;
        fg = Colors.red.shade900;
        icon = Icons.cancel_rounded;
        break;
      case QuotationStatusType.counterOfferSent:
        bg = Colors.purple.shade50;
        fg = Colors.purple.shade900;
        icon = Icons.swap_horiz_rounded;
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


