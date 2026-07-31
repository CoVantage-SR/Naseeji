import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/send_reset_code_usecase.dart';
import '../providers/forgot_password_state.dart';

class ForgotPasswordController extends StateNotifier<ForgotPasswordState> {
  final SendResetCodeUseCase _sendResetCodeUseCase;

  ForgotPasswordController(this._sendResetCodeUseCase)
      : super(const ForgotPasswordState());

  Future<bool> sendResetCode(String phoneOrEmail) async {
    if (phoneOrEmail.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'يرجى إدخال رقم الهاتف أو البريد الإلكتروني');
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final success = await _sendResetCodeUseCase.execute(phoneOrEmail.trim());
      if (success) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
          phoneOrEmail: phoneOrEmail.trim(),
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'فشل إرسال رمز التحقق. يرجى المحاولة لاحقاً',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  void reset() {
    state = const ForgotPasswordState();
  }
}
