// ignore_for_file: prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/supplier_registration_data.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_repository_impl.g.dart';

class AuthRepositoryImpl implements AuthRepository {
  // ignore: unused_field
  final Dio _dio;

  AuthRepositoryImpl(this._dio);

  @override
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email.isNotEmpty && password.length >= 6) {
      return UserModel(id: '100', name: 'Naseeji Supplier', email: email);
    } else {
      throw Exception('البريد الإلكتروني أو كلمة المرور غير صالحة');
    }
  }

  @override
  Future<void> sendOtp(String phone) async {
    // Simulate sending OTP via SMS
    await Future.delayed(const Duration(seconds: 1));
    if (phone.isEmpty) {
      throw Exception('رقم الهاتف مطلوب');
    }
  }

  @override
  Future<UserModel> verifyOtp(String phone, String code) async {
    // Simulate OTP verification
    await Future.delayed(const Duration(seconds: 1));
    if (code == "1234") {
      return UserModel(id: '100', name: 'Naseeji Supplier', email: 'verified@naseeji.com');
    } else {
      throw Exception('رمز التحقق غير صحيح. جرب رمز 1234');
    }
  }

  @override
  Future<void> registerSupplier(SupplierRegistrationData data) async {
    // Simulate registration API call
    await Future.delayed(const Duration(milliseconds: 1500));
    if (data.companyName.isEmpty) {
      throw Exception('اسم الشركة مطلوب لإكمال التسجيل');
    }
  }
}

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final dioClient = ref.watch(dioProvider);
  return AuthRepositoryImpl(dioClient);
}
