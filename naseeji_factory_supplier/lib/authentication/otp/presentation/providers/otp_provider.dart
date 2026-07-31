import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_factory/core/storage/shared_preferences_service.dart';
import '../../data/datasource/otp_local_datasource.dart';
import '../../data/datasource/otp_remote_datasource.dart';
import '../../data/repositories/otp_repository_impl.dart';
import '../../domain/repositories/otp_repository.dart';
import '../../domain/usecases/resend_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../controllers/otp_controller.dart';
import 'otp_state.dart';

final otpRemoteDatasourceProvider = Provider<OtpRemoteDatasource>((ref) {
  return OtpRemoteDatasourceImpl();
});

final otpLocalDatasourceProvider = Provider<OtpLocalDatasource>((ref) {
  final prefs = ref.watch(sharedPreferencesServiceProvider);
  return OtpLocalDatasourceImpl(prefs);
});

final otpRepositoryProvider = Provider<OtpRepository>((ref) {
  final remote = ref.watch(otpRemoteDatasourceProvider);
  final local = ref.watch(otpLocalDatasourceProvider);
  return OtpRepositoryImpl(
    remoteDatasource: remote,
    localDatasource: local,
  );
});

final verifyOtpUseCaseProvider = Provider<VerifyOtpUseCase>((ref) {
  final repo = ref.watch(otpRepositoryProvider);
  return VerifyOtpUseCase(repo);
});

final resendOtpUseCaseProvider = Provider<ResendOtpUseCase>((ref) {
  final repo = ref.watch(otpRepositoryProvider);
  return ResendOtpUseCase(repo);
});

final otpControllerProvider =
    StateNotifierProvider<OtpController, OtpState>((ref) {
  final verifyUseCase = ref.watch(verifyOtpUseCaseProvider);
  final resendUseCase = ref.watch(resendOtpUseCaseProvider);
  return OtpController(verifyUseCase, resendUseCase);
});
