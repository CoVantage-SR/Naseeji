import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../providers/register_provider.dart';
import '../widgets/factory_banner.dart';
import '../widgets/register_button.dart';
import '../widgets/register_footer.dart';
import '../widgets/register_header.dart';
import '../widgets/register_logo.dart';
import '../widgets/register_textfields.dart';
import '../widgets/terms_checkbox.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _acceptedTerms = false;
  String _currentLanguage = 'العربية';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يجب الموافقة على الشروط والأحكام ومتابعة التسجيل'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    final success = await ref.read(registerControllerProvider.notifier).register(
          name: _nameController.text,
          phone: _phoneController.text,
          email: _emailController.text,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
          acceptedTerms: _acceptedTerms,
        );

    if (success && mounted) {
      context.push('/auth/otp', extra: {
        'phone': _phoneController.text.trim(),
        'isForgotPassword': false,
      });
    } else if (mounted) {
      final err = ref.read(registerControllerProvider).errorMessage;
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
    final registerState = ref.watch(registerControllerProvider);

    return Scaffold(
      backgroundColor: isDark ? colorScheme.surface : const Color(0xFFFAFCFF),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: AbsorbPointer(
            absorbing: registerState.isLoading,
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

                // 3. Stage Title
                Text(
                  'إنشاء حساب جديد (الخطوة 1 من 4)',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? colorScheme.onSurface : const Color(0xFF1E293B),
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'أدخل بياناتك الشخصية الأساسية للبدء في التسجيل',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF64748B),
                    fontSize: 13.5,
                  ),
                ),

                AppSpacing.hLG,

                // 4. Form TextFields (Full Name, Phone, Email opt, Password, Confirm Password)
                Form(
                  key: _formKey,
                  child: RegisterTextFields(
                    nameController: _nameController,
                    emailController: _emailController,
                    phoneController: _phoneController,
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
                  ),
                ),

                const SizedBox(height: 12),

                // 5. Terms Checkbox
                TermsCheckbox(
                  accepted: _acceptedTerms,
                  onChanged: (val) {
                    setState(() {
                      _acceptedTerms = val;
                    });
                  },
                ),

                if (registerState.errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer.withValues(alpha: 0.3),
                      borderRadius: AppRadius.rSM,
                    ),
                    child: Text(
                      registerState.errorMessage!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],

                AppSpacing.hLG,

                // 6. Register Button
                RegisterButton(
                  onPressed: _handleRegister,
                  isLoading: registerState.isLoading,
                ),

                AppSpacing.hLG,

                // 7. Footer Divider & Login Link
                RegisterFooter(
                  onLogin: () => context.go('/auth/login'),
                ),

                AppSpacing.hLG,

                const FactoryBanner(),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
