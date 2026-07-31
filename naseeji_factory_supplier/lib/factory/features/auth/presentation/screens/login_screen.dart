import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/auth_provider.dart';
import '../widgets/login_widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailOrPhoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authProvider.notifier)
          .login(_emailOrPhoneController.text.trim(), _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to Auth State to redirect
    ref.listen<AuthState>(authProvider, (previous, next) {
      next.maybeWhen(
        authenticated: (user) {
          if (user.isProfileCompleted) {
            context.go('/home');
          } else {
            context.go('/factory-type');
          }
        },
        googleCompleteRegistrationRequired: (_, _, _, _) {
          context.go('/complete-registration');
        },
        orElse: () {},
      );
    });

    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isKeyboardOpen ? AppSpacing.hMD : AppSpacing.hXXL,
                      LoginHeaderWidget(size: isKeyboardOpen ? 70 : 120),
                      isKeyboardOpen ? AppSpacing.hSM : AppSpacing.hXL,
                      const LoginWelcomeWidget(),
                      isKeyboardOpen ? AppSpacing.hMD : AppSpacing.hXL,
                      EmailOrPhoneFieldWidget(
                        controller: _emailOrPhoneController,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'يرجى إدخال البريد الإلكتروني أو رقم الهاتف';
                          }
                          return null;
                        },
                      ),
                      AppSpacing.hMD,
                      PasswordFieldWidget(
                        controller: _passwordController,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'يرجى إدخال كلمة المرور';
                          }
                          return null;
                        },
                      ),
                      AppSpacing.hSM,
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [RememberMeWidget(), ForgotPasswordWidget()],
                      ),
                      AppSpacing.hLG,
                      const ValidationMessageWidget(),
                      AppSpacing.hMD,
                      LoginButtonWidget(onPressed: _onLogin),
                      AppSpacing.hLG,
                      Center(
                        child: Text(
                          'أو',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                        ),
                      ),
                      AppSpacing.hLG,
                      const GoogleLoginButtonWidget(),
                      AppSpacing.hXL,
                      const CreateAccountWidget(),
                      AppSpacing.hMD,
                      Center(
                        child: TextButton(
                          onPressed: () {
                            ref.read(authProvider.notifier).loginAsGuest();
                          },
                          child: const Text(
                            'الدخول كزائر (تصفح فقط)',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const LoadingOverlayWidget(),
          ],
        ),
      ),
    );
  }
}

