import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_repository_impl.g.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;

  AuthRepositoryImpl(this._dio);

  @override
  Future<UserModel> login(String email, String password) async {
    // Simulate API delay for prototype/MVP
    await Future.delayed(const Duration(seconds: 1));
    
    // In a real application, you would do:
    // final response = await _dio.post('/auth/login', data: {'email': email, 'password': password});
    // return UserModel.fromJson(response.data);

    if (email == "test@naseeji.com" && password == "password") {
      return UserModel(id: '100', name: 'Naseeji Supplier', email: email);
    } else {
      throw Exception('Invalid email or password');
    }
  }
}

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final dioClient = ref.watch(dioProvider);
  return AuthRepositoryImpl(dioClient);
}
