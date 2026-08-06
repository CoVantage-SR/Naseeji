import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/datasources/token_storage_service.dart';
import '../../data/models/user_model.dart';
import '../../data/models/factory_profile_model.dart';
import '../../data/models/supplier_profile_model.dart';
import '../../data/models/wallet_model.dart';
import 'auth_state.dart';

final tokenStorageProvider = Provider<TokenStorageService>((ref) {
  return TokenStorageService();
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);
  return AuthRemoteDataSource(tokenStorage: tokenStorage);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDS = ref.watch(authRemoteDataSourceProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);
  return AuthRepositoryImpl(remoteDataSource: remoteDS, tokenStorage: tokenStorage);
});

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository: repository);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository repository;

  AuthNotifier({required this.repository}) : super(AuthState.initial());

  Future<void> checkAuthStatus() async {
    state = AuthState.loading();
    try {
      final isAuth = await repository.isAuthenticated();
      if (!isAuth) {
        state = AuthState.unauthenticated();
        return;
      }

      final response = await repository.getCurrentUser();
      if (response['success'] == true) {
        final userData = response['data']['user'];
        final profileData = response['data']['profile'];
        final walletData = response['data']['wallet'];

        final user = UserModel.fromJson(userData);
        WalletModel? wallet = walletData != null ? WalletModel.fromJson(walletData) : null;
        FactoryProfileModel? factoryProfile;
        SupplierProfileModel? supplierProfile;

        if (user.role == UserRole.factory && profileData != null) {
          factoryProfile = FactoryProfileModel.fromJson(profileData);
        } else if (user.role == UserRole.supplier && profileData != null) {
          supplierProfile = SupplierProfileModel.fromJson(profileData);
        }

        if (user.status == UserStatus.pending) {
          state = AuthState.verificationPending(
            user: user,
            factoryProfile: factoryProfile,
            supplierProfile: supplierProfile,
          );
        } else {
          state = AuthState.authenticated(
            user: user,
            factoryProfile: factoryProfile,
            supplierProfile: supplierProfile,
            wallet: wallet,
          );
        }
      } else {
        state = AuthState.unauthenticated();
      }
    } catch (_) {
      state = AuthState.unauthenticated();
    }
  }

  Future<void> login({required String identifier, required String password}) async {
    state = AuthState.loading();
    try {
      final response = await repository.login(identifier: identifier, password: password);
      if (response['success'] == true) {
        await checkAuthStatus();
      } else {
        state = AuthState.error(response['message'] ?? 'Login failed');
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> logout() async {
    state = AuthState.loading();
    await repository.logout();
    state = AuthState.unauthenticated();
  }
}
