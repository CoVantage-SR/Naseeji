import '../entities/supplier_credits.dart';

abstract class CreditsRepository {
  Future<SupplierCredits> getCredits();
  Future<SupplierCredits> grantWelcomePackage();
  Future<SupplierCredits?> consumeForProduct();
  Future<SupplierCredits?> consumeForVideo();
  Future<SupplierCredits> requestBlueVerification();
  Future<SupplierCredits?> approveBlueVerification();
  Future<SupplierCredits> buyCredits(int count);
}
