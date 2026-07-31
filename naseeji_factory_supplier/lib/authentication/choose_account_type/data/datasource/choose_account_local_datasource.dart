import 'package:naseeji_factory/core/storage/shared_preferences_service.dart';
import '../../../shared/enums/user_role.dart';

abstract class ChooseAccountLocalDatasource {
  Future<void> saveAccountType(UserRole role);
  Future<UserRole?> getSavedAccountType();
}

class ChooseAccountLocalDatasourceImpl implements ChooseAccountLocalDatasource {
  final SharedPreferencesService sharedPreferences;

  ChooseAccountLocalDatasourceImpl(this.sharedPreferences);

  @override
  Future<void> saveAccountType(UserRole role) async {
    await sharedPreferences.setString('selected_account_type', role.name);
  }

  @override
  Future<UserRole?> getSavedAccountType() async {
    final raw = sharedPreferences.getString('selected_account_type');
    if (raw == 'supplier') return UserRole.supplier;
    if (raw == 'factory') return UserRole.factory;
    return null;
  }
}
