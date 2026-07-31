import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../providers/auth_provider.dart';
import '../providers/otp_provider.dart';
import '../widgets/otp_widgets.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  String _otpCode = '';

  void _onVerify() async {
    if (_otpCode.length == 4) {
      await ref.read(otpVerificationProvider.notifier).verifyOtp(_otpCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final otpState = ref.watch(otpVerificationProvider);
    final isLoading = otpState.status == OtpStatus.loading;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    // Listen to verification success to login/route home
    ref.listen<OtpState>(otpVerificationProvider, (prev, next) {
      if (next.status == OtpStatus.verified) {
        // Authenticate the user successfully
        ref.read(authProvider.notifier).login('test@naseeji.com', 'dummy');
        context.go('/home');
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isKeyboardOpen ? AppSpacing.hSM : AppSpacing.hLG,
                const OtpHeaderWidget(),
                isKeyboardOpen ? AppSpacing.hLG : AppSpacing.hXL,
                OtpFieldWidget(
                  onCompleted: (code) {
                    setState(() {
                      _otpCode = code;
                    });
                  },
                ),
                AppSpacing.hLG,
                const OtpErrorWidget(),
                AppSpacing.hLG,
                const CountdownWidget(),
                const ResendWidget(),
                isKeyboardOpen ? AppSpacing.hLG : AppSpacing.hXXL,
                AppButton.primary(
                  text: 'تأكيد الرمز',
                  isLoading: isLoading,
                  onPressed: _otpCode.length == 4 ? _onVerify : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

