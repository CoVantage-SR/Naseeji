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
    await Future.delayed(const Duration(milliseconds: 400));
    final lower = phoneOrEmail.toLowerCase();
    
    // Check if supplier login
    final isSupplier = lower.contains('supplier') ||
        lower.contains('misr') ||
        lower.contains('oriental') ||
        lower.contains('mahalla') ||
        lower.contains('cairo') ||
        lower.contains('ahram') ||
        lower.contains('alex') ||
        lower.contains('sharkia') ||
        lower.contains('international') ||
        lower.startsWith('0101111') ||
        lower.startsWith('0102222') ||
        lower.startsWith('0103333') ||
        lower.startsWith('0104444') ||
        lower.startsWith('0105555') ||
        lower.startsWith('0106666') ||
        lower.startsWith('0107777') ||
        lower.startsWith('0108888');

    final role = isSupplier ? UserRole.supplier : UserRole.factory;

    return UserEntity(
      id: 'USR-${DateTime.now().millisecondsSinceEpoch}',
      name: isSupplier ? 'مورد معتمد - منصة نسيجي' : 'مهندس / إبراهيم الششتاوي (مصنع النيل)',
      email: phoneOrEmail.contains('@') ? phoneOrEmail : '$phoneOrEmail@naseeji.com',
      phone: phoneOrEmail.contains('@') ? '01012345678' : phoneOrEmail,
      role: role,
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


