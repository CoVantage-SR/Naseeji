import '../../authentication/choose_account_type/choose_account_type.dart';
import '../../authentication/complete_profile/complete_profile.dart';
import 'service_locator.dart';

class RegisterUseCases {
  static void init() {
    if (!ServiceLocator.isRegistered<SaveAccountTypeUseCase>()) {
      final repo = ServiceLocator.get<ChooseAccountRepository>();
      ServiceLocator.register<SaveAccountTypeUseCase>(
        SaveAccountTypeUseCase(repo),
      );
    }
    if (!ServiceLocator.isRegistered<CompleteProfileUseCase>()) {
      final repo = ServiceLocator.get<CompleteProfileRepository>();
      ServiceLocator.register<CompleteProfileUseCase>(
        CompleteProfileUseCase(repo),
      );
    }
    if (!ServiceLocator.isRegistered<UploadLogoUseCase>()) {
      final repo = ServiceLocator.get<CompleteProfileRepository>();
      ServiceLocator.register<UploadLogoUseCase>(
        UploadLogoUseCase(repo),
      );
    }
    if (!ServiceLocator.isRegistered<ValidateProfileUseCase>()) {
      ServiceLocator.register<ValidateProfileUseCase>(
        const ValidateProfileUseCase(),
      );
    }
  }
}
