import '../entities/factory_profile_entities.dart';
import '../repositories/factory_profile_repository.dart';

class GetFactoryProfileUseCase {
  final FactoryProfileRepository repository;
  GetFactoryProfileUseCase(this.repository);

  Future<FactoryProfileEntity> call() => repository.getProfile();
}

class UpdateFactoryProfileUseCase {
  final FactoryProfileRepository repository;
  UpdateFactoryProfileUseCase(this.repository);

  Future<void> call(FactoryProfileEntity profile) => repository.updateProfile(profile);
}

class GetFactoryDocumentsUseCase {
  final FactoryProfileRepository repository;
  GetFactoryDocumentsUseCase(this.repository);

  Future<List<FactoryDocumentEntity>> call() => repository.getDocuments();
}

class AddFactoryDocumentUseCase {
  final FactoryProfileRepository repository;
  AddFactoryDocumentUseCase(this.repository);

  Future<void> call(FactoryDocumentEntity document) => repository.addDocument(document);
}

class DeleteFactoryDocumentUseCase {
  final FactoryProfileRepository repository;
  DeleteFactoryDocumentUseCase(this.repository);

  Future<void> call(String id) => repository.deleteDocument(id);
}
