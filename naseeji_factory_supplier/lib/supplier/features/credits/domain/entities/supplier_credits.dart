import 'package:flutter/foundation.dart';

@immutable
class SupplierCredits {
  final bool welcomeCreditsGranted;
  final int creditsBalance;
  final int freeProductsRemaining;
  final DateTime? premiumTrialEndDate;
  final String blueVerificationStatus; // 'none', 'pending', 'approved', 'rejected'

  const SupplierCredits({
    this.welcomeCreditsGranted = false,
    this.creditsBalance = 0,
    this.freeProductsRemaining = 0,
    this.premiumTrialEndDate,
    this.blueVerificationStatus = 'none',
  });

  bool get isBlueVerified => blueVerificationStatus == 'approved';
  bool get isBluePending => blueVerificationStatus == 'pending';

  bool get isPremiumTrialActive {
    if (premiumTrialEndDate == null) return false;
    return DateTime.now().isBefore(premiumTrialEndDate!);
  }

  int get daysLeftInTrial {
    if (premiumTrialEndDate == null) return 0;
    final diff = premiumTrialEndDate!.difference(DateTime.now()).inDays;
    return diff < 0 ? 0 : diff;
  }

  SupplierCredits copyWith({
    bool? welcomeCreditsGranted,
    int? creditsBalance,
    int? freeProductsRemaining,
    DateTime? premiumTrialEndDate,
    String? blueVerificationStatus,
  }) {
    return SupplierCredits(
      welcomeCreditsGranted: welcomeCreditsGranted ?? this.welcomeCreditsGranted,
      creditsBalance: creditsBalance ?? this.creditsBalance,
      freeProductsRemaining: freeProductsRemaining ?? this.freeProductsRemaining,
      premiumTrialEndDate: premiumTrialEndDate ?? this.premiumTrialEndDate,
      blueVerificationStatus: blueVerificationStatus ?? this.blueVerificationStatus,
    );
  }
}
