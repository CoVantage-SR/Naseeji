import '../../../shared/enums/user_role.dart';
import '../../domain/repositories/choose_account_repository.dart';
import '../datasource/choose_account_local_datasource.dart';
import '../datasource/choose_account_remote_datasource.dart';
import '../models/account_type_request_model.dart';

class ChooseAccountRepositoryImpl implements ChooseAccountRepository {
  final ChooseAccountRemoteDatasource remoteDatasource;
  final ChooseAccountLocalDatasource localDatasource;

  ChooseAccountRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<bool> saveAccountType(UserRole role) async {
    final request = AccountTypeRequestModel(role: role);
    final response = await remoteDatasource.saveAccountType(request);
    if (response.success) {
      await localDatasource.saveAccountType(role);
    }
    return response.success;
  }

  @override
  Future<UserRole?> getSavedAccountType() async {
    return await localDatasource.getSavedAccountType();
  }
}
