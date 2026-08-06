import '../../data/models/user_model.dart';
import '../../data/models/factory_profile_model.dart';
import '../../data/models/supplier_profile_model.dart';
import '../../data/models/wallet_model.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  verificationPending,
  error,
}

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final FactoryProfileModel? factoryProfile;
  final SupplierProfileModel? supplierProfile;
  final WalletModel? wallet;
  final String? errorMessage;

  AuthState({
    required this.status,
    this.user,
    this.factoryProfile,
    this.supplierProfile,
    this.wallet,
    this.errorMessage,
  });

  factory AuthState.initial() => AuthState(status: AuthStatus.initial);

  factory AuthState.loading() => AuthState(status: AuthStatus.loading);

  factory AuthState.authenticated({
    required UserModel user,
    FactoryProfileModel? factoryProfile,
    SupplierProfileModel? supplierProfile,
    WalletModel? wallet,
  }) =>
      AuthState(
        status: AuthStatus.authenticated,
        user: user,
        factoryProfile: factoryProfile,
        supplierProfile: supplierProfile,
        wallet: wallet,
      );

  factory AuthState.unauthenticated() => AuthState(status: AuthStatus.unauthenticated);

  factory AuthState.verificationPending({
    required UserModel user,
    FactoryProfileModel? factoryProfile,
    SupplierProfileModel? supplierProfile,
  }) =>
      AuthState(
        status: AuthStatus.verificationPending,
        user: user,
        factoryProfile: factoryProfile,
        supplierProfile: supplierProfile,
      );

  factory AuthState.error(String message) =>
      AuthState(status: AuthStatus.error, errorMessage: message);
}
