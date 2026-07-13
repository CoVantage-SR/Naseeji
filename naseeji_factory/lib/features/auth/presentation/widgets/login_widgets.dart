import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_logo.dart';
import '../providers/auth_provider.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: AppLogo(size: 120, showText: false));
  }
}

class LoginWelcomeWidget extends StatelessWidget {
  const LoginWelcomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'تسجيل الدخول',
          style: context.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        AppSpacing.hXS,
        Text(
          'مرحباً بك مجدداً، سجل دخولك للمتابعة في نسيجي مصنع',
          style: context.textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).brightness == Brightness.light
                ? AppColors.textSecondaryLight
                : AppColors.textSecondaryDark,
          ),
        ),
      ],
    );
  }
}

class EmailOrPhoneFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const EmailOrPhoneFieldWidget({
    super.key,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      textAlign: TextAlign.right,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'البريد الإلكتروني أو رقم الهاتف',
        prefixIcon: Icon(Icons.person_outline_rounded),
      ),
    );
  }
}

class PasswordFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const PasswordFieldWidget({
    super.key,
    required this.controller,
    this.validator,
  });

  @override
  State<PasswordFieldWidget> createState() => _PasswordFieldWidgetState();
}

class _PasswordFieldWidgetState extends State<PasswordFieldWidget> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscureText: _obscureText,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        labelText: 'كلمة المرور',
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText
                ? Icons.visibility_off_rounded
                : Icons.visibility_rounded,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}

class RememberMeWidget extends StatefulWidget {
  const RememberMeWidget({super.key});

  @override
  State<RememberMeWidget> createState() => _RememberMeWidgetState();
}

class _RememberMeWidgetState extends State<RememberMeWidget> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: _isChecked,
          activeColor: AppColors.primary,
          onChanged: (val) {
            setState(() {
              _isChecked = val ?? false;
            });
          },
        ),
        Text('تذكرني', style: context.textTheme.bodyMedium),
      ],
    );
  }
}

class ForgotPasswordWidget extends StatelessWidget {
  const ForgotPasswordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Text(
        'نسيت كلمة المرور؟',
        style: context.textTheme.bodyMedium?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class LoginButtonWidget extends ConsumerWidget {
  final VoidCallback onPressed;

  const LoginButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    return AppButton.primary(
      text: 'تسجيل الدخول',
      isLoading: isLoading,
      onPressed: onPressed,
    );
  }
}

class GoogleLoginButtonWidget extends ConsumerWidget {
  const GoogleLoginButtonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton(
      onPressed: () => ref.read(authProvider.notifier).loginWithGoogle(),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        side: const BorderSide(color: AppColors.borderLight, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.g_mobiledata_rounded,
            size: 28,
            color: AppColors.primary,
          ),
          AppSpacing.wXS,
          Text(
            'تسجيل الدخول باستخدام Google',
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class CreateAccountWidget extends StatelessWidget {
  const CreateAccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('ليس لديك حساب مصنع؟ ', style: context.textTheme.bodyMedium),
        TextButton(
          onPressed: () => context.push('/register'),
          child: const Text(
            'سجل حسابك الآن',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class ValidationMessageWidget extends ConsumerWidget {
  const ValidationMessageWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final errorMessage = authState.maybeWhen(
      error: (msg) => msg,
      orElse: () => '',
    );

    if (errorMessage.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: AppRadius.rMD,
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.error),
          AppSpacing.wSM,
          Expanded(
            child: Text(
              errorMessage,
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingOverlayWidget extends ConsumerWidget {
  const LoadingOverlayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    if (!isLoading) return const SizedBox.shrink();

    return Container(
      color: Colors.black45,
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}
