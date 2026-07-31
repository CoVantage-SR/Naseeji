import '../entities/supplier_registration_data.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class SendOtpUseCase {
  final AuthRepository _repository;

  SendOtpUseCase(this._repository);

  Future<void> execute(String phone) {
    return _repository.sendOtp(phone);
  }
}

class VerifyOtpUseCase {
  final AuthRepository _repository;

  VerifyOtpUseCase(this._repository);

  Future<UserModel> execute(String phone, String code) {
    return _repository.verifyOtp(phone, code);
  }
}

class RegisterSupplierUseCase {
  final AuthRepository _repository;

  RegisterSupplierUseCase(this._repository);

  Future<void> execute(SupplierRegistrationData data) {
    return _repository.registerSupplier(data);
  }
}
