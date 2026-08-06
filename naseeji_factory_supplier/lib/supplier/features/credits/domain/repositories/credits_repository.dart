import '../entities/supplier_credits.dart';
import '../entities/credit_transaction.dart';
import '../entities/credit_package.dart';
import '../entities/credit_purchase_history.dart';

abstract class CreditsRepository {
  Future<SupplierCredits> getCredits(String supplierId);
  Future<SupplierCredits> grantWelcomeCredits(String supplierId);
  Future<SupplierCredits> consumeCredits({
    required String supplierId,
    required String operation,
    required int amount,
  });
  Future<SupplierCredits> addCredits({
    required String supplierId,
    required String operation,
    required int amount,
  });
  Future<SupplierCredits> refundCredits({
    required String supplierId,
    required String operation,
    required int amount,
  });
  Future<SupplierCredits> requestBlueVerification(String supplierId);
  Future<SupplierCredits> buyCreditPackage(String supplierId, CreditPackage package);
  Future<List<CreditTransaction>> getTransactions(String supplierId);
  Future<List<CreditPurchaseHistory>> getPurchaseHistory(String supplierId);
}
