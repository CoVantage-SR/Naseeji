import '../../../core/storage/shared_preferences_service.dart';

abstract class OtpLocalDatasource {
  Future<void> saveLastVerifiedPhone(String phone);
  Future<String?> getLastVerifiedPhone();
}

class OtpLocalDatasourceImpl implements OtpLocalDatasource {
  final SharedPreferencesService sharedPreferences;

  OtpLocalDatasourceImpl(this.sharedPreferences);

  @override
  Future<void> saveLastVerifiedPhone(String phone) async {
    await sharedPreferences.setString('last_verified_phone', phone);
  }

  @override
  Future<String?> getLastVerifiedPhone() async {
    return sharedPreferences.getString('last_verified_phone');
  }
}
