import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/factory/core/constants/app_colors.dart';
import 'package:naseeji_factory/factory/core/theme/app_theme.dart';
import 'package:naseeji_factory/factory/features/account/presentation/widgets/account_reusable_widgets.dart';
import 'package:naseeji_factory/supplier/core/session/session_tracker.dart';
import 'package:naseeji_factory/supplier/core/widgets/general_widgets.dart';
import 'package:naseeji_factory/supplier/features/auth/presentation/controllers/auth_controller.dart';
import 'package:naseeji_factory/supplier/features/auth/presentation/controllers/registration_controller.dart';

import 'widgets/otp_pin_fields.dart';
import 'widgets/otp_timer.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final List<TextEditingController> _pinControllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _pinControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  Future<bool> _resendCode() async {
    final success = await ref.read(registrationControllerProvider.notifier).sendOtp();
    if (!mounted) return false;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إعادة إرسال رمز التحقق بنجاح.')),
      );
      return true;
    } else {
      final errorMsg = ref.read(registrationControllerProvider).errorMessage ?? 'فشل إعادة إرسال الرمز';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg), backgroundColor: AppColors.error),
      );
      return false;
    }
  }

  Future<void> _verify() async {
    final code = _pinControllers.map((c) => c.text).join();
    if (code.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال رمز التحقق بالكامل'), backgroundColor: AppColors.error),
      );
      return;
    }

    final success = await ref.read(registrationControllerProvider.notifier).verifyOtp(code);
    if (mounted) {
      if (success) {
        // Finalize registration and submit to server
        final regSuccess = await ref.read(registrationControllerProvider.notifier).submitSupplierRegistration();
        if (mounted) {
          if (regSuccess) {
            // Start user session
            ref.read(sessionTrackerProvider.notifier).startSession("100");
            
            // Log in the user in the AuthController
            ref.read(authControllerProvider.notifier).login(
              ref.read(registrationControllerProvider).data.email,
              "DummyPassword123",
            );
            
            context.go('/home');
          } else {
            final errorMsg = ref.read(registrationControllerProvider).errorMessage ?? 'فشل إكمال التسجيل';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMsg), backgroundColor: AppColors.error),
            );
          }
        }
      } else {
        final errorMsg = ref.read(registrationControllerProvider).errorMessage ?? 'رمز التحقق غير صحيح';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registrationControllerProvider);
    final phone = state.data.phone;

    return Theme(
      data: AppTheme.darkTheme,
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'تأكيد رقم الجوال',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            body: SafeArea(
              child: LoadingOverlay(
                isLoading: state.isLoading,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'أدخل رمز التحقق',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'لقد أرسلنا رمز التحقق المكون من 4 أرقام إلى جوالك $phone',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 48),
                      OtpPinFields(
                        controllers: _pinControllers,
                        focusNodes: _focusNodes,
                      ),
                      SizedBox(height: 32),
                      OtpTimer(onResend: _resendCode),
                      const Spacer(),
                      PrimaryButton(
                        text: 'التحقق والمتابعة',
                        onPressed: _verify,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
