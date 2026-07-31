import '../../../core/session/session_manager.dart';

import '../../../shared/enums/account_mode.dart';
import '../../../shared/enums/user_role.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final SessionManager _sessionManager;

  AuthenticationRepositoryImpl({
    required AuthRemoteDatasource remoteDatasource,
    required SessionManager sessionManager,
  })  : _remoteDatasource = remoteDatasource,
        _sessionManager = sessionManager;

  @override
  Future<UserEntity> login({
    required String phoneOrEmail,
    required String password,
    bool rememberMe = true,
  }) async {
    final user = await _remoteDatasource.login(
      phoneOrEmail: phoneOrEmail,
      password: password,
    );

    await _sessionManager.saveSession(
      accessToken: 'token_${user.id}',
      role: user.role,
      mode: user.mode,
      profileId: user.id,
    );

    return user;
  }

  @override
  Future<UserEntity> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    return await _remoteDatasource.register(
      name: name,
      phone: phone,
      email: email,
      password: password,
    );
  }

  @override
  Future<bool> verifyOtp({
    required String phone,
    required String code,
  }) async {
    return await _remoteDatasource.verifyOtp(phone: phone, code: code);
  }

  @override
  Future<void> sendForgotPasswordCode(String phoneOrEmail) async {
    await _remoteDatasource.sendForgotPasswordCode(phoneOrEmail);
  }

  @override
  Future<void> resetPassword({
    required String phoneOrEmail,
    required String code,
    required String newPassword,
  }) async {
    await _remoteDatasource.resetPassword(
      phoneOrEmail: phoneOrEmail,
      code: code,
      newPassword: newPassword,
    );
  }

  @override
  Future<AuthToken> refreshToken(String refreshToken) async {
    return await _remoteDatasource.refreshToken(refreshToken);
  }

  @override
  Future<void> logout() async {
    await _sessionManager.clearSession();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final session = _sessionManager.currentSession;
    if (!session.isLoggedIn || session.profileId == null) return null;
    return UserEntity(
      id: session.profileId!,
      name: 'مستخدم نسيجي',
      email: 'user@naseeji.com',
      phone: '01000000000',
      role: session.role,
      mode: session.mode,
      isVerified: true,
      hasCompletedRegistration: true,
    );
  }

  @override
  Future<void> selectAccountType({
    required UserRole role,
    AccountMode mode = AccountMode.real,
  }) async {
    await _sessionManager.switchRole(role);
    await _sessionManager.switchMode(mode);
  }
}

