import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.freezed.dart';
part 'auth_provider.g.dart';

@freezed
class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String uid,
    required String email,
    required String name,
    required String phone,
    required String photoUrl,
    required bool isProfileCompleted,
  }) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) => _$AuthUserFromJson(json);
}

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(AuthUser user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.googleCompleteRegistrationRequired({
    required String uid,
    required String email,
    required String name,
    required String photoUrl,
  }) = _GoogleCompleteRegistrationRequired;
  const factory AuthState.error(String message) = _Error;
}

@riverpod
class Auth extends _$Auth {
  @override
  AuthState build() {
    return const AuthState.unauthenticated();
  }

  Future<void> login(String emailOrPhone, String password) async {
    state = const AuthState.loading();
    await Future.delayed(const Duration(seconds: 1)); // Mock network delay
    
    if (emailOrPhone.contains('@') &&
        !emailOrPhone.contains('test@naseeji.com') &&
        !emailOrPhone.contains('factory@naseeji.com')) {
      state = const AuthState.error('الحساب غير موجود أو كلمة المرور خاطئة');
      return;
    }

    state = const AuthState.authenticated(
      AuthUser(
        uid: 'user_123',
        email: 'test@naseeji.com',
        name: 'مصنع النيل للنسيج',
        phone: '01012345678',
        photoUrl: '',
        isProfileCompleted: true,
      ),
    );
  }

  Future<void> loginWithGoogle() async {
    state = const AuthState.loading();
    await Future.delayed(const Duration(seconds: 1)); // Mock Google pop-up
    
    // Simulate first-time Google sign-in requiring phone completion
    state = const AuthState.googleCompleteRegistrationRequired(
      uid: 'google_user_999',
      email: 'ahmed.naseeji@gmail.com',
      name: 'أحمد النساج',
      photoUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
    );
  }

  void completeGoogleRegistration(String phone) {
    if (state is! _GoogleCompleteRegistrationRequired) return;
    
    final current = state as _GoogleCompleteRegistrationRequired;
    state = AuthState.authenticated(
      AuthUser(
        uid: current.uid,
        email: current.email,
        name: current.name,
        phone: phone,
        photoUrl: current.photoUrl,
        isProfileCompleted: false, // will go to select factory type
      ),
    );
  }

  void logout() {
    state = const AuthState.unauthenticated();
  }
}
