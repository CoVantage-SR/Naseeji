import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/general_widgets.dart';
import '../providers/auth_providers.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String phone;

  const OtpScreen({super.key, required this.phone});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _onVerify() async {
    final code = _otpController.text.trim();
    if (code.length >= 4) {
      final success = await ref.read(authControllerProvider.notifier).verifyOtp(
            widget.phone,
            code,
          );

      if (success && mounted) {
        context.go('/auth/choose-account-type');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('رمز التحقق'),
      ),
      body: LoadingOverlay(
        isLoading: authState.isLoading,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'أدخل رمز التحقق (OTP)',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'تم إرسال رمز التحقق المكون من 4 أرقام إلى ${widget.phone}',
                  style: const TextStyle(color: AppColors.outline),
                ),
                const SizedBox(height: 48),
                CustomTextField(
                  controller: _otpController,
                  labelText: 'رمز التحقق',
                  hintText: '1234',
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.phonelink_ring_rounded,
                ),
                if (authState.errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    authState.errorMessage!,
                    style: const TextStyle(color: AppColors.error, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ],
                const Spacer(),
                PrimaryButton(
                  text: 'تأكيد الرمز',
                  onPressed: _onVerify,
                  isLoading: authState.isLoading,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


