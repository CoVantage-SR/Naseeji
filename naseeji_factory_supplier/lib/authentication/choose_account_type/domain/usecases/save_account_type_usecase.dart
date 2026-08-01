import 'package:naseeji_factory/shared/enums/user_role.dart';

import '../repositories/choose_account_repository.dart';

class SaveAccountTypeUseCase {
  final ChooseAccountRepository repository;

  const SaveAccountTypeUseCase(this.repository);

  Future<bool> execute(UserRole role) async {
    return await repository.saveAccountType(role);
  }
}
