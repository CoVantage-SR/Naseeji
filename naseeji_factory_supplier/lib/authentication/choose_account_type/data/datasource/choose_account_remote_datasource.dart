import '../models/account_type_request_model.dart';
import '../models/account_type_response_model.dart';

abstract class ChooseAccountRemoteDatasource {
  Future<AccountTypeResponseModel> saveAccountType(AccountTypeRequestModel request);
}

class ChooseAccountRemoteDatasourceImpl implements ChooseAccountRemoteDatasource {
  @override
  Future<AccountTypeResponseModel> saveAccountType(AccountTypeRequestModel request) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const AccountTypeResponseModel(
      success: true,
      message: 'تم تحديد ونوع الحساب بنجاح',
    );
  }
}
