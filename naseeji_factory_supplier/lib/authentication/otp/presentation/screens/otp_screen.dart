import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/authentication/presentation/widgets/register_header.dart';
import 'package:naseeji_factory/authentication/presentation/widgets/register_logo.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/otp_provider.dart';
import '../widgets/countdown_timer.dart';
import '../widgets/otp_boxes.dart';
import '../widgets/resend_button.dart';
import '../widgets/verify_button.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String phone;

  const OtpScreen({super.key, required this.phone});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  String _currentLanguage = 'العربية';

  Future<void> _handleVerify() async {
    FocusScope.of(context).unfocus();
    final success = await ref
        .read(otpControllerProvider.notifier)
        .verifyOtp(widget.phone);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم التحقق بنجاح!'),
          backgroundColor: Colors.green,
        ),
      );
      context.push('/auth/reset-password', extra: widget.phone);
    } else if (mounted) {
      final err = ref.read(otpControllerProvider).errorMessage;
      if (err != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(err),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleResend() async {
    final success = await ref
        .read(otpControllerProvider.notifier)
        .resendOtp(widget.phone);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إعادة إرسال رمز التحقق بنجاح'),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final otpState = ref.watch(otpControllerProvider);

    return Scaffold(
      backgroundColor: isDark ? colorScheme.surface : const Color(0xFFFAFCFF),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: AbsorbPointer(
            absorbing: otpState.isLoading,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Top Header Bar
                RegisterHeader(
                  onBack: () => Navigator.of(context).pop(),
                  currentLanguage: _currentLanguage,
                  onLanguageChanged: (lang) {
                    setState(() {
                      _currentLanguage = lang;
                    });
                  },
                ),

                AppSpacing.hSM,

                // 2. Brand Identity Header
                const RegisterLogo(),

                AppSpacing.hMD,

                // 3. Title & Phone Subtitle Preview
                Text(
                  'رمز التحقق OTP',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? colorScheme.onSurface : const Color(0xFF1E293B),
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'أدخل كود التحقق المكون من 6 أرقام المرسل إلى الرقم',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF64748B),
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.phone,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),

                AppSpacing.hLG,

                // 4. 6 OTP Input Boxes
                OtpBoxes(
                  onChanged: (code) {
                    ref.read(otpControllerProvider.notifier).updateCode(code);
                  },
                  onCompleted: (code) {
                    ref.read(otpControllerProvider.notifier).updateCode(code);
                    _handleVerify();
                  },
                ),

                if (otpState.errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer.withValues(alpha: 0.3),
                      borderRadius: AppRadius.rSM,
                    ),
                    child: Text(
                      otpState.errorMessage!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],

                AppSpacing.hLG,

                // 5. Countdown Timer
                Center(
                  child: CountdownTimerWidget(
                    secondsRemaining: otpState.resendCountdown,
                  ),
                ),

                const SizedBox(height: 12),

                // 6. Resend Button
                ResendButton(
                  onResend: _handleResend,
                  canResend: otpState.canResend,
                  secondsRemaining: otpState.resendCountdown,
                ),

                AppSpacing.hXL,

                // 7. Primary Verify Button
                VerifyButton(
                  onPressed: _handleVerify,
                  isLoading: otpState.isLoading,
                ),

                AppSpacing.hLG,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
