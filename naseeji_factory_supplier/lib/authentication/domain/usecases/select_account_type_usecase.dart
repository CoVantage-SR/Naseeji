import '../entities/account_type.dart';

class SelectAccountTypeUseCase {
  const SelectAccountTypeUseCase();

  AccountType execute(AccountType selectedType) {
    return selectedType;
  }
}
