import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/core/constants/app_colors.dart';
import 'package:naseeji_factory/core/constants/app_radius.dart';
import 'package:naseeji_factory/core/constants/app_spacing.dart';
import 'package:naseeji_factory/core/widgets/app_buttons.dart';
import 'package:naseeji_factory/core/widgets/app_text_fields.dart';
import '../../providers/registration_provider.dart';
import '../../providers/otp_provider.dart';
import '../register_widgets.dart';
import '../otp_widgets.dart';
import '../reusable_registration_widgets.dart';

class RegisterFormWidget extends ConsumerStatefulWidget {
  const RegisterFormWidget({super.key});

  @override
  ConsumerState<RegisterFormWidget> createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends ConsumerState<RegisterFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _termsAccepted = false;
  String _passwordText = '';

  // Inline OTP states
  bool _otpSent = false;
  bool _phoneVerified = false;
  String _otpCode = '';

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      setState(() {
        _passwordText = _passwordController.text;
      });
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_formKey.currentState!.validate() && _termsAccepted) {
      ref.read(registrationProvider.notifier).updateBasicInfo(
            factoryName: '',
            ownerName: '',
            phone: _phoneController.text.trim(),
            email: '',
            governorate: '',
            city: '',
            employeesRange: '1-10',
            description: '',
          );
      context.push('/factory-type');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final otpState = ref.watch(otpVerificationProvider);
    final isOtpLoading = otpState.status == OtpStatus.loading;

    // Listen to verification success
    ref.listen<OtpState>(otpVerificationProvider, (prev, next) {
      if (next.status == OtpStatus.verified) {
        setState(() {
          _phoneVerified = true;
        });
        ref.read(registrationProvider.notifier).updateBasicInfo(
              factoryName: '',
              ownerName: '',
              phone: _phoneController.text.trim(),
              email: '',
              governorate: '',
              city: '',
              employeesRange: '1-10',
              description: '',
            );
      }
    });

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RegistrationProgress(currentStep: 1, totalSteps: 4),
          isKeyboardOpen ? AppSpacing.hSM : AppSpacing.hLG,
          RegisterHeaderWidget(compact: isKeyboardOpen),
          isKeyboardOpen ? AppSpacing.hMD : AppSpacing.hXL,
          
          // Phone input field (Disabled once verified)
          AbsorbPointer(
            absorbing: _phoneVerified,
            child: PhoneFieldWidget(controller: _phoneController),
          ),
          AppSpacing.hMD,

          // 1. Send OTP Button (Only if not sent and not verified)
          if (!_otpSent && !_phoneVerified) ...[
            ElevatedButton(
              onPressed: () {
                if (_phoneController.text.trim().length >= 11) {
                  ref.read(otpVerificationProvider.notifier).reset();
                  setState(() {
                    _otpSent = true;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('يرجى إدخال رقم هاتف صحيح')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
              ),
              child: const Text('أرسل رمز التحقق (OTP)'),
            ),
          ],

          // 2. OTP Verification Panel (If sent and not verified)
          if (_otpSent && !_phoneVerified) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: AppRadius.rMD,
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppColors.borderLight
                      : AppColors.borderDark,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'أدخل رمز التحقق المرسل لهاتفك (1234 للتجربة):',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  AppSpacing.hMD,
                  OtpFieldWidget(
                    onCompleted: (code) {
                      setState(() {
                        _otpCode = code;
                      });
                    },
                  ),
                  AppSpacing.hMD,
                  const OtpErrorWidget(),
                  AppSpacing.hSM,
                  const CountdownWidget(),
                  const ResendWidget(),
                  AppSpacing.hMD,
                  ElevatedButton(
                    onPressed: _otpCode.length == 4
                        ? () {
                            ref.read(otpVerificationProvider.notifier).verifyOtp(_otpCode);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                    ),
                    child: isOtpLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('تأكيد الرمز'),
                  ),
                ],
              ),
            ),
          ],

          // 3. Success Panel & Password Inputs (Shown after phone verification is successful)
          if (_phoneVerified) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: AppRadius.rMD,
                border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: AppColors.success),
                  AppSpacing.wSM,
                  Expanded(
                    child: Text(
                      'تم التحقق من رقم الهاتف بنجاح.',
                      style: TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.hLG,
            AppPasswordField(
              labelText: 'كلمة المرور',
              controller: _passwordController,
            ),
            AppSpacing.hSM,
            PasswordStrengthWidget(password: _passwordText),
            AppSpacing.hMD,
            ConfirmPasswordFieldWidget(
              controller: _confirmPasswordController,
              passwordController: _passwordController,
            ),
            AppSpacing.hMD,
            TermsCheckboxWidget(
              onChanged: (val) {
                setState(() {
                  _termsAccepted = val;
                });
              },
            ),
            AppSpacing.hXL,
            AppButton.primary(
              text: 'متابعة',
              onPressed: _termsAccepted ? _onContinue : null,
            ),
          ],
          AppSpacing.hLG,
          const AlreadyHaveAccountWidget(),
        ],
      ),
    );
  }
}
