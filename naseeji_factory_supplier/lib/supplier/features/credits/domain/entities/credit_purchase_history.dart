import 'package:flutter/foundation.dart';

@immutable
class CreditPurchaseHistory {
  final String id;
  final String supplierId;
  final String packageId;
  final String packageName;
  final int credits;
  final double amountPaid;
  final String currency;
  final String paymentStatus; // 'completed', 'pending', 'failed'
  final DateTime purchasedAt;

  const CreditPurchaseHistory({
    required this.id,
    required this.supplierId,
    required this.packageId,
    required this.packageName,
    required this.credits,
    required this.amountPaid,
    this.currency = 'ج.م',
    required this.paymentStatus,
    required this.purchasedAt,
  });
}
