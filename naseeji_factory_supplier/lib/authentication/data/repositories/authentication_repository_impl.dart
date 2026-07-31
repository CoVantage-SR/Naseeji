import '../../../core/session/session_manager.dart';
import '../../../shared/enums/account_mode.dart';
import '../../../shared/enums/user_role.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthRemoteDatasource remoteDatasource;
  final SessionManager sessionManager;

  AuthenticationRepositoryImpl({
    required this.remoteDatasource,
    required this.sessionManager,
  });

  @override
  Future<UserEntity> login({
    required String phoneOrEmail,
    required String password,
    bool rememberMe = true,
  }) async {
    final user = await remoteDatasource.login(
      phoneOrEmail: phoneOrEmail,
      password: password,
    );

    await sessionManager.saveSession(
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
    return await remoteDatasource.register(
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
    return await remoteDatasource.verifyOtp(phone: phone, code: code);
  }

  @override
  Future<void> sendForgotPasswordCode(String phoneOrEmail) async {
    await remoteDatasource.sendForgotPasswordCode(phoneOrEmail);
  }

  @override
  Future<void> resetPassword({
    required String phoneOrEmail,
    required String code,
    required String newPassword,
  }) async {
    await remoteDatasource.resetPassword(
      phoneOrEmail: phoneOrEmail,
      code: code,
      newPassword: newPassword,
    );
  }

  @override
  Future<AuthToken> refreshToken(String refreshToken) async {
    return await remoteDatasource.refreshToken(refreshToken);
  }

  @override
  Future<void> logout() async {
    await sessionManager.clearSession();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final session = sessionManager.currentSession;
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
    await sessionManager.switchRole(role);
    await sessionManager.switchMode(mode);
  }
}
