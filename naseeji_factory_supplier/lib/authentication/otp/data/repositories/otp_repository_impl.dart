import '../../domain/repositories/otp_repository.dart';
import '../datasource/otp_local_datasource.dart';
import '../datasource/otp_remote_datasource.dart';
import '../models/otp_request_model.dart';

class OtpRepositoryImpl implements OtpRepository {
  final OtpRemoteDatasource remoteDatasource;
  final OtpLocalDatasource localDatasource;

  OtpRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<bool> verifyOtp({required String phone, required String code}) async {
    final request = OtpRequestModel(phone: phone, code: code);
    final response = await remoteDatasource.verifyOtp(request);
    if (response.success) {
      await localDatasource.saveLastVerifiedPhone(phone);
    }
    return response.success;
  }

  @override
  Future<bool> resendOtp({required String phone}) async {
    final response = await remoteDatasource.resendOtp(phone);
    return response.success;
  }
}
