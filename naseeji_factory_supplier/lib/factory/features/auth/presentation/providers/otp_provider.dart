import 'dart:async';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'otp_provider.freezed.dart';
part 'otp_provider.g.dart';

enum OtpStatus {
  initial,
  loading,
  verified,
  expired,
  error,
}

@freezed
class OtpState with _$OtpState {
  const factory OtpState({
    @Default(60) int countdown,
    @Default(OtpStatus.initial) OtpStatus status,
    @Default('') String errorMessage,
  }) = _OtpState;
}

@riverpod
class OtpVerification extends _$OtpVerification {
  Timer? _timer;

  @override
  OtpState build() {
    ref.onDispose(() => _timer?.cancel());
    return const OtpState();
  }

  void startCountdown() {
    _timer?.cancel();
    state = state.copyWith(countdown: 60, status: OtpStatus.initial, errorMessage: '');
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.countdown > 0) {
        state = state.copyWith(countdown: state.countdown - 1);
      } else {
        _timer?.cancel();
        state = state.copyWith(status: OtpStatus.expired);
      }
    });
  }

  Future<void> verifyOtp(String code) async {
    if (code.length != 4) {
      state = state.copyWith(status: OtpStatus.error, errorMessage: 'يجب إدخال 4 أرقام');
      return;
    }
    
    state = state.copyWith(status: OtpStatus.loading);
    await Future.delayed(const Duration(milliseconds: 1500)); // Mock network verify

    // For testing, mock code "1234" is correct
    if (code == '1234') {
      _timer?.cancel();
      state = state.copyWith(status: OtpStatus.verified);
    } else {
      state = state.copyWith(status: OtpStatus.error, errorMessage: 'رمز التحقق غير صحيح. جرب 1234');
    }
  }

  void reset() {
    _timer?.cancel();
    state = const OtpState();
    startCountdown();
  }
}

