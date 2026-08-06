import '../entities/supplier_credits.dart';
import '../entities/credit_package.dart';
import '../repositories/credits_repository.dart';

class GetCreditsUseCase {
  final CreditsRepository _repository;
  GetCreditsUseCase(this._repository);

  Future<SupplierCredits> call({String supplierId = 'sup_1'}) =>
      _repository.getCredits(supplierId);
}

class GrantWelcomePackageUseCase {
  final CreditsRepository _repository;
  GrantWelcomePackageUseCase(this._repository);

  Future<SupplierCredits> call({String supplierId = 'sup_1'}) =>
      _repository.grantWelcomeCredits(supplierId);
}

class ConsumeProductCreditUseCase {
  final CreditsRepository _repository;
  ConsumeProductCreditUseCase(this._repository);

  Future<SupplierCredits> call({String supplierId = 'sup_1'}) =>
      _repository.consumeCredits(
        supplierId: supplierId,
        operation: 'إضافة منتج',
        amount: 5,
      );
}

class ConsumeVideoCreditUseCase {
  final CreditsRepository _repository;
  ConsumeVideoCreditUseCase(this._repository);

  Future<SupplierCredits> call({String supplierId = 'sup_1'}) =>
      _repository.consumeCredits(
        supplierId: supplierId,
        operation: 'إضافة فيديو منتج',
        amount: 10,
      );
}

class RequestBlueVerificationUseCase {
  final CreditsRepository _repository;
  RequestBlueVerificationUseCase(this._repository);

  Future<SupplierCredits> call({String supplierId = 'sup_1'}) =>
      _repository.requestBlueVerification(supplierId);
}

class BuyCreditsUseCase {
  final CreditsRepository _repository;
  BuyCreditsUseCase(this._repository);

  Future<SupplierCredits> call(CreditPackage package, {String supplierId = 'sup_1'}) =>
      _repository.buyCreditPackage(supplierId, package);
}
