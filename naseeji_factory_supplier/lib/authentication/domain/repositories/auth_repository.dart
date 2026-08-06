import '../../data/models/user_model.dart';
import '../../data/models/factory_profile_model.dart';
import '../../data/models/supplier_profile_model.dart';
import '../../data/models/wallet_model.dart';

abstract class AuthRepository {
  Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
    bool rememberMe = true,
  });

  Future<Map<String, dynamic>> registerFactory(Map<String, dynamic> data);

  Future<Map<String, dynamic>> registerSupplier(Map<String, dynamic> data);

  Future<Map<String, dynamic>> getCurrentUser();

  Future<void> logout();

  Future<bool> isAuthenticated();
}
