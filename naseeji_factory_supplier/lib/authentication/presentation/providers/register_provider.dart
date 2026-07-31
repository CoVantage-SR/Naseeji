import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/register_usecase.dart';
import '../controllers/register_controller.dart';
import '../providers/auth_providers.dart';
import 'register_state.dart';

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final repo = ref.watch(authenticationRepositoryProvider);
  return RegisterUseCase(repo);
});

final registerControllerProvider =
    StateNotifierProvider<RegisterController, RegisterState>((ref) {
  final useCase = ref.watch(registerUseCaseProvider);
  return RegisterController(useCase);
});
