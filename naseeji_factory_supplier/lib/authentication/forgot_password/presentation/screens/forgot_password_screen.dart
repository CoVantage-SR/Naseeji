import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/authentication/presentation/widgets/register_logo.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/forgot_password_provider.dart';
import '../widgets/forgot_header.dart';
import '../widgets/phone_field.dart';
import '../widgets/send_code_button.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController(text: '01000000000');
  String _selectedCountryCode = '+20';
  String _currentLanguage = 'العربية';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSendResetCode() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();
    final phoneOrEmail = '$_selectedCountryCode${_phoneController.text.trim()}';

    final success = await ref
        .read(forgotPasswordControllerProvider.notifier)
        .sendResetCode(phoneOrEmail);

    if (success && mounted) {
      context.push('/auth/otp', extra: {
        'phone': phoneOrEmail,
        'isForgotPassword': true,
      });
    } else if (mounted) {
      final err = ref.read(forgotPasswordControllerProvider).errorMessage;
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final state = ref.watch(forgotPasswordControllerProvider);

    return Scaffold(
      backgroundColor: isDark ? colorScheme.surface : const Color(0xFFFAFCFF),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: AbsorbPointer(
            absorbing: state.isLoading,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. AppBar / Header with Back Button
                ForgotHeader(
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

                // 3. Title & Subtitle
                Text(
                  'استعادة كلمة المرور',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? colorScheme.onSurface : const Color(0xFF1E293B),
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'أدخل رقم هاتفك أو بريدك الإلكتروني وسيتم إرسال كود التحقق لاستعادة الحساب',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF64748B),
                    fontSize: 13.5,
                  ),
                ),

                AppSpacing.hLG,

                // 4. Form Field
                Form(
                  key: _formKey,
                  child: PhoneField(
                    controller: _phoneController,
                    selectedCountryCode: _selectedCountryCode,
                    onCountryCodeChanged: (code) {
                      setState(() {
                        _selectedCountryCode = code;
                      });
                    },
                  ),
                ),

                if (state.errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer.withValues(alpha: 0.3),
                      borderRadius: AppRadius.rSM,
                    ),
                    child: Text(
                      state.errorMessage!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],

                AppSpacing.hXL,

                // 5. Send Code Button
                SendCodeButton(
                  onPressed: _handleSendResetCode,
                  isLoading: state.isLoading,
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
