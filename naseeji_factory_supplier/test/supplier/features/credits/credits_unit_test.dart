import 'package:flutter_test/flutter_test.dart';
import 'package:naseeji_factory/supplier/features/credits/domain/entities/credit_costs.dart';
import 'package:naseeji_factory/supplier/features/credits/domain/entities/credit_package.dart';
import 'package:naseeji_factory/supplier/features/credits/domain/services/credit_service.dart';
import 'package:naseeji_factory/supplier/features/credits/data/repositories/credits_repository_impl.dart';

void main() {
  group('CreditService Unit Tests', () {
    late CreditService creditService;

    setUp(() {
      creditService = CreditService();
    });

    test('checkEnoughCredits returns true when balance is sufficient', () {
      expect(creditService.checkEnoughCredits(50, 35), isTrue);
      expect(creditService.checkEnoughCredits(5, 5), isTrue);
    });

    test('checkEnoughCredits returns false when balance is insufficient', () {
      expect(creditService.checkEnoughCredits(10, 35), isFalse);
      expect(creditService.checkEnoughCredits(0, 5), isFalse);
    });

    test('consumeCredits deducts correct amount and generates transaction log', () {
      final tx = creditService.consumeCredits(
        supplierId: 'sup_test',
        operation: 'إضافة منتج',
        amount: 5,
        currentBalance: 50,
      );

      expect(tx.amount, equals(-5));
      expect(tx.balanceBefore, equals(50));
      expect(tx.balanceAfter, equals(45));
      expect(tx.isDeduction, isTrue);
    });

    test('consumeCredits throws CreditServiceException when insufficient balance', () {
      expect(
        () => creditService.consumeCredits(
          supplierId: 'sup_test',
          operation: 'طلب التوثيق الزرقاء',
          amount: 35,
          currentBalance: 10,
        ),
        throwsA(isA<CreditServiceException>()),
      );
    });

    test('addCredits increases balance and generates positive transaction', () {
      final tx = creditService.addCredits(
        supplierId: 'sup_test',
        operation: 'شراء باقة نقاط',
        amount: 100,
        currentBalance: 20,
      );

      expect(tx.amount, equals(100));
      expect(tx.balanceBefore, equals(20));
      expect(tx.balanceAfter, equals(120));
      expect(tx.isDeduction, isFalse);
    });

    test('refundCredits restores balance after operation cancellation', () {
      final tx = creditService.refundCredits(
        supplierId: 'sup_test',
        operation: 'إضافة منتج',
        amount: 5,
        currentBalance: 10,
      );

      expect(tx.amount, equals(5));
      expect(tx.balanceAfter, equals(15));
      expect(tx.operation, contains('استرداد'));
    });
  });

  group('CreditsRepository Unit Tests', () {
    late CreditsRepositoryImpl repository;

    setUp(() {
      repository = CreditsRepositoryImpl();
    });

    test('First login grants 50 welcome credits ONLY ONCE', () async {
      final credits = await repository.getCredits('sup_new_user');

      expect(credits.creditsBalance, equals(CreditCosts.firstLoginBonus));
      expect(credits.welcomeCreditsGranted, isTrue);
      expect(credits.transactions.length, equals(1));
      expect(credits.transactions.first.operation, equals('مكافأة التسجيل الأول'));

      // Second check should not duplicate welcome credits
      final recheck = await repository.getCredits('sup_new_user');
      expect(recheck.creditsBalance, equals(50));
      expect(recheck.transactions.length, equals(1));
    });

    test('requestBlueVerification deducts 35 credits and sets status to approved', () async {
      final initial = await repository.getCredits('sup_new_user');
      expect(initial.creditsBalance, equals(50));

      final updated = await repository.requestBlueVerification('sup_new_user');
      expect(updated.creditsBalance, equals(15)); // 50 - 35
      expect(updated.isBlueVerified, isTrue);
      expect(updated.transactions.first.operation, equals('طلب التوثيق الزرقاء'));
    });

    test('buyCreditPackage adds package credits and records purchase history', () async {
      const package = CreditPackage(
        id: 'pkg_pro',
        name: 'باقة الأعمال',
        credits: 150,
        price: 650.0,
      );

      final updated = await repository.buyCreditPackage('sup_1', package);

      expect(updated.creditsBalance, equals(200)); // 50 initial + 150
      expect(updated.purchaseHistory.first.packageId, equals('pkg_pro'));
      expect(updated.purchaseHistory.first.credits, equals(150));
    });
  });
}
