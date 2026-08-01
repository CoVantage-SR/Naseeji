import '../../authentication/choose_account_type/choose_account_type.dart';
import '../../authentication/complete_profile/complete_profile.dart';
import 'service_locator.dart';

class RegisterRepositories {
  static void init() {
    if (!ServiceLocator.isRegistered<ChooseAccountRepository>()) {
      final remote = ServiceLocator.get<ChooseAccountRemoteDatasource>();
      ServiceLocator.register<ChooseAccountRepository>(
        ChooseAccountRepositoryImpl(
          remoteDatasource: remote,
          localDatasource: ChooseAccountLocalDatasourceImpl(),
        ),
      );
    }
    if (!ServiceLocator.isRegistered<CompleteProfileRepository>()) {
      final remote = ServiceLocator.get<CompleteProfileRemoteDatasource>();
      ServiceLocator.register<CompleteProfileRepository>(
        CompleteProfileRepositoryImpl(
          remoteDatasource: remote,
          localDatasource: CompleteProfileLocalDatasourceImpl(),
        ),
      );
    }
  }
}
