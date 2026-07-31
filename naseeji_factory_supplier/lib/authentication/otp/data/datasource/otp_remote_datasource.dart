import '../models/otp_request_model.dart';
import '../models/otp_response_model.dart';

abstract class OtpRemoteDatasource {
  Future<OtpResponseModel> verifyOtp(OtpRequestModel request);
  Future<OtpResponseModel> resendOtp(String phone);
}

class OtpRemoteDatasourceImpl implements OtpRemoteDatasource {
  @override
  Future<OtpResponseModel> verifyOtp(OtpRequestModel request) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final isValid = request.code == '123456' || request.code.length == 6;
    return OtpResponseModel(
      success: isValid,
      message: isValid ? 'تم التحقق بنجاح' : 'رمز التحقق غير صحيح',
    );
  }

  @override
  Future<OtpResponseModel> resendOtp(String phone) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const OtpResponseModel(
      success: true,
      message: 'تم إعادة إرسال رمز التحقق بنجاح',
    );
  }
}
