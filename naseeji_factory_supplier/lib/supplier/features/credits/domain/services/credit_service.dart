import '../entities/credit_transaction.dart';

class CreditServiceException implements Exception {
  final String message;
  const CreditServiceException(this.message);

  @override
  String toString() => 'CreditServiceException: $message';
}

class CreditService {
  /// Checks if balance has enough credits for the required amount
  bool checkEnoughCredits(int currentBalance, int requiredCredits) {
    if (requiredCredits < 0) return false;
    return currentBalance >= requiredCredits;
  }

  /// Calculates new balance and generates transaction for consuming credits
  CreditTransaction consumeCredits({
    required String supplierId,
    required String operation,
    required int amount,
    required int currentBalance,
  }) {
    if (amount <= 0) {
      throw const CreditServiceException('Amount to consume must be greater than zero');
    }
    if (!checkEnoughCredits(currentBalance, amount)) {
      throw CreditServiceException(
        'Insufficient credits balance ($currentBalance available, $amount required)',
      );
    }

    final balanceAfter = currentBalance - amount;
    return createTransaction(
      supplierId: supplierId,
      operation: operation,
      amount: -amount,
      balanceBefore: currentBalance,
      balanceAfter: balanceAfter,
    );
  }

  /// Calculates new balance and generates transaction for adding credits
  CreditTransaction addCredits({
    required String supplierId,
    required String operation,
    required int amount,
    required int currentBalance,
  }) {
    if (amount <= 0) {
      throw const CreditServiceException('Amount to add must be greater than zero');
    }

    final balanceAfter = currentBalance + amount;
    return createTransaction(
      supplierId: supplierId,
      operation: operation,
      amount: amount,
      balanceBefore: currentBalance,
      balanceAfter: balanceAfter,
    );
  }

  /// Refunds previously deducted credits back to the balance
  CreditTransaction refundCredits({
    required String supplierId,
    required String operation,
    required int amount,
    required int currentBalance,
  }) {
    if (amount <= 0) {
      throw const CreditServiceException('Amount to refund must be greater than zero');
    }

    final refundOp = operation.startsWith('استرداد') ? operation : 'استرداد: $operation';
    final balanceAfter = currentBalance + amount;

    return createTransaction(
      supplierId: supplierId,
      operation: refundOp,
      amount: amount,
      balanceBefore: currentBalance,
      balanceAfter: balanceAfter,
    );
  }

  /// Utility constructor for credit transaction logs
  CreditTransaction createTransaction({
    required String supplierId,
    required String operation,
    required int amount,
    required int balanceBefore,
    required int balanceAfter,
  }) {
    return CreditTransaction(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      supplierId: supplierId,
      operation: operation,
      amount: amount,
      balanceBefore: balanceBefore,
      balanceAfter: balanceAfter,
      createdAt: DateTime.now(),
    );
  }
}
