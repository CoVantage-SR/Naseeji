import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/select_account_type_usecase.dart';
import '../controllers/account_type_controller.dart';

final selectAccountTypeUseCaseProvider = Provider<SelectAccountTypeUseCase>((ref) {
  return const SelectAccountTypeUseCase();
});

final accountTypeControllerProvider =
    StateNotifierProvider<AccountTypeController, AccountTypeState>((ref) {
  final useCase = ref.watch(selectAccountTypeUseCaseProvider);
  return AccountTypeController(selectAccountTypeUseCase: useCase);
});
