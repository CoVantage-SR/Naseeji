import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/register_usecase.dart';
import '../providers/register_state.dart';

class RegisterController extends StateNotifier<RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterController(this._registerUseCase) : super(const RegisterState());

  Future<bool> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
    required bool acceptedTerms,
  }) async {
    final errors = <String, String>{};

    if (name.trim().isEmpty) {
      errors['name'] = 'أدخل اسمك بالكامل';
    }
    if (email.trim().isEmpty || !email.contains('@')) {
      errors['email'] = 'أدخل بريدك الإلكتروني بشكل صحيح';
    }
    if (phone.trim().isEmpty || phone.trim().length < 8) {
      errors['phone'] = 'أدخل رقم هاتفك الصحيح';
    }
    if (password.isEmpty || password.length < 6) {
      errors['password'] = 'كلمة المرور يجب أن لا تقل عن 6 أحرف';
    }
    if (confirmPassword != password) {
      errors['confirmPassword'] = 'كلمة المرور غير متطابقة';
    }
    if (!acceptedTerms) {
      errors['terms'] = 'يجب الموافقة على الشروط والأحكام بالمتابعة';
    }

    if (errors.isNotEmpty) {
      state = state.copyWith(
        validationErrors: errors,
        errorMessage: errors.values.first,
      );
      return false;
    }

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      validationErrors: const {},
    );

    try {
      final user = await _registerUseCase.execute(
        name: name.trim(),
        phone: phone.trim(),
        email: email.trim(),
        password: password,
      );

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        registeredUser: user,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  void reset() {
    state = const RegisterState();
  }
}
