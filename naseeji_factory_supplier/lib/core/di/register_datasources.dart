import '../../authentication/choose_account_type/choose_account_type.dart';
import '../../authentication/complete_profile/complete_profile.dart';
import 'service_locator.dart';

class RegisterDatasources {
  static void init() {
    if (!ServiceLocator.isRegistered<ChooseAccountRemoteDatasource>()) {
      ServiceLocator.register<ChooseAccountRemoteDatasource>(
        ChooseAccountRemoteDatasourceImpl(),
      );
    }
    if (!ServiceLocator.isRegistered<CompleteProfileRemoteDatasource>()) {
      ServiceLocator.register<CompleteProfileRemoteDatasource>(
        CompleteProfileRemoteDatasourceImpl(),
      );
    }
  }
}
