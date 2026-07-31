import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_factory/core/storage/shared_preferences_service.dart';
import '../../data/datasource/forgot_password_local_datasource.dart';
import '../../data/datasource/forgot_password_remote_datasource.dart';
import '../../data/repositories/forgot_password_repository_impl.dart';
import '../../domain/repositories/forgot_password_repository.dart';
import '../../domain/usecases/send_reset_code_usecase.dart';
import '../controllers/forgot_password_controller.dart';
import 'forgot_password_state.dart';

final forgotPasswordRemoteDatasourceProvider = Provider<ForgotPasswordRemoteDatasource>((ref) {
  return ForgotPasswordRemoteDatasourceImpl();
});

final forgotPasswordLocalDatasourceProvider = Provider<ForgotPasswordLocalDatasource>((ref) {
  final prefs = ref.watch(sharedPreferencesServiceProvider);
  return ForgotPasswordLocalDatasourceImpl(prefs);
});

final forgotPasswordRepositoryProvider = Provider<ForgotPasswordRepository>((ref) {
  final remote = ref.watch(forgotPasswordRemoteDatasourceProvider);
  final local = ref.watch(forgotPasswordLocalDatasourceProvider);
  return ForgotPasswordRepositoryImpl(
    remoteDatasource: remote,
    localDatasource: local,
  );
});

final sendResetCodeUseCaseProvider = Provider<SendResetCodeUseCase>((ref) {
  final repo = ref.watch(forgotPasswordRepositoryProvider);
  return SendResetCodeUseCase(repo);
});

final forgotPasswordControllerProvider =
    StateNotifierProvider<ForgotPasswordController, ForgotPasswordState>((ref) {
  final useCase = ref.watch(sendResetCodeUseCaseProvider);
  return ForgotPasswordController(useCase);
});
