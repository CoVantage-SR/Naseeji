import '../models/forgot_password_request_model.dart';
import '../models/forgot_password_response_model.dart';

abstract class ForgotPasswordRemoteDatasource {
  Future<ForgotPasswordResponseModel> sendResetCode(ForgotPasswordRequestModel request);
}

class ForgotPasswordRemoteDatasourceImpl implements ForgotPasswordRemoteDatasource {
  @override
  Future<ForgotPasswordResponseModel> sendResetCode(ForgotPasswordRequestModel request) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const ForgotPasswordResponseModel(
      success: true,
      message: 'تم إرسال رمز استعادة كلمة المرور بنجاح',
    );
  }
}
