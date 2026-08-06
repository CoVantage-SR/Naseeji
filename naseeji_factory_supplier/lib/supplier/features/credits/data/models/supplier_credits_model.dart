import '../../domain/entities/supplier_credits.dart';

class SupplierCreditsModel extends SupplierCredits {
  const SupplierCreditsModel({
    super.supplierId,
    super.welcomeCreditsGranted,
    super.creditsBalance,
    super.blueVerificationStatus,
    super.verificationDate,
    super.verificationRequest,
    super.transactions,
    super.purchaseHistory,
  });

  factory SupplierCreditsModel.fromJson(Map<String, dynamic> json) {
    return SupplierCreditsModel(
      supplierId: json['supplierId'] as String? ?? 'sup_1',
      welcomeCreditsGranted: json['welcomeCreditsGranted'] as bool? ?? false,
      creditsBalance: json['creditsBalance'] as int? ?? 50,
      blueVerificationStatus: json['blueVerificationStatus'] as String? ?? 'none',
      verificationDate: json['verificationDate'] != null
          ? DateTime.tryParse(json['verificationDate'] as String)
          : null,
      verificationRequest: json['verificationRequest'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'supplierId': supplierId,
      'welcomeCreditsGranted': welcomeCreditsGranted,
      'creditsBalance': creditsBalance,
      'blueVerificationStatus': blueVerificationStatus,
      'verificationDate': verificationDate?.toIso8601String(),
      'verificationRequest': verificationRequest,
    };
  }

  factory SupplierCreditsModel.fromEntity(SupplierCredits entity) {
    return SupplierCreditsModel(
      supplierId: entity.supplierId,
      welcomeCreditsGranted: entity.welcomeCreditsGranted,
      creditsBalance: entity.creditsBalance,
      blueVerificationStatus: entity.blueVerificationStatus,
      verificationDate: entity.verificationDate,
      verificationRequest: entity.verificationRequest,
      transactions: entity.transactions,
      purchaseHistory: entity.purchaseHistory,
    );
  }
}
