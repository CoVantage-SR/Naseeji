
import 'package:naseeji_factory/shared/enums/user_role.dart';

abstract class ChooseAccountRepository {
  Future<bool> saveAccountType(UserRole role);
  Future<UserRole?> getSavedAccountType();
}
