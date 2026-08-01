import '../entities/company_entity.dart';
import '../repositories/complete_profile_repository.dart';

class CompleteProfileUseCase {
  final CompleteProfileRepository repository;

  const CompleteProfileUseCase(this.repository);

  Future<CompanyEntity> execute(CompanyEntity company) {
    return repository.completeProfile(company);
  }
}
