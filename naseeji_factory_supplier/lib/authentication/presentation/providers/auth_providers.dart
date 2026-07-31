import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/session/session_provider.dart';
import '../../../shared/enums/account_mode.dart';
import '../../../shared/enums/user_role.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/authentication_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/authentication_repository.dart';

final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  return MockAuthRemoteDatasource();
});

final authenticationRepositoryProvider = Provider<AuthenticationRepository>((ref) {
  final remote = ref.watch(authRemoteDatasourceProvider);
  final sessionManager = ref.watch(sessionManagerProvider);
  return AuthenticationRepositoryImpl(
    remoteDatasource: remote,
    sessionManager: sessionManager,
  );
});

class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final UserEntity? user;
  final bool isOtpSent;
  final bool isVerified;

  const AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.user,
    this.isOtpSent = false,
    this.isVerified = false,
  });

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    UserEntity? user,
    bool? isOtpSent,
    bool? isVerified,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      user: user ?? this.user,
      isOtpSent: isOtpSent ?? this.isOtpSent,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final repo = ref.watch(authenticationRepositoryProvider);
  final sessionNotifier = ref.watch(sessionNotifierProvider.notifier);
  return AuthController(repo, sessionNotifier);
});

class AuthController extends StateNotifier<AuthState> {
  final AuthenticationRepository _repo;
  final SessionNotifier _sessionNotifier;

  AuthController(this._repo, this._sessionNotifier) : super(const AuthState());

  Future<bool> login(String phoneOrEmail, String password, {bool rememberMe = true}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _repo.login(
        phoneOrEmail: phoneOrEmail,
        password: password,
        rememberMe: rememberMe,
      );
      state = state.copyWith(isLoading: false, user: user);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await Future.delayed(const Duration(milliseconds: 700));
      const googleUser = UserEntity(
        id: 'USR-GOOGLE-001',
        name: 'مستخدم جوجل',
        email: 'google.user@naseeji.com',
        phone: '01011112222',
        role: UserRole.factory,
        mode: AccountMode.real,
        isVerified: true,
        hasCompletedRegistration: true,
      );
      state = state.copyWith(isLoading: false, user: googleUser);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<void> loginDemo(UserRole role) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    await Future.delayed(const Duration(milliseconds: 400));
    final demoUser = UserEntity(
      id: 'USR-DEMO-${role.name.toUpperCase()}',
      name: role == UserRole.factory ? 'مصنع نسيجي التجريبي' : 'مورد نسيجي التجريبي',
      email: 'demo@naseeji.com',
      phone: '01000000000',
      role: role,
      mode: AccountMode.demo,
      isVerified: true,
      hasCompletedRegistration: true,
    );
    await _sessionNotifier.switchRole(role);
    await _sessionNotifier.switchMode(AccountMode.demo);
    state = state.copyWith(isLoading: false, user: demoUser);
  }

  Future<bool> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _repo.register(
        name: name,
        phone: phone,
        email: email,
        password: password,
      );
      state = state.copyWith(isLoading: false, user: user, isOtpSent: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> verifyOtp(String phone, String code) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final success = await _repo.verifyOtp(phone: phone, code: code);
      if (success) {
        state = state.copyWith(isLoading: false, isVerified: true);
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'رمز التحقق غير صحيح',
        );
      }
      return success;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<void> selectRoleAndMode(UserRole role, AccountMode mode) async {
    await _repo.selectAccountType(role: role, mode: mode);
    await _sessionNotifier.switchRole(role);
    await _sessionNotifier.switchMode(mode);
  }

  Future<void> logout() async {
    await _repo.logout();
    await _sessionNotifier.logout();
    state = const AuthState();
  }
}
