import '../../domain/repositories/forgot_password_repository.dart';
import '../datasource/forgot_password_local_datasource.dart';
import '../datasource/forgot_password_remote_datasource.dart';
import '../models/forgot_password_request_model.dart';

class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  final ForgotPasswordRemoteDatasource remoteDatasource;
  final ForgotPasswordLocalDatasource localDatasource;

  ForgotPasswordRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<bool> sendResetCode(String phoneOrEmail) async {
    final request = ForgotPasswordRequestModel(phoneOrEmail: phoneOrEmail);
    final response = await remoteDatasource.sendResetCode(request);
    if (response.success) {
      await localDatasource.saveLastRequestedPhone(phoneOrEmail);
    }
    return response.success;
  }
}
