import '../../domain/entities/supplier_credits.dart';
import '../../domain/entities/credit_transaction.dart';
import '../../domain/entities/credit_package.dart';
import '../../domain/entities/credit_purchase_history.dart';
import '../../domain/entities/credit_costs.dart';
import '../../domain/repositories/credits_repository.dart';
import '../../domain/services/credit_service.dart';

class CreditsRepositoryImpl implements CreditsRepository {
  final CreditService _creditService;
  
  // InMemory state map to simulate persistence per supplier
  final Map<String, SupplierCredits> _supplierCreditsMap = {};

  CreditsRepositoryImpl({CreditService? creditService})
      : _creditService = creditService ?? CreditService() {
    _seedDefaultData();
  }

  void _seedDefaultData() {
    final now = DateTime.now();
    _supplierCreditsMap['sup_1'] = SupplierCredits(
      supplierId: 'sup_1',
      welcomeCreditsGranted: true,
      creditsBalance: 50,
      blueVerificationStatus: 'approved',
      verificationDate: now.subtract(const Duration(days: 30)),
      transactions: [
        CreditTransaction(
          id: 'tx_init_01',
          supplierId: 'sup_1',
          operation: 'مكافأة التسجيل الأول',
          amount: 50,
          balanceBefore: 0,
          balanceAfter: 50,
          createdAt: now.subtract(const Duration(days: 30)),
        ),
      ],
      purchaseHistory: [
        CreditPurchaseHistory(
          id: 'pur_init_01',
          supplierId: 'sup_1',
          packageId: 'pkg_starter',
          packageName: 'الباقة الأساسية',
          credits: 50,
          amountPaid: 250.0,
          paymentStatus: 'completed',
          purchasedAt: now.subtract(const Duration(days: 15)),
        ),
      ],
    );
  }

  @override
  Future<SupplierCredits> getCredits(String supplierId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (!_supplierCreditsMap.containsKey(supplierId)) {
      // First time supplier login -> grant 50 welcome credits ONCE
      final newCredits = SupplierCredits(
        supplierId: supplierId,
        welcomeCreditsGranted: true,
        creditsBalance: CreditCosts.firstLoginBonus,
        blueVerificationStatus: 'none',
        transactions: [
          CreditTransaction(
            id: 'tx_welcome_${DateTime.now().millisecondsSinceEpoch}',
            supplierId: supplierId,
            operation: 'مكافأة التسجيل الأول',
            amount: CreditCosts.firstLoginBonus,
            balanceBefore: 0,
            balanceAfter: CreditCosts.firstLoginBonus,
            createdAt: DateTime.now(),
          ),
        ],
      );
      _supplierCreditsMap[supplierId] = newCredits;
    }
    return _supplierCreditsMap[supplierId]!;
  }

  @override
  Future<SupplierCredits> grantWelcomeCredits(String supplierId) async {
    final current = await getCredits(supplierId);
    if (current.welcomeCreditsGranted) {
      return current; // Only once ever
    }
    return addCredits(
      supplierId: supplierId,
      operation: 'مكافأة التسجيل الأول',
      amount: CreditCosts.firstLoginBonus,
    );
  }

  @override
  Future<SupplierCredits> consumeCredits({
    required String supplierId,
    required String operation,
    required int amount,
  }) async {
    final current = await getCredits(supplierId);
    final tx = _creditService.consumeCredits(
      supplierId: supplierId,
      operation: operation,
      amount: amount,
      currentBalance: current.creditsBalance,
    );

    final updated = current.copyWith(
      creditsBalance: tx.balanceAfter,
      transactions: [tx, ...current.transactions],
    );

    _supplierCreditsMap[supplierId] = updated;
    return updated;
  }

  @override
  Future<SupplierCredits> addCredits({
    required String supplierId,
    required String operation,
    required int amount,
  }) async {
    final current = await getCredits(supplierId);
    final tx = _creditService.addCredits(
      supplierId: supplierId,
      operation: operation,
      amount: amount,
      currentBalance: current.creditsBalance,
    );

    final updated = current.copyWith(
      creditsBalance: tx.balanceAfter,
      transactions: [tx, ...current.transactions],
    );

    _supplierCreditsMap[supplierId] = updated;
    return updated;
  }

  @override
  Future<SupplierCredits> refundCredits({
    required String supplierId,
    required String operation,
    required int amount,
  }) async {
    final current = await getCredits(supplierId);
    final tx = _creditService.refundCredits(
      supplierId: supplierId,
      operation: operation,
      amount: amount,
      currentBalance: current.creditsBalance,
    );

    final updated = current.copyWith(
      creditsBalance: tx.balanceAfter,
      transactions: [tx, ...current.transactions],
    );

    _supplierCreditsMap[supplierId] = updated;
    return updated;
  }

  @override
  Future<SupplierCredits> requestBlueVerification(String supplierId) async {
    final current = await getCredits(supplierId);
    if (current.isBlueVerified || current.isBluePending) {
      return current;
    }

    // Consume 35 credits for verification
    final afterConsume = await consumeCredits(
      supplierId: supplierId,
      operation: 'طلب التوثيق الزرقاء',
      amount: CreditCosts.blueVerification,
    );

    final updated = afterConsume.copyWith(
      blueVerificationStatus: 'approved',
      verificationDate: DateTime.now(),
    );

    _supplierCreditsMap[supplierId] = updated;
    return updated;
  }

  @override
  Future<SupplierCredits> buyCreditPackage(
    String supplierId,
    CreditPackage package,
  ) async {

    final purchase = CreditPurchaseHistory(
      id: 'pur_${DateTime.now().millisecondsSinceEpoch}',
      supplierId: supplierId,
      packageId: package.id,
      packageName: package.name,
      credits: package.credits,
      amountPaid: package.price,
      currency: package.currency,
      paymentStatus: 'completed',
      purchasedAt: DateTime.now(),
    );

    final afterAdd = await addCredits(
      supplierId: supplierId,
      operation: 'شراء باقة نقاط (${package.name})',
      amount: package.credits,
    );

    final updated = afterAdd.copyWith(
      purchaseHistory: [purchase, ...afterAdd.purchaseHistory],
    );

    _supplierCreditsMap[supplierId] = updated;
    return updated;
  }

  @override
  Future<List<CreditTransaction>> getTransactions(String supplierId) async {
    final credits = await getCredits(supplierId);
    return credits.transactions;
  }

  @override
  Future<List<CreditPurchaseHistory>> getPurchaseHistory(String supplierId) async {
    final credits = await getCredits(supplierId);
    return credits.purchaseHistory;
  }
}
