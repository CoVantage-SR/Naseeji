import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_factory/core/storage/shared_preferences_service.dart';
import '../../data/datasource/choose_account_local_datasource.dart';
import '../../data/datasource/choose_account_remote_datasource.dart';
import '../../data/repositories/choose_account_repository_impl.dart';
import '../../domain/repositories/choose_account_repository.dart';
import '../../domain/usecases/save_account_type_usecase.dart';
import '../controllers/choose_account_controller.dart';
import 'choose_account_state.dart';

final chooseAccountRemoteDatasourceProvider = Provider<ChooseAccountRemoteDatasource>((ref) {
  return ChooseAccountRemoteDatasourceImpl();
});

final chooseAccountLocalDatasourceProvider = Provider<ChooseAccountLocalDatasource>((ref) {
  final prefs = ref.watch(sharedPreferencesServiceProvider);
  return ChooseAccountLocalDatasourceImpl(prefs);
});

final chooseAccountRepositoryProvider = Provider<ChooseAccountRepository>((ref) {
  final remote = ref.watch(chooseAccountRemoteDatasourceProvider);
  final local = ref.watch(chooseAccountLocalDatasourceProvider);
  return ChooseAccountRepositoryImpl(
    remoteDatasource: remote,
    localDatasource: local,
  );
});

final saveAccountTypeUseCaseProvider = Provider<SaveAccountTypeUseCase>((ref) {
  final repo = ref.watch(chooseAccountRepositoryProvider);
  return SaveAccountTypeUseCase(repo);
});

final chooseAccountControllerProvider =
    StateNotifierProvider<ChooseAccountController, ChooseAccountState>((ref) {
  final useCase = ref.watch(saveAccountTypeUseCaseProvider);
  return ChooseAccountController(useCase);
});
