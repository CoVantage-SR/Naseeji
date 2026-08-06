import 'package:flutter/foundation.dart';
import 'credit_transaction.dart';
import 'credit_purchase_history.dart';

@immutable
class SupplierCredits {
  final String supplierId;
  final bool welcomeCreditsGranted;
  final int creditsBalance;
  final String blueVerificationStatus; // 'none', 'pending', 'approved', 'rejected'
  final DateTime? verificationDate;
  final String? verificationRequest;
  final List<CreditTransaction> transactions;
  final List<CreditPurchaseHistory> purchaseHistory;

  const SupplierCredits({
    this.supplierId = 'sup_1',
    this.welcomeCreditsGranted = true,
    this.creditsBalance = 50,
    this.blueVerificationStatus = 'approved',
    this.verificationDate,
    this.verificationRequest,
    this.transactions = const [],
    this.purchaseHistory = const [],
  });

  bool get isBlueVerified => blueVerificationStatus == 'approved';
  bool get isBluePending => blueVerificationStatus == 'pending';

  bool hasEnoughCredits(int required) => creditsBalance >= required;

  SupplierCredits copyWith({
    String? supplierId,
    bool? welcomeCreditsGranted,
    int? creditsBalance,
    String? blueVerificationStatus,
    DateTime? verificationDate,
    String? verificationRequest,
    List<CreditTransaction>? transactions,
    List<CreditPurchaseHistory>? purchaseHistory,
  }) {
    return SupplierCredits(
      supplierId: supplierId ?? this.supplierId,
      welcomeCreditsGranted: welcomeCreditsGranted ?? this.welcomeCreditsGranted,
      creditsBalance: creditsBalance ?? this.creditsBalance,
      blueVerificationStatus: blueVerificationStatus ?? this.blueVerificationStatus,
      verificationDate: verificationDate ?? this.verificationDate,
      verificationRequest: verificationRequest ?? this.verificationRequest,
      transactions: transactions ?? this.transactions,
      purchaseHistory: purchaseHistory ?? this.purchaseHistory,
    );
  }
}
