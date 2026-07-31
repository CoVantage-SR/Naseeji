import 'package:naseeji_factory/core/storage/shared_preferences_service.dart';

abstract class ForgotPasswordLocalDatasource {
  Future<void> saveLastRequestedPhone(String phone);
  Future<String?> getLastRequestedPhone();
}

class ForgotPasswordLocalDatasourceImpl implements ForgotPasswordLocalDatasource {
  final SharedPreferencesService sharedPreferences;

  ForgotPasswordLocalDatasourceImpl(this.sharedPreferences);

  @override
  Future<void> saveLastRequestedPhone(String phone) async {
    await sharedPreferences.setString('last_reset_phone', phone);
  }

  @override
  Future<String?> getLastRequestedPhone() async {
    return sharedPreferences.getString('last_reset_phone');
  }
}
