import '../entities/supplier_credits.dart';
import '../repositories/credits_repository.dart';

class GetCreditsUseCase {
  final CreditsRepository _repository;
  GetCreditsUseCase(this._repository);

  Future<SupplierCredits> call() => _repository.getCredits();
}

class GrantWelcomePackageUseCase {
  final CreditsRepository _repository;
  GrantWelcomePackageUseCase(this._repository);

  Future<SupplierCredits> call() => _repository.grantWelcomePackage();
}

class ConsumeProductCreditUseCase {
  final CreditsRepository _repository;
  ConsumeProductCreditUseCase(this._repository);

  Future<SupplierCredits?> call() => _repository.consumeForProduct();
}

class ConsumeVideoCreditUseCase {
  final CreditsRepository _repository;
  ConsumeVideoCreditUseCase(this._repository);

  Future<SupplierCredits?> call() => _repository.consumeForVideo();
}

class RequestBlueVerificationUseCase {
  final CreditsRepository _repository;
  RequestBlueVerificationUseCase(this._repository);

  Future<SupplierCredits> call() => _repository.requestBlueVerification();
}

class ApproveBlueVerificationUseCase {
  final CreditsRepository _repository;
  ApproveBlueVerificationUseCase(this._repository);

  Future<SupplierCredits?> call() => _repository.approveBlueVerification();
}

class BuyCreditsUseCase {
  final CreditsRepository _repository;
  BuyCreditsUseCase(this._repository);

  Future<SupplierCredits> call(int count) => _repository.buyCredits(count);
}
