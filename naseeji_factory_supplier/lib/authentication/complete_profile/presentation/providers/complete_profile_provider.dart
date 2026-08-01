import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasource/complete_profile_local_datasource.dart';
import '../../data/datasource/complete_profile_remote_datasource.dart';
import '../../data/repositories/complete_profile_repository_impl.dart';
import '../../domain/repositories/complete_profile_repository.dart';
import '../../domain/usecases/complete_profile_usecase.dart';
import '../../domain/usecases/upload_logo_usecase.dart';
import '../../domain/usecases/validate_profile_usecase.dart';
import '../controllers/complete_profile_controller.dart';
import 'complete_profile_state.dart';

final completeProfileRemoteDatasourceProvider =
    Provider<CompleteProfileRemoteDatasource>((ref) {
  return CompleteProfileRemoteDatasourceImpl();
});

final completeProfileLocalDatasourceProvider =
    Provider<CompleteProfileLocalDatasource>((ref) {
  return CompleteProfileLocalDatasourceImpl();
});

final completeProfileRepositoryProvider =
    Provider<CompleteProfileRepository>((ref) {
  final remote = ref.watch(completeProfileRemoteDatasourceProvider);
  final local = ref.watch(completeProfileLocalDatasourceProvider);
  return CompleteProfileRepositoryImpl(
    remoteDatasource: remote,
    localDatasource: local,
  );
});

final completeProfileUseCaseProvider = Provider<CompleteProfileUseCase>((ref) {
  final repository = ref.watch(completeProfileRepositoryProvider);
  return CompleteProfileUseCase(repository);
});

final uploadLogoUseCaseProvider = Provider<UploadLogoUseCase>((ref) {
  final repository = ref.watch(completeProfileRepositoryProvider);
  return UploadLogoUseCase(repository);
});

final validateProfileUseCaseProvider = Provider<ValidateProfileUseCase>((ref) {
  return const ValidateProfileUseCase();
});

final completeProfileControllerProvider =
    StateNotifierProvider<CompleteProfileController, CompleteProfileState>((ref) {
  final completeProfileUseCase = ref.watch(completeProfileUseCaseProvider);
  final uploadLogoUseCase = ref.watch(uploadLogoUseCaseProvider);
  final validateProfileUseCase = ref.watch(validateProfileUseCaseProvider);

  return CompleteProfileController(
    completeProfileUseCase: completeProfileUseCase,
    uploadLogoUseCase: uploadLogoUseCase,
    validateProfileUseCase: validateProfileUseCase,
  );
});
