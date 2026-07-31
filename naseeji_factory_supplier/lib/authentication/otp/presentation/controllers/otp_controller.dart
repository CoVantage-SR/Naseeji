import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/resend_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../providers/otp_state.dart';

class OtpController extends StateNotifier<OtpState> {
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ResendOtpUseCase _resendOtpUseCase;
  Timer? _timer;

  OtpController(this._verifyOtpUseCase, this._resendOtpUseCase)
      : super(const OtpState()) {
    startResendTimer();
  }

  void startResendTimer() {
    _timer?.cancel();
    state = state.copyWith(resendCountdown: 60, canResend: false);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.resendCountdown <= 1) {
        timer.cancel();
        state = state.copyWith(resendCountdown: 0, canResend: true);
      } else {
        state = state.copyWith(resendCountdown: state.resendCountdown - 1);
      }
    });
  }

  void updateCode(String code) {
    state = state.copyWith(code: code, errorMessage: null);
  }

  Future<bool> verifyOtp(String phone) async {
    if (state.code.length < 6) {
      state = state.copyWith(errorMessage: 'يرجى أدخل كود التحقق المكون من 6 أرقام');
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final success = await _verifyOtpUseCase.execute(
        phone: phone,
        code: state.code,
      );

      if (success) {
        state = state.copyWith(isLoading: false, isVerified: true);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'رمز التحقق غير صحيح. يرجى التأكد وإعادة المحاولة',
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

  Future<bool> resendOtp(String phone) async {
    if (!state.canResend) return false;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final success = await _resendOtpUseCase.execute(phone: phone);
      if (success) {
        state = state.copyWith(isLoading: false);
        startResendTimer();
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'فشل إعادة إرسال الرمز. حاول لاحقاً',
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
