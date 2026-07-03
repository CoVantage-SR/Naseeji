import '../models/user_model.dart';
import '../entities/supplier_registration_data.dart';

abstract class AuthRepository {
  Future<UserModel> login(String email, String password);
  Future<void> sendOtp(String phone);
  Future<UserModel> verifyOtp(String phone, String code);
  Future<void> registerSupplier(SupplierRegistrationData data);
}
