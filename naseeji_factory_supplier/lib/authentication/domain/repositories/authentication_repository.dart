import '../../../shared/enums/account_mode.dart';
import '../../../shared/enums/user_role.dart';
import '../entities/auth_token.dart';
import '../entities/user_entity.dart';

abstract class AuthenticationRepository {
  Future<UserEntity> login({
    required String phoneOrEmail,
    required String password,
    bool rememberMe = true,
  });

  Future<UserEntity> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  });

  Future<bool> verifyOtp({
    required String phone,
    required String code,
  });

  Future<void> sendForgotPasswordCode(String phoneOrEmail);

  Future<void> resetPassword({
    required String phoneOrEmail,
    required String code,
    required String newPassword,
  });

  Future<AuthToken> refreshToken(String refreshToken);

  Future<void> logout();

  Future<UserEntity?> getCurrentUser();

  Future<void> selectAccountType({
    required UserRole role,
    AccountMode mode = AccountMode.real,
  });
}


