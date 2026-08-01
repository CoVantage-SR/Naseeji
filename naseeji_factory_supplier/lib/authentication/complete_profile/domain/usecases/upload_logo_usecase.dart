import 'dart:io';
import '../repositories/complete_profile_repository.dart';

class UploadLogoUseCase {
  final CompleteProfileRepository repository;

  const UploadLogoUseCase(this.repository);

  Future<String> execute(File imageFile) {
    return repository.uploadLogo(imageFile);
  }
}
