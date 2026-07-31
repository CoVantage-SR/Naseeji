import '../../../shared/enums/account_mode.dart';
import '../../../shared/enums/user_role.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthRemoteDatasource {
  Future<UserEntity> login({
    required String phoneOrEmail,
    required String password,
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
}

class MockAuthRemoteDatasource implements AuthRemoteDatasource {
  @override
  Future<UserEntity> login({
    required String phoneOrEmail,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const UserEntity(
      id: 'USR-101',
      name: 'أحمد محمود',
      email: 'ahmed@naseeji.com',
      phone: '01012345678',
      role: UserRole.factory,
      mode: AccountMode.real,
      isVerified: true,
      hasCompletedRegistration: true,
    );
  }

  @override
  Future<UserEntity> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return UserEntity(
      id: 'USR-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
      role: UserRole.factory,
      mode: AccountMode.real,
      isVerified: false,
      hasCompletedRegistration: false,
    );
  }

  @override
  Future<bool> verifyOtp({
    required String phone,
    required String code,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return code == '1234' || code.length == 4;
  }

  @override
  Future<void> sendForgotPasswordCode(String phoneOrEmail) async {
    await Future.delayed(const Duration(milliseconds: 400));
  }

  @override
  Future<void> resetPassword({
    required String phoneOrEmail,
    required String code,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<AuthToken> refreshToken(String refreshToken) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return AuthToken(
      accessToken: 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      expiresAt: DateTime.now().add(const Duration(days: 7)),
    );
  }
}

