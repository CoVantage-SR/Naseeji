import '../../domain/entities/supplier_credits.dart';

class SupplierCreditsModel extends SupplierCredits {
  const SupplierCreditsModel({
    super.welcomeCreditsGranted,
    super.creditsBalance,
    super.freeProductsRemaining,
    super.premiumTrialEndDate,
    super.blueVerificationStatus,
  });

  factory SupplierCreditsModel.fromJson(Map<String, dynamic> json) {
    return SupplierCreditsModel(
      welcomeCreditsGranted: json['welcomeCreditsGranted'] as bool? ?? false,
      creditsBalance: json['creditsBalance'] as int? ?? 0,
      freeProductsRemaining: json['freeProductsRemaining'] as int? ?? 0,
      premiumTrialEndDate: json['premiumTrialEndDate'] != null
          ? DateTime.tryParse(json['premiumTrialEndDate'] as String)
          : null,
      blueVerificationStatus:
          json['blueVerificationStatus'] as String? ?? 'none',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'welcomeCreditsGranted': welcomeCreditsGranted,
      'creditsBalance': creditsBalance,
      'freeProductsRemaining': freeProductsRemaining,
      'premiumTrialEndDate': premiumTrialEndDate?.toIso8601String(),
      'blueVerificationStatus': blueVerificationStatus,
    };
  }

  factory SupplierCreditsModel.fromEntity(SupplierCredits entity) {
    return SupplierCreditsModel(
      welcomeCreditsGranted: entity.welcomeCreditsGranted,
      creditsBalance: entity.creditsBalance,
      freeProductsRemaining: entity.freeProductsRemaining,
      premiumTrialEndDate: entity.premiumTrialEndDate,
      blueVerificationStatus: entity.blueVerificationStatus,
    );
  }
}
